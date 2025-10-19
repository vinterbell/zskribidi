const skb = @import("zskribidi").bindings;
const gl = @import("gl");

const Renderer = @This();

pub const Vertex = extern struct {
    pos: skb.Vec2,
    color: skb.Color,
};

pub fn init(self: *Renderer, gpa: std.mem.Allocator, config: ?*const skb.ImageAtlasConfig) !void {
    self.gpa = gpa;

    self.temp_alloc = try skb.TempAlloc.create(512 * 1024);
    errdefer self.temp_alloc.destroy();

    self.atlas = try skb.ImageAtlas.create(config);
    errdefer self.atlas.destroy();
    self.atlas.setCreateTextureCallback(onCreateTexture, self);

    self.rasterizer = try skb.Rasterizer.create(null);
    errdefer self.rasterizer.destroy();

    try self.glInit();
}

pub fn deinit(self: *Renderer) void {
    self.glDeinit();

    self.atlas.destroy();
    self.rasterizer.destroy();
    self.temp_alloc.destroy();

    self.* = undefined;
}

pub fn beginFrame(self: *Renderer, width: u32, height: u32) void {
    self.view_width = width;
    self.view_height = height;

    self.transform_stack_index = 0;
    self.transform_stack[0] = .{
        .dx = 0.0,
        .dy = 0.0,
        .scale = 1.0,
    };

    _ = self.atlas.compact();
}

pub fn endFrame(self: *Renderer) !void {
    try self.updateAtlas();

    if (self.vertices.items.len == 0 or self.batches.items.len == 0) {
        self.vertices.clearRetainingCapacity();
        self.batches.clearRetainingCapacity();
        return;
    }

    try self.glFlush();
}

pub fn resetAtlas(self: *Renderer, new_config: skb.ImageAtlasConfig) !void {
    self.atlas.destroy();
    self.atlas = try skb.ImageAtlas.create(new_config);
    self.atlas.setCreateTextureCallback(onCreateTexture, self);

    for (self.textures.items) |*tex| {
        if (tex.gl.tex != 0) {
            gl.DeleteTextures(1, &tex.gl.tex);
            tex.gl.tex = 0;
        }
    }
    self.textures.clearRetainingCapacity();
}

/// cpu . gpu copies
pub fn updateAtlas(self: *Renderer) !void {
    _ = self.atlas.rasterizeMissingItems(self.temp_alloc, self.rasterizer);
    for (0..@as(usize, @intCast(self.atlas.getTextureCount()))) |i| {
        const dirty_bounds = self.atlas.getAndResetTextureDirtyBounds(@intCast(i));
        if (dirty_bounds.isEmpty()) continue;
        const image = self.atlas.getTexture(@intCast(i)) orelse continue;
        const tex_id: u32 = @intCast(self.atlas.getTextureUserData(@intCast(i)));
        if (tex_id == 0) {
            const new_tex_id = try self.createTexture(
                image.width,
                image.height,
                image.stride_bytes,
                image.buffer orelse &.{},
                image.bpp,
            );
            self.atlas.setTextureUserData(@intCast(i), @intCast(new_tex_id));
        } else {
            try self.updateTexture(
                tex_id,
                dirty_bounds.x,
                dirty_bounds.y,
                dirty_bounds.width,
                dirty_bounds.height,
                image.stride_bytes,
                image.buffer orelse &.{},
            );
        }
    }
}

pub fn pushTransform(self: *Renderer, offset_x: f32, offset_y: f32, scale: f32) void {
    if (self.transform_stack_index + 1 >= transform_stack_size) {
        return;
    }
    self.transform_stack_index += 1;
    self.transform_stack[self.transform_stack_index] = .{
        .dx = offset_x,
        .dy = offset_y,
        .scale = scale,
    };
}

pub fn popTransform(self: *Renderer) void {
    if (self.transform_stack_index == 0) {
        return;
    }
    self.transform_stack_index -= 1;
}

