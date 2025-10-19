//! Shared data for all examples.

pub const ExampleId = enum {
    testbed,
    basic,

    pub fn T(comptime example: ExampleId) type {
        return switch (example) {
            .testbed => @import("ExampleTestbed.zig"),
            .basic => @import("ExampleBasic.zig"),
        };
    }

    pub fn next(self: ExampleId) ExampleId {
        return switch (self) {
            .testbed => .basic,
            .basic => .testbed,
        };
    }
};

allocator: std.mem.Allocator,
window: *glfw.Window,
renderer: *Renderer,

const std = @import("std");
const glfw = @import("glfw");
const Renderer = @import("Renderer.zig");
