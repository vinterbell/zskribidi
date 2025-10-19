const ExampleBasic = @This();

data: @import("Data.zig"),
font_collection: *skb.FontCollection,
temp_alloc: *skb.TempAlloc,
layout_cache: *skb.LayoutCache,

pub fn init(self: *ExampleBasic) !void {
    self.font_collection = try .create();
    errdefer self.font_collection.destroy();

    _ = self.font_collection.addFontFromPath("data/IBMPlexSans-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/IBMPlexSans-Italic.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/IBMPlexSans-Bold.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/IBMPlexSansArabic-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/IBMPlexSansJP-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/IBMPlexSansKR-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/IBMPlexSansDevanagari-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/NotoSansBrahmi-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/NotoSerifBalinese-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/NotoSansTamil-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/NotoSansBengali-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/NotoSansThai-Regular.ttf", .default, null);
    _ = self.font_collection.addFontFromPath("data/NotoColorEmoji-Regular.ttf", .emoji, null);

    self.temp_alloc = try skb.TempAlloc.create(512 * 1024);
    errdefer self.temp_alloc.destroy();

    self.layout_cache = try skb.LayoutCache.create();
    errdefer self.layout_cache.destroy();
}

pub fn deinit(self: *ExampleBasic) void {
    self.layout_cache.destroy();
    self.temp_alloc.destroy();
    self.font_collection.destroy();
}

pub fn update(self: *ExampleBasic, view_width: i32, view_height: i32) !void {
    // _ = view_height;

    const width: f32 = @floatFromInt(view_width);
    const height: f32 = @floatFromInt(view_height);

    _ = self.layout_cache.compact();

    try self.renderCachedText(
        "Hello, world! مرحبا بالعالم こんにちは 세계 नमस्ते 🤞❤️😿",
        width - 20,
        height - 20,
        48.0,
        .normal,
        .{ .r = 0, .g = 0, .b = 0, .a = 255 },
        10.0,
        10.0,
    );

    try self.data.renderer.updateAtlas();
}

fn renderCachedText(
    self: *ExampleBasic,
    text: []const u8,
    width: f32,
    height: f32,
    font_size: f32,
    font_weight: skb.Weight,
    color: skb.Color,
    pos_x: f32,
    pos_y: f32,
) !void {
    const layout_attributes: [2]skb.Attribute = .{
        .attrBaselineAlign(.middle),
        .attrTextWrap(.word),
    };

    const params: skb.LayoutParams = .{
        .font_collection = self.font_collection,
        .layout_attributes = .initAttributes(&layout_attributes),
        .layout_width = width,
        .layout_height = height,
    };

    const attributes: [3]skb.Attribute = .{
        .attrFontSize(font_size),
        .attrFontWeight(font_weight),
        .attrFill(color),
    };

    const layout = self.layout_cache.getUtf8(
        self.temp_alloc,
        &params,
        text,
        .initAttributes(&attributes),
    ) orelse {
        std.debug.print("Failed to create layout for text: '{s}'\n", .{text});
        return;
    };

    try self.data.renderer.drawLayout(pos_x, pos_y, layout, .sdf);
}

const std = @import("std");

const gl = @import("gl");
const glfw = @import("glfw");
const skb = @import("zskribidi").bindings;