pub fn getTransformScale(self: *Renderer) f32 {
    return self.transform_stack[self.transform_stack_index].scale;
}

pub fn getTransformOffset(self: *Renderer) skb.Vec2 {
    const t = self.transform_stack[self.transform_stack_index];
    return .{ .x = t.dx, .y = t.dy };
}

pub fn transformRect(self: *Renderer, rect: skb.Rect2) skb.Rect2 {
    const xform = self.transform_stack[self.transform_stack_index];
    return .{
        .x = xform.dx + rect.x * xform.scale,
        .y = xform.dy + rect.y * xform.scale,
        .width = rect.width * xform.scale,
        .height = rect.height * xform.scale,
    };
}

pub fn invTransformRect(self: *Renderer, rect: skb.Rect2) skb.Rect2 {
    const xform = self.transform_stack[self.transform_stack_index];
    return .{
        .x = (rect.x - xform.dx) / xform.scale,
        .y = (rect.y - xform.dy) / xform.scale,
        .width = rect.width / xform.scale,
        .height = rect.height / xform.scale,
    };
}

pub fn createTexture(
    self: *Renderer,
    width: i32,
    height: i32,
    img_stride_bytes: i32,
    img_data: [*]const u8,
    bpp: u8,
) !u32 {
    const tex: *Texture = try self.textures.addOne(self.gpa);
    tex.* = .{
        .id = @intCast(self.textures.items.len), // 1-based
    };

    try glCreateTexture(
        tex,
        width,
        height,
        img_stride_bytes,
        img_data,
        bpp,
    );

    return tex.id;
}

pub fn updateTexture(
    self: *Renderer,
    handle: u32,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    img_stride_bytes: i32,
    img_data: [*]const u8,
) !void {
    const tex = self.findTexture(handle) orelse return error.InvalidTextureHandle;
    if (tex.width != width or tex.height != height) {
        try glCreateTexture(
            tex,
            width,
            height,
            img_stride_bytes,
            img_data,
            tex.bpp,
        );
    } else {
        try glUpdateTexture(
            tex,
            x,
            y,
            width,
            height,
            img_stride_bytes,
            img_data,
        );
    }
}

pub fn drawDebugTris(self: *Renderer, vertices: []const Vertex) void {
    const xform = self.transform_stack[self.transform_stack_index];

    var gpu_vertices: [16 * 3]GPUVertex = undefined;
    var vtx_count: usize = 0;

    for (vertices) |v| {
        const pos = v.pos;
        const color = v.color;

        gpu_vertices[vtx_count] = .{
            .pos = .{ xform.dx + pos.x * xform.scale, xform.dy + pos.y * xform.scale },
            .color = .{ color.r, color.g, color.b, color.a },
        };

        vtx_count += 1;

        if (vtx_count >= gpu_vertices.len) {
            self.pushTriangles(&gpu_vertices[0..vtx_count], 0, 0);
            vtx_count = 0;
        }
    }

    if (vtx_count > 0) {
        self.pushTriangles(&gpu_vertices[0..vtx_count], 0, 0);
    }
}

