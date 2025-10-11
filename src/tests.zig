const std = @import("std");

pub const skb = @import("bindings.zig");

test "basic" {
    try std.testing.expect(12 > 5);
}

test "canvas" {
    const allocator = std.testing.allocator;

    const temp_alloc: *skb.TempAlloc = try .create(512 * 1024);
    defer temp_alloc.destroy();

    var image: skb.Image = .{
        .width = 100,
        .height = 100,
        .bpp = 4,
    };
    const backing = try allocator.alloc(u8, @intCast(image.width * image.height * image.bpp));
    defer allocator.free(backing);

    image.buffer = backing.ptr;
    image.stride_bytes = image.width * image.bpp;

    const canvas: *skb.Canvas = try .create(temp_alloc, &image);
    defer canvas.destroy();
}

test "font collection init" {
    const font_collection: *skb.FontCollection = try .create();
    defer font_collection.destroy();
}

test "font collection add" {
    const font_collection: *skb.FontCollection = try .create();
    defer font_collection.destroy();

    const font_handle = font_collection.addFontFromPath(
        "data/IBMPlexSans-Regular.ttf",
        .default,
        null,
    );
    try std.testing.expect(font_handle != .none);

    const latin_script: skb.Script = .fromIso15924Tag(skb.defineIso15924TagString("Latn"));

    var font_handles2: [1]skb.FontHandle = @splat(.none);
    const count = font_collection.matchFonts(
        "",
        latin_script,
        .default,
        .normal,
        .normal,
        .normal,
        &font_handles2,
    );
    try std.testing.expectEqual(1, count);
    try std.testing.expect(font_handles2[0] != .none);

    const removed = font_collection.removeFont(font_handle);
    try std.testing.expect(removed);

    const font_ptr = font_collection.getFont(font_handle);
    try std.testing.expect(font_ptr == null);

    var font_handles3: [1]skb.FontHandle = @splat(.none);
    const count2 = font_collection.matchFonts(
        "",
        latin_script,
        .default,
        .normal,
        .normal,
        .normal,
        &font_handles3,
    );
    try std.testing.expectEqual(0, count2);
    try std.testing.expect(font_handles3[0] == .none);
}

test "icon collection init" {
    const icon_collection: *skb.IconCollection = try .create();
    defer icon_collection.destroy();
}

test "icon collection add remove" {
    const icon_collection: *skb.IconCollection = try .create();
    defer icon_collection.destroy();

    const icon_handle = icon_collection.addIcon("icon", 0, 0);
    try std.testing.expect(icon_handle != .none);

    const icon = icon_collection.getIcon(icon_handle);
    try std.testing.expect(icon != null);

    const icon_handle_2 = icon_collection.findIcon("icon");
    try std.testing.expect(icon_handle_2 == icon_handle);

    _ = icon_collection.removeIcon(icon_handle);

    const icon_2 = icon_collection.getIcon(icon_handle);
    try std.testing.expect(icon_2 == null);

    const icon_handle_3 = icon_collection.findIcon("icon");
    try std.testing.expect(icon_handle_3 == .none);
}

test "image atlas create" {
    const image_atlas: *skb.ImageAtlas = try .create(null);
    defer image_atlas.destroy();
}

test "layout create" {
    const layout_params: skb.LayoutParams = .{};

    const layout: *skb.Layout = try .create(&layout_params);
    defer layout.destroy();
}

