pub const RenderAlignment = enum {
    start,
    center,
    end,
};

/// draws a tick (cross shape)
pub fn drawTick(
    self: *Renderer,
    x: f32,
    y: f32,
    s: f32,
    col: skb.Color,
    line_width: f32,
) !void {
    var width: f32 = line_width;
    if (width < 0) width = -width / self.getTransformScale();

    const hw = width * 0.5;
    const hs = s * 0.5 + hw;
    try drawFilledRect(self, x - hs, y - hw, s + width, width, col);
    try drawFilledRect(self, x - hw, y - hs, width, s + width, col);
}

/// draws a line (from x0,y0 to x1,y1)
pub fn drawLine(
    self: *Renderer,
    x0: f32,
    y0: f32,
    x1: f32,
    y1: f32,
    col: skb.Color,
    line_width: f32,
) !void {
    var width: f32 = line_width;
    if (width < 0) width = -width / self.getTransformScale();

    const p0: skb.Vec2 = .{ .x = x0, .y = y0 };
    const p1: skb.Vec2 = .{ .x = x1, .y = y1 };
    const diff: skb.Vec2 = p1.sub(p0);
    const dir: skb.Vec2 = diff.norm();
    const len: f32 = diff.length();
    const hw: f32 = width * 0.5;

    try drawLineImpl(self, p0, dir, -hw, len + hw, hw, col);
}

/// draws a dashed line (from x0,y0 to x1,y1)
pub fn drawDashedLine(
    self: *Renderer,
    x0: f32,
    y0: f32,
    x1: f32,
    y1: f32,
    dash: f32,
    col: skb.Color,
    line_width: f32,
) !void {
    var width: f32 = line_width;
    var dash_len: f32 = dash;

    if (width < 0) width = -width / self.getTransformScale();
    if (dash_len < 0) dash_len = -dash_len / self.getTransformScale();

    const p0: skb.Vec2 = .{ .x = x0, .y = y0 };
    const p1: skb.Vec2 = .{ .x = x1, .y = y1 };
    const diff: skb.Vec2 = p1.sub(p0);
    const dir: skb.Vec2 = diff.norm();
    const len: f32 = diff.length();
    const hw: f32 = width * 0.5;

    const tick_count = std.math.clamp(@floor(len / dash_len) | 1, 1, 1000);
    const d = len / tick_count;
    const p: skb.Vec2 = .{ .x = x0 - dir.x * hw, .y = y0 - dir.y * hw };

    var i: i32 = 0;
    while (i < tick_count) : (i += 2) {
        const d0 = @as(f32, @floatFromInt(i)) * d;
        const d1 = d0 + d;
        try drawLineImpl(self, p, dir, d0, d1, hw, col);
    }
}

/// draws a stroked rectangle
pub fn drawStrokedRect(
    self: *Renderer,
    x: f32,
    y: f32,
    w: f32,
    h: f32,
    col: skb.Color,
    line_width: f32,
) !void {
    var width: f32 = line_width;
    if (line_width < 0) width = -width / self.getTransformScale();
    const hw = width * 0.5;
    try drawFilledRect(self, x - hw, y - hw, w + width, width, col);
    try drawFilledRect(self, x - hw, y + h - hw, w + width, width, col);
    try drawFilledRect(self, x - hw, y + hw, width, h - width, col);
    try drawFilledRect(self, x + w - hw, y + hw, width, h - width, col);
}

/// draws a dashed rectangle
pub fn drawDashedRect(
    self: *Renderer,
    x: f32,
    y: f32,
    w: f32,
    h: f32,
    dash: f32,
    col: skb.Color,
    line_width: f32,
) !void {
    try drawDashedLine(self, x, y, x + w, y, dash, col, line_width);
    try drawDashedLine(self, x + w, y, x + w, y + h, dash, col, line_width);
    try drawDashedLine(self, x + w, y + h, x, y + h, dash, col, line_width);
    try drawDashedLine(self, x, y + h, x, y, dash, col, line_width);
}

/// draws a filled rectangle
pub fn drawFilledRect(
    self: *Renderer,
    x: f32,
    y: f32,
    w: f32,
    h: f32,
    col: skb.Color,
) !void {
    const verts: []const Renderer.Vertex = &.{
        .{ .pos = .{ .x = x, .y = y }, .color = col },
        .{ .pos = .{ .x = x + w, .y = y }, .color = col },
        .{ .pos = .{ .x = x + w, .y = y + h }, .color = col },
        .{ .pos = .{ .x = x, .y = y }, .color = col },
        .{ .pos = .{ .x = x + w, .y = y + h }, .color = col },
        .{ .pos = .{ .x = x, .y = y + h }, .color = col },
    };
    try self.drawDebugTris(verts);
}

// /// draws text in debug font
// pub fn drawDebugText(
//     self: *Renderer,
//     x: f32,
//     y: f32,
//     size: f32,
//     al: RenderAlignment,
//     col: skb.Color,
//     str: []const u8,
// ) !void {}

// /// returns width of text
// pub fn getDebugTextWidth(self: *Renderer, size: f32, str: []const u8) !f32 {}

// /// renders debug overlay of the image atlas on render context
// pub fn drawAtlasOverlay(
//     self: *Renderer,
//     sx: f32,
//     sy: f32,
//     scale: f32,
//     columns: i32,
// ) !void {}

fn rot90(v: skb.Vec2) skb.Vec2 {
    return skb.Vec2{
        .x = v.y,
        .y = -v.x,
    };
}