pub fn drawQuad(
    self: *Renderer,
    quad: skb.Quad,
) !void {
    const geom = self.transformRect(quad.geom);
    const x0 = geom.x;
    const y0 = geom.y;
    const x1 = geom.x + geom.width;
    const y1 = geom.y + geom.height;
    const @"u0" = quad.pattern.x;
    const v0 = quad.pattern.y;
    const @"u1" = quad.pattern.x + quad.pattern.width;
    const v1 = quad.pattern.y + quad.pattern.height;
    const tex_pos: [2]f32 = .{ quad.texture.x, quad.texture.y };
    const tex_size: [2]f32 = .{ quad.texture.width, quad.texture.height };
    const scale = quad.scale;
    const tint: [4]u8 = .{ quad.color.r, quad.color.g, quad.color.b, quad.color.a };

    var verts: [6]GPUVertex = undefined;
    verts[0] = .{
        .pos = .{ x0, y0 },
        .uv = .{ @"u0", v0 },
        .atlas_pos = tex_pos,
        .atlas_size = tex_size,
        .color = tint,
        .scale = scale,
    };
    verts[1] = .{
        .pos = .{ x1, y0 },
        .uv = .{ @"u1", v0 },
        .atlas_pos = tex_pos,
        .atlas_size = tex_size,
        .color = tint,
        .scale = scale,
    };
    verts[2] = .{
        .pos = .{ x1, y1 },
        .uv = .{ @"u1", v1 },
        .atlas_pos = tex_pos,
        .atlas_size = tex_size,
        .color = tint,
        .scale = scale,
    };
    verts[3] = .{
        .pos = .{ x0, y0 },
        .uv = .{ @"u0", v0 },
        .atlas_pos = tex_pos,
        .atlas_size = tex_size,
        .color = tint,
        .scale = scale,
    };
    verts[4] = .{
        .pos = .{ x1, y1 },
        .uv = .{ @"u1", v1 },
        .atlas_pos = tex_pos,
        .atlas_size = tex_size,
        .color = tint,
        .scale = scale,
    };
    verts[5] = .{
        .pos = .{ x0, y1 },
        .uv = .{ @"u0", v1 },
        .atlas_pos = tex_pos,
        .atlas_size = tex_size,
        .color = tint,
        .scale = scale,
    };

    const tex_id = self.atlas.getTextureUserData(@intCast(quad.texture_idx));

    if (quad.flags.is_sdf) {
        try self.pushTriangles(&verts, 0, @intCast(tex_id));
    } else {
        try self.pushTriangles(&verts, @intCast(tex_id), 0);
    }
}

pub fn drawGlyph(
    self: *Renderer,
    offset_x: f32,
    offset_y: f32,
    font_collection: *skb.FontCollection,
    font_handle: skb.FontHandle,
    glyph_id: u32,
    font_size: f32,
    color: skb.Color,
    alpha_mode: skb.RasterizerAlphaMode,
) !void {
    const quad = self.atlas.getGlyphQuad(
        offset_x,
        offset_y,
        self.getTransformScale(),
        font_collection,
        font_handle,
        glyph_id,
        font_size,
        color,
        alpha_mode,
    );

    try self.drawQuad(quad);
}

pub fn drawIcon(
    self: *Renderer,
    offset_x: f32,
    offset_y: f32,
    icon_collection: *skb.IconCollection,
    icon_handle: skb.IconHandle,
    width: f32,
    height: f32,
    color: skb.Color,
    alpha_mode: skb.RasterizerAlphaMode,
) !void {
    const quad = self.atlas.getIconQuad(
        offset_x,
        offset_y,
        self.getTransformScale(),
        icon_collection,
        icon_handle,
        width,
        height,
        color,
        alpha_mode,
    );

    try self.drawQuad(quad);
}

pub fn drawDecoration(
    self: *Renderer,
    offset_x: f32,
    offset_y: f32,
    style: skb.DecorationStyle,
    position: skb.DecorationPosition,
    length: f32,
    pattern_offset: f32,
    thickness: f32,
    color: skb.Color,
    alpha_mode: skb.RasterizerAlphaMode,
) !void {
    const quad = self.atlas.getDecorationQuad(
        offset_x,
        offset_y,
        self.getTransformScale(),
        position,
        style,
        length,
        pattern_offset,
        thickness,
        color,
        alpha_mode,
    );

    try self.drawQuad(quad);
}

