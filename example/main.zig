const std = @import("std");

const skb = @import("zskribidi").bindings;
const gl = @import("gl");
const glfw = @import("glfw");

const Data = @import("Data.zig");
const Renderer = @import("Renderer.zig");

var current_example: ?Data.ExampleId = null;
var example_data_buffer: [10 * 1024]u8 align(16) = undefined;

const gpa = std.heap.c_allocator;
var renderer_instance: Renderer = .{};

pub fn main() !void {
    try glfw.init();
    defer glfw.terminate();

    // or, using the equivalent, encapsulated, "objecty" API:
    const window = try glfw.Window.create(
        800,
        600,
        "Skribidi Example",
        null,
    );
    defer window.destroy();
    _ = window.setKeyCallback(onKeyDown);

    glfw.makeContextCurrent(window);
    defer glfw.makeContextCurrent(null);

    var procs: gl.ProcTable = undefined;
    if (procs.init(glfw.getProcAddress) == false) {
        std.debug.print("Failed to load OpenGL functions.\n", .{});
        return;
    }

    gl.makeProcTableCurrent(&procs);
    defer gl.makeProcTableCurrent(null);

    try renderer_instance.init(gpa, null);
    defer renderer_instance.deinit();

    try switchNextExample(gpa, window, &renderer_instance);

    while (!window.shouldClose()) {
        glfw.pollEvents();

        const fb_width, const fb_height = window.getFramebufferSize();
        const min_width, const min_height = window.getSize();

        _ = min_width;
        _ = min_height;

        gl.Viewport(0, 0, fb_width, fb_height);

        gl.ClearColor(0.9, 0.9, 0.9, 1.0);
        gl.ClearStencil(0);
        gl.Clear(gl.COLOR_BUFFER_BIT | gl.STENCIL_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

        gl.Enable(gl.BLEND);
        gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
        gl.Enable(gl.DEPTH_TEST);

        renderer_instance.beginFrame(@intCast(fb_width), @intCast(fb_height));

        if (current_example) |ex| {
            switch (ex) {
                inline else => |ex_enum| {
                    const ExType = ex_enum.T();
                    const ex_data: *ExType = @ptrCast(&example_data_buffer);
                    try ex_data.update(@intCast(fb_width), @intCast(fb_height));
                },
            }
        }

        try renderer_instance.endFrame();

        window.swapBuffers();
    }
}

fn onKeyDown(window: *glfw.Window, key: glfw.Key, scancode: c_int, action: glfw.Action, mods: glfw.Mods) callconv(.c) void {
    _ = scancode;
    _ = mods;

    if (key == .F1 and action == .press) {
        std.debug.print("Switching example\n", .{});
        switchNextExample(gpa, window, &renderer_instance) catch {
            std.debug.print("Failed to switch example\n", .{});
        };
    }
}

fn switchExample(allocator: std.mem.Allocator, new_example: Data.ExampleId, window: *glfw.Window, renderer: *Renderer) !void {
    if (current_example == new_example) return;

    if (current_example != null) {
        switch (current_example.?) {
            inline else => |ex| {
                const ExType = ex.T();
                const ex_data: *ExType = @ptrCast(&example_data_buffer);
                ex_data.deinit();
            },
        }
    }

    current_example = new_example;
    switch (new_example) {
        inline else => |ex| {
            const ExType = ex.T();
            const ex_data: *ExType = @ptrCast(&example_data_buffer);
            if (@hasField(ExType, "data")) {
                ex_data.data = .{
                    .allocator = allocator,
                    .window = window,
                    .renderer = renderer,
                };
            }
            try ex_data.init();
        },
    }
}

fn switchNextExample(allocator: std.mem.Allocator, window: *glfw.Window, renderer: *Renderer) !void {
    const next_example: Data.ExampleId = if (current_example) |ex| ex.next() else .basic;
    try switchExample(allocator, next_example, window, renderer);
}
