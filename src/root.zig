const std = @import("std");
pub const raw = @import("raw");

test "layout" {
    const layout_params: raw.skb_layout_params_t = .{};
    const layout = raw.skb_layout_create(&layout_params) orelse
        return error.LayoutCreationFailed;
    defer raw.skb_layout_destroy(layout);
}

test "layout missing script" {
    const temp_alloc = raw.skb_temp_alloc_create(1024) orelse
        return error.TempAllocCreationFailed;
    defer raw.skb_temp_alloc_destroy(temp_alloc);

    const font_collection = raw.skb_font_collection_create() orelse
        return error.FontCollectionCreationFailed;
    defer raw.skb_font_collection_destroy(font_collection);

    const font_handle = raw.skb_font_collection_add_font(
        font_collection,
        "data/IBMPlexSans-Regular.ttf",
        raw.SKB_FONT_FAMILY_DEFAULT,
        null,
    );
    try std.testing.expect(font_handle != 0);

    const layout_params: raw.skb_layout_params_t = .{
        .font_collection = font_collection,
    };
    const attributes = [_]raw.skb_attribute_t{
        raw.skb_attribute_make_font_size(15.0),
    };

    const attribute_set: raw.skb_attribute_set_t = .{
        .attributes = &attributes,
        .attributes_count = @intCast(attributes.len),
    };
    const layout = raw.skb_layout_create_utf8(
        temp_alloc,
        &layout_params,
        "今天天气晴朗",
        -1,
        attribute_set,
    ) orelse return error.LayoutCreationFailed;
    defer raw.skb_layout_destroy(layout);

    const glyph_count = raw.skb_layout_get_glyphs_count(layout);
    try std.testing.expect(glyph_count > 0);
    const glyphs = raw.skb_layout_get_glyphs(layout);
    try std.testing.expectEqual(0, glyphs[0].gid);
}