pub fn drawLayout(
    self: *Renderer,
    offset_x: f32,
    offset_y: f32,
    layout: *const skb.Layout,
    alpha_mode: skb.RasterizerAlphaMode,
) !void {
    const params = layout.getParams();
    const runs = layout.getRunsSlice();
    const glyphs = layout.getGlyphsSlice();
    const decorations = layout.getDecorationsSlice();

    for (decorations) |decor| {
        if (decor.position != .throughline) {
            try self.drawDecoration(
                offset_x + decor.offset_x,
                offset_y + decor.offset_y,
                decor.style,
                decor.position,
                decor.length,
                decor.pattern_offset,
                decor.thickness,
                decor.color,
                alpha_mode,
            );
        }
    }

    for (runs) |run| {
        const attr_fill = run.attributes.getFill(params.attribute_collection);
        if (run.type == .object) {} else if (run.type == .icon) {
            try self.drawIcon(
                offset_x + run.bounds.x,
                offset_y + run.bounds.y,
                params.icon_collection.?,
                run.data.icon_handle,
                run.bounds.width,
                run.bounds.height,
                attr_fill.color,
                alpha_mode,
            );
        } else {
            const glyph_start_index: usize = @intCast(run.glyph_range.start);
            const glyph_end_index: usize = @intCast(run.glyph_range.end);
            var it: usize = glyph_start_index;
            while (it < glyph_end_index) : (it += 1) {
                const g = &glyphs[it];
                try self.drawGlyph(
                    offset_x + g.offset_x,
                    offset_y + g.offset_y,
                    params.font_collection.?,
                    run.data.font_handle,
                    g.gid,
                    run.font_size,
                    attr_fill.color,
                    alpha_mode,
                );
            }
        }
    }

    for (decorations) |decor| {
        if (decor.position == .throughline) {
            try self.drawDecoration(
                offset_x + decor.offset_x,
                offset_y + decor.offset_y,
                decor.style,
                decor.position,
                decor.length,
                decor.pattern_offset,
                decor.thickness,
                decor.color,
                alpha_mode,
            );
        }
    }
}

pub const RenderOverrideType = enum {
    fill,
    decoration,
};

pub const RenderOverride = struct {
    ty: RenderOverrideType,
    color: skb.Color,
    content_id: u64,

    pub fn makeFill(color: skb.Color, content_id: u64) RenderOverride {
        return .{
            .ty = .fill,
            .color = color,
            .content_id = content_id,
        };
    }

    pub fn makeDecoration(color: skb.Color, content_id: u64) RenderOverride {
        return .{
            .ty = .decoration,
            .color = color,
            .content_id = content_id,
        };
    }
};

pub fn drawLayoutWithColorOverrides(
    self: *Renderer,
    offset_x: f32,
    offset_y: f32,
    layout: *const skb.Layout,
    overrides: []const RenderOverride,
    alpha_mode: skb.RasterizerAlphaMode,
) void {
    _ = self;
    _ = offset_x;
    _ = offset_y;
    _ = layout;
    _ = overrides;
    _ = alpha_mode;
}

pub fn drawLayoutWithCulling(
    self: *Renderer,
    view_bounds: skb.Rect2,
    offset_x: f32,
    offset_y: f32,
    layout: *const skb.Layout,
    alpha_mode: skb.RasterizerAlphaMode,
) void {
    _ = self;
    _ = view_bounds;
    _ = offset_x;
    _ = offset_y;
    _ = layout;
    _ = alpha_mode;
}

const GPUVertex = extern struct {
    pos: [2]f32 = @splat(0),
    uv: [2]f32 = @splat(0),
    atlas_pos: [2]f32 = @splat(0),
    atlas_size: [2]f32 = @splat(0),
    color: [4]u8 = @splat(0),
    scale: f32 = 0.0,
};

const Batch = struct {
    offset: i32,
    count: i32,
    image_id: u32,
    sdf_id: u32,
};

const Texture = struct {
    id: u32 = 0,
    width: i32 = 0,
    height: i32 = 0,
    bpp: u8 = 0,
    // gl
    gl_tex: gl.uint = 0,
};

const Transform = struct {
    dx: f32,
    dy: f32,
    scale: f32,
};

const transform_stack_size = 10;

gpa: std.mem.Allocator = undefined,

temp_alloc: *skb.TempAlloc = undefined,
atlas: *skb.ImageAtlas = undefined,
rasterizer: *skb.Rasterizer = undefined,