fn drawLineStrip(
    self: *Renderer,
    pts: []const skb.Vec2,
    col: skb.Color,
    line_width: f32,
) !void {
    if (pts.len < 2) {
        return;
    }

    var dirs = struct {
        var data: [64]skb.Vec2 = undefined;
    };
    const point_count = @min(pts.len, dirs.data.len);

    const is_loop = pts[0].equals(pts[point_count - 1], 0.01);

    for (0..point_count - 1) |i| {
        dirs.data[i] = pts[i + 1].sub(pts[i]).norm();
    }

    if (!is_loop) {
        dirs.data[point_count - 1] = dirs.data[point_count - 2];
    } else {
        dirs.data[point_count - 1] = pts[1].sub(pts[point_count - 1]).norm(); // First & last are the same, so pick the next point.
    }

    const hw = line_width * 0.5;

    var has_prev = false;
    var prev_left: skb.Vec2 = .zero;
    var prev_right: skb.Vec2 = .zero;
    var left: skb.Vec2 = .zero;
    var right: skb.Vec2 = .zero;

    var verts: [64 * 6]Renderer.Vertex = undefined;
    var verts_count: usize = 0;

    if (!is_loop) {
        const p = pts[0];
        const dir = dirs.data[0];
        const off = rot90(dir);
        prev_left.x = p.x - dir.x * hw + off.x * hw;
        prev_left.y = p.y - dir.y * hw + off.y * hw;
        prev_right.x = p.x - dir.x * hw - off.x * hw;
        prev_right.y = p.y - dir.y * hw - off.y * hw;
        has_prev = true;
    }

    var start: usize = 0;
    var count: usize = 0;
    var pi: usize = 0;

    if (!is_loop) {
        start = 1;
        count = point_count - 1;
        pi = 0;
    } else {
        start = 0;
        count = point_count;
        pi = point_count - 2; // First & last are the same, so pick the previous point.
    }

    for (start..count) |i| {
        const p1 = pts[i];
        const dir0 = dirs.data[pi];
        const dir1 = dirs.data[i];

        // Calculate extrusions
        var off0 = rot90(dir0);
        const off1 = rot90(dir1);
        var off = off0.multiplyAdd(off1, 0.5);
        const dmr2 = off.dot(off);
        if (dmr2 > 0.000001) {
            var scale = 1.0 / dmr2;
            if (scale > 20.0) {
                scale = 20.0;
            }
            off = off.scale(scale);
        }

        left.x = p1.x + off.x * hw;
        left.y = p1.y + off.y * hw;
        right.x = p1.x - off.x * hw;
        right.y = p1.y - off.y * hw;

        if (has_prev) {
            verts[verts_count] = .{ .pos = prev_left, .color = col };
            verts_count += 1;
            verts[verts_count] = .{ .pos = left, .color = col };
            verts_count += 1;
            verts[verts_count] = .{ .pos = right, .color = col };
            verts_count += 1;
            verts[verts_count] = .{ .pos = prev_left, .color = col };
            verts_count += 1;
            verts[verts_count] = .{ .pos = right, .color = col };
            verts_count += 1;
            verts[verts_count] = .{ .pos = prev_right, .color = col };
            verts_count += 1;
        }

        prev_left = left;
        prev_right = right;
        has_prev = true;

        pi = i;
    }

    // End cap
    if (!is_loop) {
        const p = pts[point_count - 1];
        const dir = dirs.data[point_count - 2];
        const off = rot90(dir);
        left.x = p.x + dir.x * hw + off.x * hw;
        left.y = p.y + dir.y * hw + off.y * hw;
        right.x = p.x + dir.x * hw - off.x * hw;
        right.y = p.y + dir.y * hw - off.y * hw;

        verts[verts_count] = .{ .pos = prev_left, .color = col };
        verts_count += 1;
        verts[verts_count] = .{ .pos = left, .color = col };
        verts_count += 1;
        verts[verts_count] = .{ .pos = right, .color = col };
        verts_count += 1;
        verts[verts_count] = .{ .pos = prev_left, .color = col };
        verts_count += 1;
        verts[verts_count] = .{ .pos = right, .color = col };
        verts_count += 1;
        verts[verts_count] = .{ .pos = prev_right, .color = col };
        verts_count += 1;
    }

    try self.drawDebugTris(verts[0..verts_count]);

    // render_draw_debug_tris(rc, verts, verts_count);
}

fn drawLineImpl(self: *Renderer, p: skb.Vec2, dir: skb.Vec2, d0: f32, d1: f32, hw: f32, col: skb.Color) !void {
    const off = rot90(dir);

    const p0_left: skb.Vec2 = .{
        .x = p.x + dir.x * d0 + off.x * hw,
        .y = p.y + dir.y * d0 + off.y * hw,
    };
    const p0_right: skb.Vec2 = .{
        .x = p.x + dir.x * d0 - off.x * hw,
        .y = p.y + dir.y * d0 - off.y * hw,
    };
    const p1_left: skb.Vec2 = .{
        .x = p.x + dir.x * d1 + off.x * hw,
        .y = p.y + dir.y * d1 + off.y * hw,
    };
    const p1_right: skb.Vec2 = .{
        .x = p.x + dir.x * d1 - off.x * hw,
        .y = p.y + dir.y * d1 - off.y * hw,
    };

    const verts: []const Renderer.Vertex = &.{
        .{ .pos = p0_left, .color = col },
        .{ .pos = p1_left, .color = col },
        .{ .pos = p1_right, .color = col },
        .{ .pos = p0_left, .color = col },
        .{ .pos = p1_right, .color = col },
        .{ .pos = p0_right, .color = col },
    };
    try self.drawDebugTris(verts);
}

const std = @import("std");

const skb = @import("zskribidi").bindings;
const Renderer = @import("Renderer.zig");
