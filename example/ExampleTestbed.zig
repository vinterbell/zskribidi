const ExampleTestbed = @This();

data: @import("Data.zig"),

pub fn init(self: *ExampleTestbed) !void {
    _ = self;
}

pub fn deinit(self: *ExampleTestbed) void {
    _ = self;
}

pub fn update(self: *ExampleTestbed, view_width: i32, view_height: i32) !void {
    _ = self;
    _ = view_width;
    _ = view_height;
}

const std = @import("std");

const skb = @import("zskribidi").bindings;