vertices: std.ArrayList(GPUVertex) = .empty,
batches: std.ArrayList(Batch) = .empty,
textures: std.ArrayList(Texture) = .empty,

view_width: u32 = 1,
view_height: u32 = 1,

transform_stack: [transform_stack_size]Transform = undefined,
transform_stack_index: usize = 0,

// gl
program: gl.uint = 0,
vbo: gl.uint = 0,

fn onCreateTexture(atlas: *skb.ImageAtlas, texture_idx: u8, context: ?*anyopaque) callconv(.c) void {
    const renderer: *Renderer = @ptrCast(@alignCast(context.?));
    const texture = atlas.getTexture(@intCast(texture_idx)) orelse return;

    const tex_id = renderer.createTexture(
        texture.width,
        texture.height,
        texture.stride_bytes,
        texture.buffer orelse &.{},
        texture.bpp,
    ) catch |err| {
        std.debug.print("Failed to create texture: {}", .{err});
        return;
    };
    atlas.setTextureUserData(texture_idx, @intCast(tex_id));
}

fn findTexture(self: *const Renderer, id: u32) ?*Texture {
    for (self.textures.items) |*tex| {
        if (tex.id == id) {
            return tex;
        }
    }
    return null;
}

fn pushTriangles(self: *Renderer, vertices: []const GPUVertex, image_id: u32, sdf_id: u32) !void {
    var batch: *Batch = blk: {
        const prev_batch: ?*Batch = if (self.batches.items.len > 0)
            &self.batches.items[self.batches.items.len - 1]
        else
            null;

        if (prev_batch != null and prev_batch.?.image_id == image_id and prev_batch.?.sdf_id == sdf_id) {
            break :blk prev_batch.?;
        } else {
            try self.batches.append(self.gpa, .{
                .offset = @intCast(self.vertices.items.len),
                .count = 0,
                .image_id = image_id,
                .sdf_id = sdf_id,
            });
            break :blk &self.batches.items[self.batches.items.len - 1];
        }
    };

    try self.vertices.appendSlice(self.gpa, vertices);
    batch.count += @intCast(vertices.len);
}

const vs_source: [:0]const u8 = @embedFile("vs.glsl");
const fs_source: [:0]const u8 = @embedFile("fs.glsl");

fn printShaderLog(shader: gl.uint) void {
    if (gl.IsShader(shader) == gl.FALSE) {
        std.log.err("Not a shader: {}\n", .{shader});
        return;
    }

    var max_len: gl.int = 0;
    gl.GetShaderiv(shader, gl.INFO_LOG_LENGTH, @ptrCast(&max_len));
    if (max_len <= 0) {
        return;
    }

    var msg: [1024]u8 = undefined;
    gl.GetShaderInfoLog(
        shader,
        @intCast(msg.len),
        null,
        @ptrCast(&msg[0]),
    );

    std.log.err("Shader log ({}): {s}\n", .{ shader, std.mem.sliceTo(&msg, 0) });
}