test "layout missing script" {
    const temp_alloc: *skb.TempAlloc = try .create(1024);
    defer temp_alloc.destroy();

    const font_collection: *skb.FontCollection = try .create();
    defer font_collection.destroy();

    const font_handle = font_collection.addFontFromPath(
        "data/IBMPlexSans-Regular.ttf",
        .default,
        null,
    );
    try std.testing.expect(font_handle != .none);

    const layout_params: skb.LayoutParams = .{
        .font_collection = font_collection,
    };
    const attributes = [_]skb.Attribute{
        .attrFontSize(15.0),
    };

    const attribute_set: skb.AttributeSet = .initAttributes(&attributes);

    const layout: *skb.Layout = try .createUtf8(
        temp_alloc,
        &layout_params,
        "今天天气晴朗",
        attribute_set,
    );
    defer layout.destroy();

    const glyph_count = layout.getGlyphsCount();
    try std.testing.expect(glyph_count > 0);
    const glyphs = layout.getGlyphsSlice();
    try std.testing.expectEqual(0, glyphs[0].gid);
}

test "layout cache" {
    const layout_cache: *skb.LayoutCache = try .create();
    defer layout_cache.destroy();
}

test "rasterizer create" {
    const rasterizer: *skb.Rasterizer = try .create(null);
    defer rasterizer.destroy();
}

test "rich text create" {
    const rich_text: *skb.RichText = try .create();
    defer rich_text.destroy();

    try std.testing.expectEqual(0, rich_text.getParagraphsCount());
}

test "rich text replace" {
    const temp_alloc: *skb.TempAlloc = try .create(1024);
    defer temp_alloc.destroy();

    var text_count: i32 = 0;

    const rich_text: *skb.RichText = try .create();
    defer rich_text.destroy();

    try std.testing.expectEqual(0, rich_text.getParagraphsCount());

    const ins_rich_text: *skb.RichText = try .create();
    defer ins_rich_text.destroy();

    _ = ins_rich_text.appendUtf8(temp_alloc, "Foo\nbar", .{});
    _ = ins_rich_text.appendUtf8(temp_alloc, "baz", .{});
    text_count = ins_rich_text.getUtf32Count();
    try std.testing.expectEqual(10, text_count);
    try std.testing.expectEqual(2, ins_rich_text.getParagraphsCount()); // Foo\n | bar

    // Insert front
    _ = rich_text.replace(.zero, ins_rich_text);
    text_count = rich_text.getUtf32Count();
    try std.testing.expectEqual(10, text_count);
    try std.testing.expectEqual(2, rich_text.getParagraphsCount()); // Foo\n | barbaz

    // Insert back
    _ = rich_text.replace(.init(text_count, text_count), ins_rich_text);
    text_count = rich_text.getUtf32Count();
    try std.testing.expectEqual(20, text_count);
    try std.testing.expectEqual(3, rich_text.getParagraphsCount()); // Foo\n | barbazFoo\n | barbaz

    // Insert middle
    _ = rich_text.replace(.init(3, 14), ins_rich_text);
    text_count = rich_text.getUtf32Count();
    try std.testing.expectEqual(19, text_count);
    try std.testing.expectEqual(2, rich_text.getParagraphsCount()); // Foo | barbaz | Foo\n | barbaz | barbaz
}

test "rich text append" {
    const temp_alloc: *skb.TempAlloc = try .create(1024);
    defer temp_alloc.destroy();

    const rich_text: *skb.RichText = try .create();
    defer rich_text.destroy();
    _ = rich_text.appendUtf8(temp_alloc, "123456", .{});

    const rich_text2: *skb.RichText = try .create();
    defer rich_text2.destroy();
    _ = rich_text2.appendRange(rich_text, .init(2, 5));
    try std.testing.expectEqual(3, rich_text2.getUtf32Count());

    const rich_text3: *skb.RichText = try .create();
    defer rich_text3.destroy();
    _ = rich_text3.appendUtf8(temp_alloc, "123\n456\n789", .{});

    const rich_text4: *skb.RichText = try .create();
    defer rich_text4.destroy();
    _ = rich_text4.appendUtf8(temp_alloc, "abc", .{});
    _ = rich_text4.appendRange(rich_text3, .init(4, 10));
    try std.testing.expectEqual(9, rich_text4.getUtf32Count());
    try std.testing.expectEqual(2, rich_text4.getParagraphsCount()); // abc456\n | 78
}