fn glInit(self: *Renderer) !void {
    var success: gl.int = gl.FALSE;

    const vs = gl.CreateShader(gl.VERTEX_SHADER);
    defer gl.DeleteShader(vs);

    gl.ShaderSource(vs, 1, @ptrCast(@alignCast((&vs_source.ptr))), null);
    gl.CompileShader(vs);
    gl.GetShaderiv(vs, gl.COMPILE_STATUS, @ptrCast(&success));
    if (success != gl.TRUE) {
        printShaderLog(vs);
        return error.GLShaderCompileFailed;
    }

    const ps = gl.CreateShader(gl.FRAGMENT_SHADER);
    defer gl.DeleteShader(ps);
    gl.ShaderSource(ps, 1, @ptrCast(@alignCast((&fs_source.ptr))), null);
    gl.CompileShader(ps);
    gl.GetShaderiv(ps, gl.COMPILE_STATUS, @ptrCast(&success));
    if (success != gl.TRUE) {
        printShaderLog(ps);
        return error.GLShaderCompileFailed;
    }

    self.program = gl.CreateProgram();
    gl.AttachShader(self.program, vs);
    gl.AttachShader(self.program, ps);

    gl.BindAttribLocation(self.program, 0, "a_pos");
    gl.BindAttribLocation(self.program, 1, "a_uv");
    gl.BindAttribLocation(self.program, 2, "a_atlas_pos");
    gl.BindAttribLocation(self.program, 3, "a_atlas_size");
    gl.BindAttribLocation(self.program, 4, "a_color");
    gl.BindAttribLocation(self.program, 5, "a_scale");

    gl.LinkProgram(self.program);

    try glCheckError("program link");

    gl.GetProgramiv(self.program, gl.LINK_STATUS, @ptrCast(&success));
    if (success != gl.TRUE) {
        std.log.err("Failed to link GL program\n", .{});
        return error.GLProgramLinkFailed;
    }

    gl.GenBuffers(1, @ptrCast(&self.vbo));
    try glCheckError("vbo create");
}

fn glDeinit(self: *Renderer) void {
    if (self.vbo != 0) {
        gl.DeleteBuffers(1, @ptrCast(&self.vbo));
        self.vbo = 0;
    }
    if (self.program != 0) {
        gl.DeleteProgram(self.program);
        self.program = 0;
    }
    for (self.textures.items) |*tex| {
        if (tex.gl_tex != 0) {
            gl.DeleteTextures(1, @ptrCast(&tex.gl_tex));
            tex.gl_tex = 0;
        }
    }
    self.textures.deinit(self.gpa);
    self.batches.deinit(self.gpa);
    self.vertices.deinit(self.gpa);
}

fn glFlush(self: *Renderer) !void {
    try glCheckError("flush start");

    gl.Enable(gl.LINE_SMOOTH);
    gl.Hint(gl.LINE_SMOOTH_HINT, gl.NICEST);

    gl.Enable(gl.BLEND);
    gl.BlendEquation(gl.FUNC_ADD);
    gl.BlendFuncSeparate(
        gl.ONE,
        gl.ONE_MINUS_SRC_ALPHA,
        gl.ONE,
        gl.ONE_MINUS_SRC_ALPHA,
    ); // premult alpha
    gl.Disable(gl.CULL_FACE);
    gl.Disable(gl.DEPTH_TEST);
    gl.Disable(gl.STENCIL_TEST);
    gl.Disable(gl.SCISSOR_TEST);
    gl.ColorMask(gl.TRUE, gl.TRUE, gl.TRUE, gl.TRUE);
    gl.ActiveTexture(gl.TEXTURE0);
    gl.BindTexture(gl.TEXTURE_2D, 0);

    try glCheckError("flush state");

    gl.UseProgram(self.program);
    gl.Uniform2f(
        gl.GetUniformLocation(self.program, "u_view_size"),
        @floatFromInt(self.view_width),
        @floatFromInt(self.view_height),
    );

    try glCheckError("prog");

    var vao: gl.uint = 0;
    gl.GenVertexArrays(1, @ptrCast(&vao));
    gl.BindVertexArray(vao);

    try glCheckError("vao");

    gl.BindBuffer(gl.ARRAY_BUFFER, self.vbo);
    gl.EnableVertexAttribArray(0);
    gl.EnableVertexAttribArray(1);
    gl.EnableVertexAttribArray(2);
    gl.EnableVertexAttribArray(3);
    gl.EnableVertexAttribArray(4);
    gl.EnableVertexAttribArray(5);
    gl.VertexAttribPointer(
        0,
        2,
        gl.FLOAT,
        gl.FALSE,
        @sizeOf(GPUVertex),
        @offsetOf(GPUVertex, "pos"),
    );
    gl.VertexAttribPointer(
        1,
        2,
        gl.FLOAT,
        gl.FALSE,
        @sizeOf(GPUVertex),
        @offsetOf(GPUVertex, "uv"),
    );
    gl.VertexAttribPointer(
        2,
        2,
        gl.FLOAT,
        gl.FALSE,
        @sizeOf(GPUVertex),
        @offsetOf(GPUVertex, "atlas_pos"),
    );
    gl.VertexAttribPointer(
        3,
        2,
        gl.FLOAT,
        gl.FALSE,
        @sizeOf(GPUVertex),
        @offsetOf(GPUVertex, "atlas_size"),
    );
    gl.VertexAttribPointer(
        4,
        4,
        gl.UNSIGNED_BYTE,
        gl.TRUE,
        @sizeOf(GPUVertex),
        @offsetOf(GPUVertex, "color"),
    );
    gl.VertexAttribPointer(
        5,
        1,
        gl.FLOAT,
        gl.FALSE,
        @sizeOf(GPUVertex),
        @offsetOf(GPUVertex, "scale"),
    );

    gl.BufferData(
        gl.ARRAY_BUFFER,
        @intCast(self.vertices.items.len * @sizeOf(GPUVertex)),
        self.vertices.items.ptr,
        gl.STREAM_DRAW,
    );

    try glCheckError("vbo");

    for (self.batches.items) |b| {
        const image_tex = self.findTexture(b.image_id);
        const sdf_tex = self.findTexture(b.sdf_id);

        if (image_tex != null and image_tex.?.gl_tex != 0) {
            gl.Uniform1i(gl.GetUniformLocation(self.program, "u_tex_type"), if (image_tex.?.bpp == 4) 1 else 2);
            gl.Uniform2f(gl.GetUniformLocation(self.program, "u_tex_size"), @floatFromInt(image_tex.?.width), @floatFromInt(image_tex.?.height));
            gl.Uniform1i(gl.GetUniformLocation(self.program, "u_tex"), 0);
            gl.ActiveTexture(gl.TEXTURE0);
            gl.BindTexture(gl.TEXTURE_2D, image_tex.?.gl_tex);
            try glCheckError("texture image");
        } else if (sdf_tex != null and sdf_tex.?.gl_tex != 0) {
            gl.Uniform1i(gl.GetUniformLocation(self.program, "u_tex_type"), if (sdf_tex.?.bpp == 4) 3 else 4);
            gl.Uniform2f(gl.GetUniformLocation(self.program, "u_tex_size"), @floatFromInt(sdf_tex.?.width), @floatFromInt(sdf_tex.?.height));
            gl.Uniform1i(gl.GetUniformLocation(self.program, "u_tex"), 0);
            gl.ActiveTexture(gl.TEXTURE0);
            gl.BindTexture(gl.TEXTURE_2D, sdf_tex.?.gl_tex);
            try glCheckError("texture sdf");
        } else {
            gl.Uniform1i(gl.GetUniformLocation(self.program, "u_tex_type"), 0);
            gl.Uniform2f(gl.GetUniformLocation(self.program, "u_tex_size"), 1, 1);
            gl.Uniform1i(gl.GetUniformLocation(self.program, "u_tex"), 0);
            gl.ActiveTexture(gl.TEXTURE0);
            gl.BindTexture(gl.TEXTURE_2D, 0);
            try glCheckError("texture none");
        }

        gl.DrawArrays(gl.TRIANGLES, b.offset, b.count);
    }

    try glCheckError("draw");

    gl.BindVertexArray(0);
    gl.DeleteVertexArrays(1, @ptrCast(&vao));

    try glCheckError("end");

    self.vertices.clearRetainingCapacity();
    self.batches.clearRetainingCapacity();
}

fn glCreateTexture(
    texture: *Texture,
    width: i32,
    height: i32,
    stride_bytes: i32,
    img_data: [*]const u8,
    bpp: u8,
) !void {
    if (texture.gl_tex != 0) {
        gl.DeleteTextures(1, @ptrCast(&texture.gl_tex));
        texture.gl_tex = 0;
    }

    texture.width = width;
    texture.height = height;
    texture.bpp = bpp;

    gl.GenTextures(1, @ptrCast(&texture.gl_tex));
    gl.BindTexture(gl.TEXTURE_2D, texture.gl_tex);

    gl.PixelStorei(gl.UNPACK_ALIGNMENT, 1);
    gl.PixelStorei(gl.UNPACK_ROW_LENGTH, @divExact(stride_bytes, bpp));
    gl.PixelStorei(gl.UNPACK_SKIP_PIXELS, 0);
    gl.PixelStorei(gl.UNPACK_SKIP_ROWS, 0);

    std.debug.assert(bpp == 4 or bpp == 1);
    if (bpp == 4) {
        gl.TexImage2D(
            gl.TEXTURE_2D,
            0,
            gl.RGBA,
            width,
            height,
            0,
            gl.RGBA,
            gl.UNSIGNED_BYTE,
            @ptrCast(img_data),
        );
    } else {
        gl.TexImage2D(
            gl.TEXTURE_2D,
            0,
            gl.RED,
            width,
            height,
            0,
            gl.RED,
            gl.UNSIGNED_BYTE,
            @ptrCast(img_data),
        );
    }

    gl.PixelStorei(gl.UNPACK_ALIGNMENT, 4);
    gl.PixelStorei(gl.UNPACK_ROW_LENGTH, 0);
    gl.PixelStorei(gl.UNPACK_SKIP_PIXELS, 0);
    gl.PixelStorei(gl.UNPACK_SKIP_ROWS, 0);

    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);

    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

    gl.BindTexture(gl.TEXTURE_2D, 0);
    try glCheckError("resize texture");
}

fn glUpdateTexture(
    texture: *Texture,
    x: i32,
    y: i32,
    width: i32,
    height: i32,
    stride_bytes: i32,
    img_data: [*]const u8,
) !void {
    gl.BindTexture(gl.TEXTURE_2D, texture.gl_tex);

    gl.PixelStorei(gl.UNPACK_ALIGNMENT, 1);
    gl.PixelStorei(gl.UNPACK_ROW_LENGTH, @divExact(stride_bytes, texture.bpp));
    gl.PixelStorei(gl.UNPACK_SKIP_PIXELS, x);
    gl.PixelStorei(gl.UNPACK_SKIP_ROWS, y);

    if (texture.bpp == 4)
        gl.TexSubImage2D(
            gl.TEXTURE_2D,
            0,
            x,
            y,
            width,
            height,
            gl.RGBA,
            gl.UNSIGNED_BYTE,
            img_data,
        )
    else
        gl.TexSubImage2D(
            gl.TEXTURE_2D,
            0,
            x,
            y,
            width,
            height,
            gl.RED,
            gl.UNSIGNED_BYTE,
            img_data,
        );

    gl.PixelStorei(gl.UNPACK_ALIGNMENT, 4);
    gl.PixelStorei(gl.UNPACK_ROW_LENGTH, 0);
    gl.PixelStorei(gl.UNPACK_SKIP_PIXELS, 0);
    gl.PixelStorei(gl.UNPACK_SKIP_ROWS, 0);

    gl.BindTexture(gl.TEXTURE_2D, 0);

    try glCheckError("update texture");
}

fn glCheckError(location: []const u8) !void {
    var err: gl.uint = undefined;
    while (true) {
        err = gl.GetError();
        if (err == gl.NO_ERROR) break;
        const msg = switch (err) {
            gl.INVALID_ENUM => "INVALID_ENUM",
            gl.INVALID_VALUE => "INVALID_VALUE",
            gl.INVALID_OPERATION => "INVALID_OPERATION",
            gl.OUT_OF_MEMORY => "OUT_OF_MEMORY",
            gl.INVALID_FRAMEBUFFER_OPERATION => "INVALID_FRAMEBUFFER_OPERATION",
            else => "UNKNOWN",
        };
        std.log.err("GL error ({s}): {x} ({s})\n", .{ location, err, msg });
        return error.GLGenericError;
    }
}

const std = @import("std");
