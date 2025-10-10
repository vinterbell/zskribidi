// created from translate-c on skb.h in the same directory, and removing unnecessary stuff
pub const SKB_ALIGN_START: c_int = 0;
pub const SKB_ALIGN_CENTER: c_int = 1;
pub const SKB_ALIGN_END: c_int = 2;
pub const SKB_ALIGN_LEFT: c_int = 3;
pub const SKB_ALIGN_RIGHT: c_int = 4;
pub const SKB_ALIGN_TOP: c_int = 5;
pub const SKB_ALIGN_BOTTOM: c_int = 6;
pub const skb_align_t = c_uint;
pub const SKB_WRAP_NONE: c_int = 0;
pub const SKB_WRAP_WORD: c_int = 1;
pub const SKB_WRAP_WORD_CHAR: c_int = 2;
pub const skb_text_wrap_t = c_uint;
pub const SKB_OVERFLOW_NONE: c_int = 0;
pub const SKB_OVERFLOW_CLIP: c_int = 1;
pub const SKB_OVERFLOW_ELLIPSIS: c_int = 2;
pub const skb_text_overflow_t = c_uint;
pub const SKB_VERTICAL_TRIM_DEFAULT: c_int = 0;
pub const SKB_VERTICAL_TRIM_CAP_TO_BASELINE: c_int = 1;
pub const skb_vertical_trim_t = c_uint;
pub const SKB_LINE_HEIGHT_NORMAL: c_int = 0;
pub const SKB_LINE_HEIGHT_METRICS_RELATIVE: c_int = 1;
pub const SKB_LINE_HEIGHT_FONT_SIZE_RELATIVE: c_int = 2;
pub const SKB_LINE_HEIGHT_ABSOLUTE: c_int = 3;
pub const skb_line_height_t = c_uint;
pub const SKB_OBJECT_ALIGN_SELF: c_int = 0;
pub const SKB_OBJECT_ALIGN_TEXT_BEFORE: c_int = 1;
pub const SKB_OBJECT_ALIGN_TEXT_BEFORE_OR_AFTER: c_int = 2;
pub const SKB_OBJECT_ALIGN_TEXT_AFTER: c_int = 3;
pub const SKB_OBJECT_ALIGN_TEXT_AFTER_OR_BEFORE: c_int = 4;
pub const skb_object_align_reference_t = c_uint;
pub const SKB_DECORATION_STYLE_SOLID: c_int = 0;
pub const SKB_DECORATION_STYLE_DOUBLE: c_int = 1;
pub const SKB_DECORATION_STYLE_DOTTED: c_int = 2;
pub const SKB_DECORATION_STYLE_DASHED: c_int = 3;
pub const SKB_DECORATION_STYLE_WAVY: c_int = 4;
pub const skb_decoration_style_t = c_uint;
pub const SKB_DECORATION_UNDERLINE: c_int = 0;
pub const SKB_DECORATION_BOTTOMLINE: c_int = 1;
pub const SKB_DECORATION_OVERLINE: c_int = 2;
pub const SKB_DECORATION_THROUGHLINE: c_int = 3;
pub const skb_decoration_position_t = c_uint;
pub const SKB_AFFINITY_NONE: c_int = 0;
pub const SKB_AFFINITY_TRAILING: c_int = 1;
pub const SKB_AFFINITY_LEADING: c_int = 2;
pub const SKB_AFFINITY_SOL: c_int = 3;
pub const SKB_AFFINITY_EOL: c_int = 4;
pub const enum_skb_caret_affinity_t = c_uint;
pub const skb_caret_affinity_t = enum_skb_caret_affinity_t;
pub const struct_skb_text_position_t = extern struct {
    offset: i32 = 0,
    affinity: skb_caret_affinity_t = @import("std").mem.zeroes(skb_caret_affinity_t),
};
pub const skb_text_position_t = struct_skb_text_position_t;
pub const struct_skb_text_selection_t = extern struct {
    start_pos: skb_text_position_t = @import("std").mem.zeroes(skb_text_position_t),
    end_pos: skb_text_position_t = @import("std").mem.zeroes(skb_text_position_t),
};
pub const skb_text_selection_t = struct_skb_text_selection_t;
pub const struct_skb_paragraph_position_t = extern struct {
    paragraph_idx: i32 = 0,
    text_offset: i32 = 0,
    global_text_offset: i32 = 0,
};
pub const skb_paragraph_position_t = struct_skb_paragraph_position_t;
pub const struct_skb_paragraph_range_t = extern struct {
    start_pos: skb_paragraph_position_t = @import("std").mem.zeroes(skb_paragraph_position_t),
    end_pos: skb_paragraph_position_t = @import("std").mem.zeroes(skb_paragraph_position_t),
};
pub const skb_paragraph_range_t = struct_skb_paragraph_range_t;
pub extern fn skb_debug_log(format: [*c]const u8, ...) void;
pub const SKB_INVALID_INDEX: c_int = -1;
const enum_unnamed_3 = c_int;
pub extern fn skb_malloc(size: usize) ?*anyopaque;
pub extern fn skb_realloc(ptr: ?*anyopaque, new_size: usize) ?*anyopaque;
pub extern fn skb_free(ptr: ?*anyopaque) void;
pub const skb_destroy_func_t = fn (context: ?*anyopaque) callconv(.c) void;
pub const struct_skb_range_t = extern struct {
    start: i32 = 0,
    end: i32 = 0,
    pub const overlap = skb_range_overlap;
    pub const contains = skb_range_contains;
    pub const empty = skb_range_is_empty;
    pub const make = skb_emoji_run_iterator_make;
};
pub fn skb_mul255(arg_a: i32, arg_b: i32) callconv(.c) i32 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    a *= b;
    a += 128;
    a += a >> @intCast(8);
    return a >> @intCast(8);
}
pub const skb_range_t = struct_skb_range_t;
pub fn skb_range_overlap(arg_a: skb_range_t, arg_b: skb_range_t) callconv(.c) bool {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return @max(a.start, b.start) < @min(a.end, b.end);
}
pub fn skb_range_contains(arg_r: skb_range_t, arg_idx: i32) callconv(.c) bool {
    var r = arg_r;
    _ = &r;
    var idx = arg_idx;
    _ = &idx;
    return (idx >= r.start) and (idx < r.end);
}
pub fn skb_range_is_empty(arg_r: skb_range_t) callconv(.c) bool {
    var r = arg_r;
    _ = &r;
    return r.start >= r.end;
}
pub const struct_skb_color_t = extern struct {
    r: u8 = 0,
    g: u8 = 0,
    b: u8 = 0,
    a: u8 = 0,
    pub const equals = skb_color_equals;
    pub const alpha = skb_color_mul_alpha;
    pub const add = skb_color_add;
    pub const average = skb_color_average;
    pub const lerp = skb_color_lerp;
    pub const lerpf = skb_color_lerpf;
    pub const blend = skb_color_blend;
    pub const premult = skb_color_premult;
    pub const fill = skb_attribute_make_fill;
};
pub const skb_color_t = struct_skb_color_t;
pub fn skb_rgba(arg_r: u8, arg_g: u8, arg_b: u8, arg_a: u8) callconv(.c) skb_color_t {
    var r = arg_r;
    _ = &r;
    var g = arg_g;
    _ = &g;
    var b = arg_b;
    _ = &b;
    var a = arg_a;
    _ = &a;
    var res: skb_color_t = undefined;
    _ = &res;
    res.r = r;
    res.g = g;
    res.b = b;
    res.a = a;
    return res;
}
pub fn skb_color_equals(arg_lhs: skb_color_t, arg_rhs: skb_color_t) callconv(.c) bool {
    var lhs = arg_lhs;
    _ = &lhs;
    var rhs = arg_rhs;
    _ = &rhs;
    const u: u32 = @as([*c]u32, @ptrCast(@alignCast(&lhs))).*;
    _ = &u;
    const v: u32 = @as([*c]u32, @ptrCast(@alignCast(&rhs))).*;
    _ = &v;
    return u == v;
}
pub fn skb_color_mul_alpha(arg_col: skb_color_t, arg_alpha: u8) callconv(.c) skb_color_t {
    var col = arg_col;
    _ = &col;
    var alpha = arg_alpha;
    _ = &alpha;
    const u: u32 = @as([*c]u32, @ptrCast(@alignCast(&col))).*;
    _ = &u;
    var rb: u32 = u & @as(u32, 16711935);
    _ = &rb;
    rb *%= alpha;
    rb +%= 8388736;
    rb +%= (rb >> @intCast(8)) & @as(u32, 16711935);
    rb &= 4278255360;
    var ga: u32 = (u >> @intCast(8)) & @as(u32, 16711935);
    _ = &ga;
    ga *%= alpha;
    ga +%= 8388736;
    ga +%= (ga >> @intCast(8)) & @as(u32, 16711935);
    ga &= 4278255360;
    const r: u32 = ga | (rb >> @intCast(8));
    _ = &r;
    return @as([*c]const skb_color_t, @ptrCast(@alignCast(&r))).*;
}
pub fn skb_color_add(arg_a: skb_color_t, arg_b: skb_color_t) callconv(.c) skb_color_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    const au: u32 = @as([*c]u32, @ptrCast(@alignCast(&a))).*;
    _ = &au;
    const bu: u32 = @as([*c]u32, @ptrCast(@alignCast(&b))).*;
    _ = &bu;
    var rb: u32 = au & @as(u32, 16711935);
    _ = &rb;
    rb +%= bu & @as(u32, 16711935);
    rb &= 16711935;
    var ga: u32 = (au >> @intCast(8)) & @as(u32, 16711935);
    _ = &ga;
    ga +%= (bu >> @intCast(8)) & @as(u32, 16711935);
    ga &= 16711935;
    const r: u32 = (ga << @intCast(8)) | rb;
    _ = &r;
    return @as([*c]const skb_color_t, @ptrCast(@alignCast(&r))).*;
}
pub fn skb_color_average(arg_a: skb_color_t, arg_b: skb_color_t) callconv(.c) skb_color_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var au: u32 = @as([*c]u32, @ptrCast(@alignCast(&a))).*;
    _ = &au;
    var bu: u32 = @as([*c]u32, @ptrCast(@alignCast(&b))).*;
    _ = &bu;
    var acc: u32 = (au & @as(u32, 16843009)) +% (bu & @as(u32, 16843009));
    _ = &acc;
    au = (au >> @intCast(1)) & @as(u32, 2139062143);
    bu = (bu >> @intCast(1)) & @as(u32, 2139062143);
    acc = (acc >> @intCast(1)) & @as(u32, 2139062143);
    const r: u32 = (au +% bu) +% acc;
    _ = &r;
    return @as([*c]const skb_color_t, @ptrCast(@alignCast(&r))).*;
}
pub fn skb_color_lerp(arg_a: skb_color_t, arg_b: skb_color_t, arg_t: u8) callconv(.c) skb_color_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var t = arg_t;
    _ = &t;
    b = skb_color_mul_alpha(b, t);
    if (@as(c_int, b.a) == @as(c_int, 255)) return b;
    if (@as(c_int, b.a) == @as(c_int, 0)) return a;
    a = skb_color_mul_alpha(a, @bitCast(@as(i8, @truncate(@as(c_int, 255) - @as(c_int, b.a)))));
    return skb_color_add(a, b);
}
pub fn skb_color_lerpf(arg_a: skb_color_t, arg_b: skb_color_t, arg_t: f32) callconv(.c) skb_color_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var t = arg_t;
    _ = &t;
    const ti: i32 = @intFromFloat(t * @as(f32, 255));
    _ = &ti;
    return skb_color_lerp(a, b, @bitCast(@as(i8, @truncate(ti))));
}
pub fn skb_color_blend(arg_dst: skb_color_t, arg_src: skb_color_t) callconv(.c) skb_color_t {
    var dst = arg_dst;
    _ = &dst;
    var src = arg_src;
    _ = &src;
    dst = skb_color_mul_alpha(dst, @bitCast(@as(i8, @truncate(@as(c_int, 255) - @as(c_int, src.a)))));
    return skb_color_add(dst, src);
}
pub fn skb_color_premult(arg_col: skb_color_t) callconv(.c) skb_color_t {
    var col = arg_col;
    _ = &col;
    const a: i32 = col.a;
    _ = &a;
    const r: i32 = skb_mul255(col.r, a);
    _ = &r;
    const g: i32 = skb_mul255(col.g, a);
    _ = &g;
    const b: i32 = skb_mul255(col.b, a);
    _ = &b;
    var res: skb_color_t = undefined;
    _ = &res;
    res.r = @bitCast(@as(i8, @truncate(r)));
    res.g = @bitCast(@as(i8, @truncate(g)));
    res.b = @bitCast(@as(i8, @truncate(b)));
    res.a = @bitCast(@as(i8, @truncate(a)));
    return res;
}
pub const struct_skb_image_t = extern struct {
    buffer: [*c]u8 = null,
    width: i32 = 0,
    height: i32 = 0,
    stride_bytes: i32 = 0,
    bpp: u8 = 0,
};
pub const skb_image_t = struct_skb_image_t;
pub const struct_skb_vec2_t = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    pub const add = skb_vec2_add;
    pub const sub = skb_vec2_sub;
    pub const scale = skb_vec2_scale;
    pub const mad = skb_vec2_mad;
    pub const lerp = skb_vec2_lerp;
    pub const dot = skb_vec2_dot;
    pub const norm = skb_vec2_norm;
    pub const length = skb_vec2_length;
    pub const sqr = skb_vec2_dist_sqr;
    pub const dist = skb_vec2_dist;
    pub const equals = skb_vec2_equals;
};
pub const skb_vec2_t = struct_skb_vec2_t;
pub fn skb_vec2_make(arg_x: f32, arg_y: f32) callconv(.c) skb_vec2_t {
    var x = arg_x;
    _ = &x;
    var y = arg_y;
    _ = &y;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = x;
    res.y = y;
    return res;
}
pub fn skb_vec2_add(arg_a: skb_vec2_t, arg_b: skb_vec2_t) callconv(.c) skb_vec2_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = a.x + b.x;
    res.y = a.y + b.y;
    return res;
}
pub fn skb_vec2_sub(arg_a: skb_vec2_t, arg_b: skb_vec2_t) callconv(.c) skb_vec2_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = a.x - b.x;
    res.y = a.y - b.y;
    return res;
}
pub fn skb_vec2_scale(arg_a: skb_vec2_t, arg_s: f32) callconv(.c) skb_vec2_t {
    var a = arg_a;
    _ = &a;
    var s = arg_s;
    _ = &s;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = a.x * s;
    res.y = a.y * s;
    return res;
}
pub fn skb_vec2_mad(arg_a: skb_vec2_t, arg_b: skb_vec2_t, arg_s: f32) callconv(.c) skb_vec2_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var s = arg_s;
    _ = &s;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = a.x + (b.x * s);
    res.y = a.y + (b.y * s);
    return res;
}
pub fn skb_vec2_lerp(arg_a: skb_vec2_t, arg_b: skb_vec2_t, arg_t: f32) callconv(.c) skb_vec2_t {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var t = arg_t;
    _ = &t;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = a.x + ((b.x - a.x) * t);
    res.y = a.y + ((b.y - a.y) * t);
    return res;
}
pub fn skb_vec2_dot(arg_a: skb_vec2_t, arg_b: skb_vec2_t) callconv(.c) f32 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return (a.x * b.x) + (a.y * b.y);
}
pub fn skb_vec2_norm(arg_a: skb_vec2_t) callconv(.c) skb_vec2_t {
    var a = arg_a;
    _ = &a;
    const d: f32 = (a.x * a.x) + (a.y * a.y);
    _ = &d;
    if (d > @as(f32, 0)) {
        const inv_d: f32 = @as(f32, 1) / @sqrt(d);
        _ = &inv_d;
        a.x *= inv_d;
        a.y *= inv_d;
    }
    return a;
}
pub fn skb_vec2_length(arg_a: skb_vec2_t) callconv(.c) f32 {
    var a = arg_a;
    _ = &a;
    return @sqrt((a.x * a.x) + (a.y * a.y));
}
pub fn skb_vec2_dist_sqr(arg_a: skb_vec2_t, arg_b: skb_vec2_t) callconv(.c) f32 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    const dx: f32 = b.x - a.x;
    _ = &dx;
    const dy: f32 = b.y - a.y;
    _ = &dy;
    return (dx * dx) + (dy * dy);
}
pub fn skb_vec2_dist(arg_a: skb_vec2_t, arg_b: skb_vec2_t) callconv(.c) f32 {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    return @sqrt(skb_vec2_dist_sqr(a, b));
}
pub fn skb_vec2_equals(arg_a: skb_vec2_t, arg_b: skb_vec2_t, arg_tol: f32) callconv(.c) bool {
    var a = arg_a;
    _ = &a;
    var b = arg_b;
    _ = &b;
    var tol = arg_tol;
    _ = &tol;
    const dx: f32 = b.x - a.x;
    _ = &dx;
    const dy: f32 = b.y - a.y;
    _ = &dy;
    return ((dx * dx) + (dy * dy)) < (tol * tol);
}
pub const struct_skb_mat2_t = extern struct {
    xx: f32 = 0,
    yx: f32 = 0,
    xy: f32 = 0,
    yy: f32 = 0,
    dx: f32 = 0,
    dy: f32 = 0,
    pub const multiply = skb_mat2_multiply;
    pub const point = skb_mat2_point;
    pub const inverse = skb_mat2_inverse;
};
pub const skb_mat2_t = struct_skb_mat2_t;
pub fn skb_mat2_make_identity() callconv(.c) skb_mat2_t {
    var res: skb_mat2_t = undefined;
    _ = &res;
    res.xx = 1;
    res.yx = 0;
    res.xy = 0;
    res.yy = 1;
    res.dx = 0;
    res.dy = 0;
    return res;
}
pub fn skb_mat2_make_translation(arg_tx: f32, arg_ty: f32) callconv(.c) skb_mat2_t {
    var tx = arg_tx;
    _ = &tx;
    var ty = arg_ty;
    _ = &ty;
    var res: skb_mat2_t = undefined;
    _ = &res;
    res.xx = 1;
    res.yx = 0;
    res.xy = 0;
    res.yy = 1;
    res.dx = tx;
    res.dy = ty;
    return res;
}
pub fn skb_mat2_make_scale(arg_sx: f32, arg_sy: f32) callconv(.c) skb_mat2_t {
    var sx = arg_sx;
    _ = &sx;
    var sy = arg_sy;
    _ = &sy;
    var res: skb_mat2_t = undefined;
    _ = &res;
    res.xx = sx;
    res.yx = 0;
    res.xy = 0;
    res.yy = sy;
    res.dx = 0;
    res.dy = 0;
    return res;
}
pub fn skb_mat2_make_rotation(arg_a: f32) callconv(.c) skb_mat2_t {
    var a = arg_a;
    _ = &a;
    const cs: f32 = @cos(a);
    _ = &cs;
    const sn: f32 = @sin(a);
    _ = &sn;
    var res: skb_mat2_t = undefined;
    _ = &res;
    res.xx = cs;
    res.yx = sn;
    res.xy = -sn;
    res.yy = cs;
    res.dx = 0;
    res.dy = 0;
    return res;
}
pub fn skb_mat2_multiply(arg_t: skb_mat2_t, arg_s: skb_mat2_t) callconv(.c) skb_mat2_t {
    var t = arg_t;
    _ = &t;
    var s = arg_s;
    _ = &s;
    var res: skb_mat2_t = undefined;
    _ = &res;
    res.xx = (t.xx * s.xx) + (t.yx * s.xy);
    res.yx = (t.xx * s.yx) + (t.yx * s.yy);
    res.xy = (t.xy * s.xx) + (t.yy * s.xy);
    res.yy = (t.xy * s.yx) + (t.yy * s.yy);
    res.dx = ((t.dx * s.xx) + (t.dy * s.xy)) + s.dx;
    res.dy = ((t.dx * s.yx) + (t.dy * s.yy)) + s.dy;
    return res;
}
pub fn skb_mat2_point(arg_t: skb_mat2_t, arg_pt: skb_vec2_t) callconv(.c) skb_vec2_t {
    var t = arg_t;
    _ = &t;
    var pt = arg_pt;
    _ = &pt;
    var res: skb_vec2_t = undefined;
    _ = &res;
    res.x = ((pt.x * t.xx) + (pt.y * t.xy)) + t.dx;
    res.y = ((pt.x * t.yx) + (pt.y * t.yy)) + t.dy;
    return res;
}
pub extern fn skb_mat2_inverse(t: skb_mat2_t) skb_mat2_t;
pub const struct_skb_rect2_t = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    width: f32 = 0,
    height: f32 = 0,
    pub const point = skb_rect2_union_point;
    pub const @"union" = skb_rect2_union;
    pub const intersection = skb_rect2_intersection;
    pub const translate = skb_rect2_translate;
    pub const empty = skb_rect2_is_empty;
    pub const inside = skb_rect2_pt_inside;
    pub const overlap = arb_rect2_overlap;
};
pub const skb_rect2_t = struct_skb_rect2_t;
pub fn skb_rect2_make_undefined() callconv(.c) skb_rect2_t {
    var res: skb_rect2_t = undefined;
    _ = &res;
    res.x = @as(f32, 340282346638528860000000000000000000000) / @as(f32, 2);
    res.y = @as(f32, 340282346638528860000000000000000000000) / @as(f32, 2);
    res.width = -@as(f32, 340282346638528860000000000000000000000);
    res.height = -@as(f32, 340282346638528860000000000000000000000);
    return res;
}
pub fn skb_rect2_union_point(arg_r: skb_rect2_t, arg_pt: skb_vec2_t) callconv(.c) skb_rect2_t {
    var r = arg_r;
    _ = &r;
    var pt = arg_pt;
    _ = &pt;
    const min_x: f32 = @min(r.x, pt.x);
    _ = &min_x;
    const min_y: f32 = @min(r.y, pt.y);
    _ = &min_y;
    const max_x: f32 = @min(r.x + r.width, pt.x);
    _ = &max_x;
    const max_y: f32 = @min(r.y + r.height, pt.y);
    _ = &max_y;
    var res: skb_rect2_t = undefined;
    _ = &res;
    res.x = min_x;
    res.y = min_y;
    res.width = max_x - min_x;
    res.height = max_y - min_y;
    return res;
}
pub fn skb_rect2_union(a: skb_rect2_t, b: skb_rect2_t) callconv(.c) skb_rect2_t {
    _ = &a;
    _ = &b;
    const min_x: f32 = @min(a.x, b.x);
    _ = &min_x;
    const min_y: f32 = @min(a.y, b.y);
    _ = &min_y;
    const max_x: f32 = @min(a.x + a.width, b.x + b.width);
    _ = &max_x;
    const max_y: f32 = @min(a.y + a.height, b.y + b.height);
    _ = &max_y;
    var res: skb_rect2_t = undefined;
    _ = &res;
    res.x = min_x;
    res.y = min_y;
    res.width = max_x - min_x;
    res.height = max_y - min_y;
    return res;
}
pub fn skb_rect2_intersection(a: skb_rect2_t, b: skb_rect2_t) callconv(.c) skb_rect2_t {
    _ = &a;
    _ = &b;
    const min_x: f32 = @min(a.x, b.x);
    _ = &min_x;
    const min_y: f32 = @min(a.y, b.y);
    _ = &min_y;
    const max_x: f32 = @min(a.x + a.width, b.x + b.width);
    _ = &max_x;
    const max_y: f32 = @min(a.y + a.height, b.y + b.height);
    _ = &max_y;
    var res: skb_rect2_t = undefined;
    _ = &res;
    res.x = min_x;
    res.y = min_y;
    res.width = max_x - min_x;
    res.height = max_y - min_y;
    return res;
}
pub fn skb_rect2_translate(r: skb_rect2_t, d: skb_vec2_t) callconv(.c) skb_rect2_t {
    _ = &r;
    _ = &d;
    var res: skb_rect2_t = undefined;
    _ = &res;
    res.x = r.x + d.x;
    res.y = r.y + d.y;
    res.width = r.width;
    res.height = r.height;
    return res;
}
pub fn skb_rect2_is_empty(r: skb_rect2_t) callconv(.c) bool {
    _ = &r;
    return (r.width <= @as(f32, 0)) or (r.height <= @as(f32, 0));
}
pub fn skb_rect2_pt_inside(r: skb_rect2_t, pt: skb_vec2_t) callconv(.c) bool {
    _ = &r;
    _ = &pt;
    return (((pt.x >= r.x) and (pt.y >= r.y)) and (pt.x <= (r.x + r.width))) and (pt.y <= (r.y + r.height));
}
pub fn arb_rect2_overlap(a: skb_rect2_t, b: skb_rect2_t) callconv(.c) bool {
    _ = &a;
    _ = &b;
    const min_x: f32 = @min(a.x, b.x);
    _ = &min_x;
    const min_y: f32 = @min(a.y, b.y);
    _ = &min_y;
    const max_x: f32 = @min(a.x + a.width, b.x + b.width);
    _ = &max_x;
    const max_y: f32 = @min(a.y + a.height, b.y + b.height);
    _ = &max_y;
    return ((max_x - min_x) > @as(f32, 0)) and ((max_y - min_y) > @as(f32, 0));
}
pub const struct_skb_rect2i_t = extern struct {
    x: i32 = 0,
    y: i32 = 0,
    width: i32 = 0,
    height: i32 = 0,
    pub const point = skb_rect2i_union_point;
    pub const @"union" = skb_rect2i_union;
    pub const intersection = skb_rect2i_intersection;
    pub const empty = skb_rect2i_is_empty;
};
pub const skb_rect2i_t = struct_skb_rect2i_t;
pub fn skb_rect2i_make_undefined() callconv(.c) skb_rect2i_t {
    var res: skb_rect2i_t = undefined;
    _ = &res;
    res.x = @divTrunc(@as(c_int, 2147483647), @as(c_int, 2));
    res.y = @divTrunc(@as(c_int, 2147483647), @as(c_int, 2));
    res.width = -@as(c_int, 2147483647) - @as(c_int, 1);
    res.height = -@as(c_int, 2147483647) - @as(c_int, 1);
    return res;
}
pub fn skb_rect2i_union_point(arg_r: skb_rect2i_t, arg_x: i32, arg_y: i32) callconv(.c) skb_rect2i_t {
    var r = arg_r;
    _ = &r;
    var x = arg_x;
    _ = &x;
    var y = arg_y;
    _ = &y;
    const min_x: i32 = @min(r.x, x);
    _ = &min_x;
    const min_y: i32 = @min(r.y, y);
    _ = &min_y;
    const max_x: i32 = @max(r.x + r.width, x);
    _ = &max_x;
    const max_y: i32 = @max(r.y + r.height, y);
    _ = &max_y;
    var res: skb_rect2i_t = undefined;
    _ = &res;
    res.x = min_x;
    res.y = min_y;
    res.width = max_x - min_x;
    res.height = max_y - min_y;
    return res;
}
pub fn skb_rect2i_union(a: skb_rect2i_t, b: skb_rect2i_t) callconv(.c) skb_rect2i_t {
    _ = &a;
    _ = &b;
    const min_x: i32 = @min(a.x, b.x);
    _ = &min_x;
    const min_y: i32 = @min(a.y, b.y);
    _ = &min_y;
    const max_x: i32 = @max(a.x + a.width, b.x + b.width);
    _ = &max_x;
    const max_y: i32 = @max(a.y + a.height, b.y + b.height);
    _ = &max_y;
    var res: skb_rect2i_t = undefined;
    _ = &res;
    res.x = min_x;
    res.y = min_y;
    res.width = max_x - min_x;
    res.height = max_y - min_y;
    return res;
}
pub fn skb_rect2i_intersection(a: skb_rect2i_t, b: skb_rect2i_t) callconv(.c) skb_rect2i_t {
    _ = &a;
    _ = &b;
    const min_x: i32 = @max(a.x, b.x);
    _ = &min_x;
    const min_y: i32 = @max(a.y, b.y);
    _ = &min_y;
    const max_x: i32 = @min(a.x + a.width, b.x + b.width);
    _ = &max_x;
    const max_y: i32 = @min(a.y + a.height, b.y + b.height);
    _ = &max_y;
    var res: skb_rect2i_t = undefined;
    _ = &res;
    res.x = min_x;
    res.y = min_y;
    res.width = max_x - min_x;
    res.height = max_y - min_y;
    return res;
}
pub fn skb_rect2i_is_empty(r: skb_rect2i_t) callconv(.c) bool {
    _ = &r;
    return (r.width <= @as(c_int, 0)) or (r.height <= @as(c_int, 0));
}
pub fn skb_hash64_empty() callconv(.c) u64 {
    return 14695981039346656037;
}
pub fn skb_hash64_append(arg_hash: u64, arg_key: ?*const anyopaque, len: usize) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var key = arg_key;
    _ = &key;
    _ = &len;
    if (!(key != null)) return hash;
    const static_local_prime = struct {
        const prime: u64 = 1099511628211;
    };
    _ = &static_local_prime;
    var data: [*c]const u8 = @ptrCast(@alignCast(key));
    _ = &data;
    {
        var i: usize = 0;
        _ = &i;
        while (i < len) : (i +%= 1) {
            const value: u8 = data[@intCast(i)];
            _ = &value;
            hash = hash ^ @as(u64, @bitCast(@as(c_longlong, @as(c_int, value))));
            hash *%= static_local_prime.prime;
        }
    }
    return hash;
}
pub fn skb_hash64_append_float(arg_hash: u64, arg_value: f32) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var value = arg_value;
    _ = &value;
    return skb_hash64_append(hash, @ptrCast(@alignCast(&value)), @sizeOf(@TypeOf(value)));
}
pub fn skb_hash64_append_int32(arg_hash: u64, arg_value: i32) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var value = arg_value;
    _ = &value;
    return skb_hash64_append(hash, @ptrCast(@alignCast(&value)), @sizeOf(@TypeOf(value)));
}
pub fn skb_hash64_append_uint32(arg_hash: u64, arg_value: u32) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var value = arg_value;
    _ = &value;
    return skb_hash64_append(hash, @ptrCast(@alignCast(&value)), @sizeOf(@TypeOf(value)));
}
pub fn skb_hash64_append_uint64(arg_hash: u64, arg_value: u64) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var value = arg_value;
    _ = &value;
    return skb_hash64_append(hash, @ptrCast(@alignCast(&value)), @sizeOf(@TypeOf(value)));
}
pub fn skb_hash64_append_uint8(arg_hash: u64, arg_value: u8) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var value = arg_value;
    _ = &value;
    return skb_hash64_append(hash, @ptrCast(@alignCast(&value)), @sizeOf(@TypeOf(value)));
}
pub fn skb_hash64_append_str(arg_hash: u64, arg_key: [*c]const u8) callconv(.c) u64 {
    var hash = arg_hash;
    _ = &hash;
    var key = arg_key;
    _ = &key;
    if (!(key != null)) return hash;
    const static_local_prime = struct {
        const prime: u64 = 1099511628211;
    };
    _ = &static_local_prime;
    while (@as(c_int, key.*) != 0) {
        const value: u8 = key.*;
        _ = &value;
        hash = hash ^ @as(u64, @bitCast(@as(c_longlong, @as(c_int, value))));
        hash *%= static_local_prime.prime;
        key += 1;
    }
    return hash;
}
pub const SKB_TEMPALLOC_DEFAULT_BLOCK_SIZE: c_int = 131072;
pub const SKB_TEMPALLOC_ALIGN: c_int = 8;
const enum_unnamed_4 = c_uint;
pub const struct_skb_temp_alloc_t = opaque {
    pub const destroy = skb_temp_alloc_destroy;
    pub const stats = skb_temp_alloc_stats;
    pub const reset = skb_temp_alloc_reset;
    pub const save = skb_temp_alloc_save;
    pub const restore = skb_temp_alloc_restore;
    pub const alloc = skb_temp_alloc_alloc;
    pub const realloc = skb_temp_alloc_realloc;
    pub const free = skb_temp_alloc_free;
    pub const create = skb_canvas_create;
    pub const temp = skb_text_create_temp;
    pub const utf8 = skb_layout_create_utf8;
    pub const utf32 = skb_layout_create_utf32;
    pub const runs = skb_layout_create_from_runs;
    pub const text = skb_layout_create_from_text;
};
pub const skb_temp_alloc_t = struct_skb_temp_alloc_t;
pub const struct_skb_temp_alloc_mark_t = extern struct {
    block_num: i32 = 0,
    offset: i32 = 0,
};
pub const skb_temp_alloc_mark_t = struct_skb_temp_alloc_mark_t;
pub const struct_skb_temp_alloc_stats_t = extern struct {
    allocated: i32 = 0,
    used: i32 = 0,
};
pub const skb_temp_alloc_stats_t = struct_skb_temp_alloc_stats_t;
pub extern fn skb_temp_alloc_create(default_block_size: i32) ?*skb_temp_alloc_t;
pub extern fn skb_temp_alloc_destroy(alloc: ?*skb_temp_alloc_t) void;
pub extern fn skb_temp_alloc_stats(alloc: ?*skb_temp_alloc_t) skb_temp_alloc_stats_t;
pub extern fn skb_temp_alloc_reset(alloc: ?*skb_temp_alloc_t) void;
pub extern fn skb_temp_alloc_save(alloc: ?*skb_temp_alloc_t) skb_temp_alloc_mark_t;
pub extern fn skb_temp_alloc_restore(alloc: ?*skb_temp_alloc_t, mark: skb_temp_alloc_mark_t) void;
pub extern fn skb_temp_alloc_alloc(alloc: ?*skb_temp_alloc_t, size: i32) ?*anyopaque;
pub extern fn skb_temp_alloc_realloc(alloc: ?*skb_temp_alloc_t, ptr: ?*anyopaque, new_size: i32) ?*anyopaque;
pub extern fn skb_temp_alloc_free(alloc: ?*skb_temp_alloc_t, ptr: ?*anyopaque) void;
pub const struct_skb_hash_table_t = opaque {
    pub const destroy = skb_hash_table_destroy;
    pub const add = skb_hash_table_add;
    pub const find = skb_hash_table_find;
    pub const remove = skb_hash_table_remove;
};
pub const skb_hash_table_t = struct_skb_hash_table_t;
pub extern fn skb_hash_table_create() ?*skb_hash_table_t;
pub extern fn skb_hash_table_destroy(ht: ?*skb_hash_table_t) void;
pub extern fn skb_hash_table_add(ht: ?*skb_hash_table_t, hash: u64, value: i32) bool;
pub extern fn skb_hash_table_find(ht: ?*skb_hash_table_t, hash: u64, value: [*c]i32) bool;
pub extern fn skb_hash_table_remove(ht: ?*skb_hash_table_t, hash: u64) bool;
pub const struct_skb_list_item_t = extern struct {
    prev: i32 = 0,
    next: i32 = 0,
};
pub const skb_list_item_t = struct_skb_list_item_t;
pub const struct_skb_list_t = extern struct {
    head: i32 = 0,
    tail: i32 = 0,
    pub const remove = skb_list_remove;
    pub const front = skb_list_move_to_front;
};
pub const skb_list_t = struct_skb_list_t;
pub const skb_list_get_item_func_t = fn (item_idx: i32, context: ?*anyopaque) callconv(.c) [*c]skb_list_item_t;
pub fn skb_list_make() callconv(.c) skb_list_t {
    var res: skb_list_t = undefined;
    _ = &res;
    res.head = SKB_INVALID_INDEX;
    res.tail = SKB_INVALID_INDEX;
    return res;
}
pub fn skb_list_item_make() callconv(.c) skb_list_item_t {
    var res: skb_list_item_t = undefined;
    _ = &res;
    res.prev = SKB_INVALID_INDEX;
    res.next = SKB_INVALID_INDEX;
    return res;
}
pub fn skb_list_remove(arg_list: [*c]skb_list_t, arg_item_idx: i32, arg_get_item: ?*const skb_list_get_item_func_t, arg_context: ?*anyopaque) callconv(.c) void {
    var list = arg_list;
    _ = &list;
    var item_idx = arg_item_idx;
    _ = &item_idx;
    var get_item = arg_get_item;
    _ = &get_item;
    var context = arg_context;
    _ = &context;
    var item: [*c]skb_list_item_t = get_item.?(item_idx, context);
    _ = &item;
    if (item.*.prev != SKB_INVALID_INDEX) {
        get_item.?(item.*.prev, context).*.next = item.*.next;
    } else if (list.*.head == item_idx) {
        list.*.head = item.*.next;
    }
    if (item.*.next != SKB_INVALID_INDEX) {
        get_item.?(item.*.next, context).*.prev = item.*.prev;
    } else if (list.*.tail == item_idx) {
        list.*.tail = item.*.prev;
    }
    item.*.prev = SKB_INVALID_INDEX;
    item.*.next = SKB_INVALID_INDEX;
}
pub fn skb_list_move_to_front(arg_list: [*c]skb_list_t, arg_item_idx: i32, arg_get_item: ?*const skb_list_get_item_func_t, arg_context: ?*anyopaque) callconv(.c) void {
    var list = arg_list;
    _ = &list;
    var item_idx = arg_item_idx;
    _ = &item_idx;
    var get_item = arg_get_item;
    _ = &get_item;
    var context = arg_context;
    _ = &context;
    skb_list_remove(list, item_idx, get_item, context);
    var item: [*c]skb_list_item_t = get_item.?(item_idx, context);
    _ = &item;
    item.*.next = list.*.head;
    list.*.head = item_idx;
    if (item.*.next != SKB_INVALID_INDEX) {
        get_item.?(item.*.next, context).*.prev = item_idx;
    } else {
        list.*.tail = item_idx;
    }
}
pub const SKB_DIRECTION_AUTO: c_int = 0;
pub const SKB_DIRECTION_LTR: c_int = 1;
pub const SKB_DIRECTION_RTL: c_int = 2;
pub const skb_text_direction_t = c_uint;
pub fn skb_is_rtl(arg_direction: skb_text_direction_t) callconv(.c) bool {
    var direction = arg_direction;
    _ = &direction;
    return direction == @as(skb_text_direction_t, SKB_DIRECTION_RTL);
}
pub const SKB_CHAR_COMBINING_ENCLOSING_CIRCLE_BACKSLASH: c_int = 8416;
pub const SKB_CHAR_COMBINING_ENCLOSING_KEYCAP: c_int = 8419;
pub const SKB_char_VARIATION_SELECTOR15: c_int = 65038;
pub const SKB_CHAR_VARIATION_SELECTOR16: c_int = 65039;
pub const SKB_CHAR_ZERO_WIDTH_JOINER: c_int = 8205;
pub const SKB_CHAR_REGIONAL_INDICATOR_BASE: c_int = 127988;
pub const SKB_CHAR_CANCEL_TAG: c_int = 917631;
pub const SKB_CHAR_HORIZONTAL_TAB: c_int = 9;
pub const SKB_CHAR_LINE_FEED: c_int = 10;
pub const SKB_CHAR_VERTICAL_TAB: c_int = 11;
pub const SKB_CHAR_FORM_FEED: c_int = 12;
pub const SKB_CHAR_CARRIAGE_RETURN: c_int = 13;
pub const SKB_CHAR_NEXT_LINE: c_int = 133;
pub const SKB_CHAR_LINE_SEPARATOR: c_int = 8232;
pub const SKB_CHAR_PARAGRAPH_SEPARATOR: c_int = 8233;
pub const SKB_CHAR_REPLACEMENT_OBJECT: c_int = 65532;
pub const skb_character_t = c_uint;
pub extern fn skb_is_emoji_modifier_base(codepoint: u32) bool;
pub extern fn skb_is_emoji_presentation(codepoint: u32) bool;
pub extern fn skb_is_emoji(codepoint: u32) bool;
pub extern fn skb_is_emoji_modifier(codepoint: u32) bool;
pub extern fn skb_is_regional_indicator_symbol(codepoint: u32) bool;
pub extern fn skb_is_variation_selector(codepoint: u32) bool;
pub extern fn skb_is_keycap_base(codepoint: u32) bool;
pub extern fn skb_is_tag_spec_char(codepoint: u32) bool;
pub extern fn skb_is_paragraph_separator(codepoint: u32) bool;
pub const struct_skb_emoji_run_iterator_t = extern struct {
    emoji_category: [*c]u8 = null,
    count: i32 = 0,
    pos: i32 = 0,
    start: i32 = 0,
    offset: i32 = 0,
    has_emoji: bool = false,
    pub const next = skb_emoji_run_iterator_next;
};
pub const skb_emoji_run_iterator_t = struct_skb_emoji_run_iterator_t;
pub extern fn skb_emoji_run_iterator_make(range: skb_range_t, text: [*c]const u32, emoji_category_buffer: [*c]u8) skb_emoji_run_iterator_t;
pub extern fn skb_emoji_run_iterator_next(iter: [*c]skb_emoji_run_iterator_t, range: [*c]skb_range_t, range_has_emojis: [*c]bool) bool;
pub extern fn skb_utf8_to_utf32(utf8: [*c]const u8, utf8_len: i32, utf32: [*c]u32, utf32_cap: i32) i32;
pub extern fn skb_utf8_to_utf32_count(utf8: [*c]const u8, utf8_len: i32) i32;
pub extern fn skb_utf8_codepoint_offset(utf8: [*c]const u8, utf8_len: i32, codepoint_offset: i32) i32;
pub extern fn skb_utf8_num_units(cp: u32) i32;
pub extern fn skb_utf8_encode(cp: u32, utf8: [*c]u8, utf8_cap: i32) i32;
pub extern fn skb_utf32_to_utf8(utf32: [*c]const u32, utf32_len: i32, utf8: [*c]u8, utf8_cap: i32) i32;
pub extern fn skb_utf32_to_utf8_count(utf32: [*c]const u32, utf32_len: i32) i32;
pub extern fn skb_utf32_strlen(utf32: [*c]const u32) i32;
pub extern fn skb_utf32_copy(src: [*c]const u32, src_len: i32, dst: [*c]u32, dst_cap: i32) i32;
pub extern fn skb_perf_timer_get() i64;
pub extern fn skb_perf_timer_elapsed_us(start: i64, end: i64) i64;
pub const struct_hb_font_t = opaque {};
pub const hb_font_t = struct_hb_font_t;
pub const SKB_STYLE_NORMAL: c_int = 0;
pub const SKB_STYLE_ITALIC: c_int = 1;
pub const SKB_STYLE_OBLIQUE: c_int = 2;
pub const skb_style_t = c_uint;
pub const SKB_FONT_FAMILY_DEFAULT: c_int = 0;
pub const SKB_FONT_FAMILY_EMOJI: c_int = 1;
pub const SKB_FONT_FAMILY_SANS_SERIF: c_int = 2;
pub const SKB_FONT_FAMILY_SERIF: c_int = 3;
pub const SKB_FONT_FAMILY_MONOSPACE: c_int = 4;
pub const SKB_FONT_FAMILY_MATH: c_int = 5;
pub const skb_font_family_t = c_uint;
pub const SKB_STRETCH_NORMAL: c_int = 0;
pub const SKB_STRETCH_ULTRA_CONDENSED: c_int = 1;
pub const SKB_STRETCH_EXTRA_CONDENSED: c_int = 2;
pub const SKB_STRETCH_CONDENSED: c_int = 3;
pub const SKB_STRETCH_SEMI_CONDENSED: c_int = 4;
pub const SKB_STRETCH_SEMI_EXPANDED: c_int = 5;
pub const SKB_STRETCH_EXPANDED: c_int = 6;
pub const SKB_STRETCH_EXTRA_EXPANDED: c_int = 7;
pub const SKB_STRETCH_ULTRA_EXPANDED: c_int = 8;
pub const skb_stretch_t = c_uint;
pub const SKB_WEIGHT_NORMAL: c_int = 0;
pub const SKB_WEIGHT_THIN: c_int = 1;
pub const SKB_WEIGHT_EXTRALIGHT: c_int = 2;
pub const SKB_WEIGHT_ULTRALIGHT: c_int = 3;
pub const SKB_WEIGHT_LIGHT: c_int = 4;
pub const SKB_WEIGHT_REGULAR: c_int = 5;
pub const SKB_WEIGHT_MEDIUM: c_int = 6;
pub const SKB_WEIGHT_DEMIBOLD: c_int = 7;
pub const SKB_WEIGHT_SEMIBOLD: c_int = 8;
pub const SKB_WEIGHT_BOLD: c_int = 9;
pub const SKB_WEIGHT_EXTRABOLD: c_int = 10;
pub const SKB_WEIGHT_ULTRABOLD: c_int = 11;
pub const SKB_WEIGHT_BLACK: c_int = 12;
pub const SKB_WEIGHT_HEAVY: c_int = 13;
pub const SKB_WEIGHT_EXTRABLACK: c_int = 14;
pub const SKB_WEIGHT_ULTRABLACK: c_int = 15;
pub const skb_weight_t = c_uint;
pub const SKB_BASELINE_ALPHABETIC: c_int = 0;
pub const SKB_BASELINE_IDEOGRAPHIC: c_int = 1;
pub const SKB_BASELINE_CENTRAL: c_int = 2;
pub const SKB_BASELINE_HANGING: c_int = 3;
pub const SKB_BASELINE_MATHEMATICAL: c_int = 4;
pub const SKB_BASELINE_MIDDLE: c_int = 5;
pub const SKB_BASELINE_TEXT_TOP: c_int = 6;
pub const SKB_BASELINE_TEXT_BOTTOM: c_int = 7;
pub const SKB_BASELINE_MAX: c_int = 8;
pub const skb_baseline_t = c_uint;
pub const struct_skb_font_metrics_t = extern struct {
    ascender: f32 = 0,
    descender: f32 = 0,
    line_gap: f32 = 0,
    cap_height: f32 = 0,
    x_height: f32 = 0,
    underline_offset: f32 = 0,
    underline_size: f32 = 0,
    strikeout_offset: f32 = 0,
    strikeout_size: f32 = 0,
};
pub const skb_font_metrics_t = struct_skb_font_metrics_t;
const struct_unnamed_6 = extern struct {
    alphabetic: f32 = 0,
    ideographic: f32 = 0,
    central: f32 = 0,
    hanging: f32 = 0,
    mathematical: f32 = 0,
    middle: f32 = 0,
    text_bottom: f32 = 0,
    text_top: f32 = 0,
};
const union_unnamed_5 = extern union {
    baselines: [8]f32,
    unnamed_0: struct_unnamed_6,
};
pub const struct_skb_baseline_set_t = extern struct {
    unnamed_0: union_unnamed_5 = @import("std").mem.zeroes(union_unnamed_5),
    script: u8 = 0,
    direction: u8 = 0,
};
pub const skb_baseline_set_t = struct_skb_baseline_set_t;
pub const struct_skb_caret_metrics_t = extern struct {
    offset: f32 = 0,
    slope: f32 = 0,
};
pub const skb_caret_metrics_t = struct_skb_caret_metrics_t;
pub const struct_skb_font_create_params_t = extern struct {
    embolden_x: f32 = 0,
    embolden_y: f32 = 0,
    slant: f32 = 0,
};
pub const skb_font_create_params_t = struct_skb_font_create_params_t;
pub const skb_font_handle_t = u32;
pub const struct_skb_font_collection_t = opaque {
    pub const destroy = skb_font_collection_destroy;
    pub const fallback = skb_font_collection_set_on_font_fallback;
    pub const data = skb_font_collection_add_font_from_data;
    pub const font = skb_font_collection_add_font;
    pub const font1 = skb_font_collection_add_hb_font;
    pub const font2 = skb_font_collection_remove_font;
    pub const fonts = skb_font_collection_match_fonts;
    pub const codepoint = skb_font_collection_font_has_codepoint;
    pub const font3 = skb_font_collection_get_default_font;
    pub const font4 = skb_font_collection_get_font;
    pub const id = skb_font_collection_get_id;
    pub const bounds = skb_font_get_glyph_bounds;
    pub const metrics = skb_font_get_metrics;
    pub const metrics1 = skb_font_get_caret_metrics;
    pub const font5 = skb_font_get_hb_font;
    pub const baseline = skb_font_get_baseline;
    pub const set = skb_font_get_baseline_set;
};
pub const skb_font_collection_t = struct_skb_font_collection_t;
pub const struct_skb_font_t = opaque {};
pub const skb_font_t = struct_skb_font_t;
pub const skb_font_fallback_func_t = fn (font_collection: ?*skb_font_collection_t, lang: [*c]const u8, script: u8, font_family: u8, context: ?*anyopaque) callconv(.c) bool;
pub extern fn skb_font_collection_create() ?*skb_font_collection_t;
pub extern fn skb_font_collection_destroy(font_collection: ?*skb_font_collection_t) void;
pub extern fn skb_font_collection_set_on_font_fallback(font_collection: ?*skb_font_collection_t, fallback_func: ?*const skb_font_fallback_func_t, context: ?*anyopaque) void;
pub extern fn skb_font_collection_add_font_from_data(font_collection: ?*skb_font_collection_t, name: [*c]const u8, font_data: ?*const anyopaque, font_data_length: usize, context: ?*anyopaque, destroy_func: ?*const skb_destroy_func_t, font_family: u8, params: [*c]const skb_font_create_params_t) skb_font_handle_t;
pub extern fn skb_font_collection_add_font(font_collection: ?*skb_font_collection_t, file_name: [*c]const u8, font_family: u8, params: [*c]const skb_font_create_params_t) skb_font_handle_t;
pub extern fn skb_font_collection_add_hb_font(font_collection: ?*skb_font_collection_t, name: [*c]const u8, hb_font: ?*hb_font_t, font_family: u8, params: [*c]const skb_font_create_params_t) skb_font_handle_t;
pub extern fn skb_font_collection_remove_font(font_collection: ?*skb_font_collection_t, font_handle: skb_font_handle_t) bool;
pub extern fn skb_font_collection_match_fonts(font_collection: ?*skb_font_collection_t, lang: [*c]const u8, script: u8, font_family: u8, weight: skb_weight_t, style: skb_style_t, stretch: skb_stretch_t, results: [*c]skb_font_handle_t, results_cap: i32) i32;
pub extern fn skb_font_collection_font_has_codepoint(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t, codepoint: u32) bool;
pub extern fn skb_font_collection_get_default_font(font_collection: ?*skb_font_collection_t, font_family: u8) skb_font_handle_t;
pub extern fn skb_font_collection_get_font(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t) ?*skb_font_t;
pub extern fn skb_font_collection_get_id(font_collection: ?*const skb_font_collection_t) u32;
pub extern fn skb_font_get_glyph_bounds(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t, glyph_id: u32, font_size: f32) skb_rect2_t;
pub extern fn skb_font_get_metrics(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t) skb_font_metrics_t;
pub extern fn skb_font_get_caret_metrics(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t) skb_caret_metrics_t;
pub extern fn skb_font_get_hb_font(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t) ?*hb_font_t;
pub extern fn skb_font_get_baseline(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t, baseline: skb_baseline_t, direction: skb_text_direction_t, script: u8, font_size: f32) f32;
pub extern fn skb_font_get_baseline_set(font_collection: ?*const skb_font_collection_t, font_handle: skb_font_handle_t, direction: skb_text_direction_t, script: u8, font_size: f32) skb_baseline_set_t;
pub const struct_skb_attribute_text_direction_t = extern struct {
    kind: u32 = 0,
    direction: skb_text_direction_t = @import("std").mem.zeroes(skb_text_direction_t),
};
pub const skb_attribute_text_direction_t = struct_skb_attribute_text_direction_t;
pub const struct_skb_attribute_lang_t = extern struct {
    kind: u32 = 0,
    lang: [*c]const u8 = null,
};
pub const skb_attribute_lang_t = struct_skb_attribute_lang_t;
pub const struct_skb_attribute_font_family_t = extern struct {
    kind: u32 = 0,
    family: u8 = 0,
};
pub const skb_attribute_font_family_t = struct_skb_attribute_font_family_t;
pub const struct_skb_attribute_font_size_t = extern struct {
    kind: u32 = 0,
    size: f32 = 0,
};
pub const skb_attribute_font_size_t = struct_skb_attribute_font_size_t;
pub const struct_skb_attribute_font_weight_t = extern struct {
    kind: u32 = 0,
    weight: skb_weight_t = @import("std").mem.zeroes(skb_weight_t),
};
pub const skb_attribute_font_weight_t = struct_skb_attribute_font_weight_t;
pub const struct_skb_attribute_font_style_t = extern struct {
    kind: u32 = 0,
    style: skb_style_t = @import("std").mem.zeroes(skb_style_t),
};
pub const skb_attribute_font_style_t = struct_skb_attribute_font_style_t;
pub const struct_skb_attribute_font_stretch_t = extern struct {
    kind: u32 = 0,
    stretch: skb_stretch_t = @import("std").mem.zeroes(skb_stretch_t),
};
pub const skb_attribute_font_stretch_t = struct_skb_attribute_font_stretch_t;
pub const struct_skb_attribute_font_feature_t = extern struct {
    kind: u32 = 0,
    tag: u32 = 0,
    value: u32 = 0,
};
pub const skb_attribute_font_feature_t = struct_skb_attribute_font_feature_t;
pub const struct_skb_attribute_letter_spacing_t = extern struct {
    kind: u32 = 0,
    spacing: f32 = 0,
};
pub const skb_attribute_letter_spacing_t = struct_skb_attribute_letter_spacing_t;
pub const struct_skb_attribute_word_spacing_t = extern struct {
    kind: u32 = 0,
    spacing: f32 = 0,
};
pub const skb_attribute_word_spacing_t = struct_skb_attribute_word_spacing_t;
pub const struct_skb_attribute_line_height_t = extern struct {
    kind: u32 = 0,
    type: u8 = 0,
    height: f32 = 0,
};
pub const skb_attribute_line_height_t = struct_skb_attribute_line_height_t;
pub const struct_skb_attribute_tab_stop_increment_t = extern struct {
    kind: u32 = 0,
    increment: f32 = 0,
};
pub const skb_attribute_tab_stop_increment_t = struct_skb_attribute_tab_stop_increment_t;
pub const struct_skb_attribute_text_wrap_t = extern struct {
    kind: u32 = 0,
    text_wrap: skb_text_wrap_t = @import("std").mem.zeroes(skb_text_wrap_t),
};
pub const skb_attribute_text_wrap_t = struct_skb_attribute_text_wrap_t;
pub const struct_skb_attribute_text_overflow_t = extern struct {
    kind: u32 = 0,
    text_overflow: skb_text_overflow_t = @import("std").mem.zeroes(skb_text_overflow_t),
};
pub const skb_attribute_text_overflow_t = struct_skb_attribute_text_overflow_t;
pub const struct_skb_attribute_vertical_trim_t = extern struct {
    kind: u32 = 0,
    vertical_trim: skb_vertical_trim_t = @import("std").mem.zeroes(skb_vertical_trim_t),
};
pub const skb_attribute_vertical_trim_t = struct_skb_attribute_vertical_trim_t;
pub const struct_skb_attribute_align_t = extern struct {
    kind: u32 = 0,
    @"align": skb_align_t = @import("std").mem.zeroes(skb_align_t),
};
pub const skb_attribute_align_t = struct_skb_attribute_align_t;
pub const struct_skb_attribute_baseline_align_t = extern struct {
    kind: u32 = 0,
    baseline: skb_baseline_t = @import("std").mem.zeroes(skb_baseline_t),
};
pub const skb_attribute_baseline_align_t = struct_skb_attribute_baseline_align_t;
pub const struct_skb_attribute_fill_t = extern struct {
    kind: u32 = 0,
    color: skb_color_t = @import("std").mem.zeroes(skb_color_t),
};
pub const skb_attribute_fill_t = struct_skb_attribute_fill_t;
pub const struct_skb_attribute_decoration_t = extern struct {
    kind: u32 = 0,
    position: u8 = 0,
    style: u8 = 0,
    thickness: f32 = 0,
    offset: f32 = 0,
    color: skb_color_t = @import("std").mem.zeroes(skb_color_t),
};
pub const skb_attribute_decoration_t = struct_skb_attribute_decoration_t;
pub const struct_skb_attribute_object_align_t = extern struct {
    kind: u32 = 0,
    baseline_ratio: f32 = 0,
    align_ref: u8 = 0,
    align_baseline: u8 = 0,
};
pub const skb_attribute_object_align_t = struct_skb_attribute_object_align_t;
pub const struct_skb_attribute_object_padding_t = extern struct {
    kind: u32 = 0,
    start: f32 = 0,
    end: f32 = 0,
    top: f32 = 0,
    bottom: f32 = 0,
};
pub const skb_attribute_object_padding_t = struct_skb_attribute_object_padding_t;
pub const skb_attribute_set_handle_t = u64;
pub const struct_skb_attribute_reference_t = extern struct {
    kind: u32 = 0,
    handle: skb_attribute_set_handle_t = 0,
};
pub const skb_attribute_reference_t = struct_skb_attribute_reference_t;
pub const SKB_ATTRIBUTE_TEXT_DIRECTION: c_int = 1952737650;
pub const SKB_ATTRIBUTE_LANG: c_int = 1818324583;
pub const SKB_ATTRIBUTE_FONT_FAMILY: c_int = 1718578804;
pub const SKB_ATTRIBUTE_FONT_STRETCH: c_int = 1718842482;
pub const SKB_ATTRIBUTE_FONT_SIZE: c_int = 1718839674;
pub const SKB_ATTRIBUTE_FONT_WEIGHT: c_int = 1719100777;
pub const SKB_ATTRIBUTE_FONT_STYLE: c_int = 1718842489;
pub const SKB_ATTRIBUTE_FONT_FEATURE: c_int = 1717920116;
pub const SKB_ATTRIBUTE_LETTER_SPACING: c_int = 1818588016;
pub const SKB_ATTRIBUTE_WORD_SPACING: c_int = 2003792752;
pub const SKB_ATTRIBUTE_LINE_HEIGHT: c_int = 1819175013;
pub const SKB_ATTRIBUTE_TAB_STOP_INCREMENT: c_int = 1952539251;
pub const SKB_ATTRIBUTE_TEXT_WRAP: c_int = 1953985136;
pub const SKB_ATTRIBUTE_TEXT_OVERFLOW: c_int = 1953457772;
pub const SKB_ATTRIBUTE_VERTICAL_TRIM: c_int = 1987342957;
pub const SKB_ATTRIBUTE_HORIZONTAL_ALIGN: c_int = 1751215214;
pub const SKB_ATTRIBUTE_VERTICAL_ALIGN: c_int = 1986096238;
pub const SKB_ATTRIBUTE_BASELINE_ALIGN: c_int = 1650551918;
pub const SKB_ATTRIBUTE_FILL: c_int = 1718185068;
pub const SKB_ATTRIBUTE_DECORATION: c_int = 1684366191;
pub const SKB_ATTRIBUTE_OBJECT_ALIGN: c_int = 1868718444;
pub const SKB_ATTRIBUTE_OBJECT_PADDING: c_int = 1868722273;
pub const SKB_ATTRIBUTE_REFERENCE: c_int = 1634887014;
pub const skb_attribute_type_t = c_uint;
pub const union_skb_attribute_t = extern union {
    kind: u32,
    text_direction: skb_attribute_text_direction_t,
    lang: skb_attribute_lang_t,
    font_family: skb_attribute_font_family_t,
    font_size: skb_attribute_font_size_t,
    font_weight: skb_attribute_font_weight_t,
    font_style: skb_attribute_font_style_t,
    font_stretch: skb_attribute_font_stretch_t,
    font_feature: skb_attribute_font_feature_t,
    letter_spacing: skb_attribute_letter_spacing_t,
    word_spacing: skb_attribute_word_spacing_t,
    line_height: skb_attribute_line_height_t,
    tab_stop_increment: skb_attribute_tab_stop_increment_t,
    text_wrap: skb_attribute_text_wrap_t,
    text_overflow: skb_attribute_text_overflow_t,
    vertical_trim: skb_attribute_vertical_trim_t,
    horizontal_align: skb_attribute_align_t,
    vertical_align: skb_attribute_align_t,
    baseline_align: skb_attribute_baseline_align_t,
    fill: skb_attribute_fill_t,
    decoration: skb_attribute_decoration_t,
    object_align: skb_attribute_object_align_t,
    object_padding: skb_attribute_object_padding_t,
    reference: skb_attribute_reference_t,
};
pub const skb_attribute_t = union_skb_attribute_t;
pub const struct_skb_attribute_collection_t = opaque {
    pub const name = skb_attribute_set_make_reference_by_name;
    pub const name1 = skb_attribute_make_reference_by_name;
    pub const destroy = skb_attribute_collection_destroy;
    pub const id = skb_attribute_collection_get_id;
    pub const set = skb_attribute_collection_add_set;
    pub const group = skb_attribute_collection_add_set_with_group;
    pub const name2 = skb_attribute_collection_find_set_by_name;
    pub const set1 = skb_attribute_collection_get_set;
    pub const name3 = skb_attribute_collection_get_set_by_name;
};
pub const skb_attribute_collection_t = struct_skb_attribute_collection_t;
pub const struct_skb_attribute_set_t = extern struct {
    attributes: [*c]const skb_attribute_t = null,
    attributes_count: i32 = 0,
    set_handle: skb_attribute_set_handle_t = 0,
    parent_set: [*c]const struct_skb_attribute_set_t = null,
    pub const direction = skb_attributes_get_text_direction;
    pub const lang = skb_attributes_get_lang;
    pub const family = skb_attributes_get_font_family;
    pub const size = skb_attributes_get_font_size;
    pub const weight = skb_attributes_get_font_weight;
    pub const style = skb_attributes_get_font_style;
    pub const stretch = skb_attributes_get_font_stretch;
    pub const spacing = skb_attributes_get_letter_spacing;
    pub const spacing1 = skb_attributes_get_word_spacing;
    pub const height = skb_attributes_get_line_height;
    pub const fill = skb_attributes_get_fill;
    pub const @"align" = skb_attributes_get_object_align;
    pub const padding = skb_attributes_get_object_padding;
    pub const increment = skb_attributes_get_tab_stop_increment;
    pub const wrap = skb_attributes_get_text_wrap;
    pub const overflow = skb_attributes_get_text_overflow;
    pub const trim = skb_attributes_get_vertical_trim;
    pub const align1 = skb_attributes_get_horizontal_align;
    pub const align2 = skb_attributes_get_vertical_align;
    pub const align3 = skb_attributes_get_baseline_align;
    pub const kind = skb_attributes_get_by_kind;
    pub const count = skb_attributes_get_copy_flat_count;
    pub const flat = skb_attributes_copy_flat;
};
pub const skb_attribute_set_t = struct_skb_attribute_set_t;
pub extern fn skb_attribute_set_make_reference(handle: skb_attribute_set_handle_t) skb_attribute_set_t;
pub extern fn skb_attribute_set_make_reference_by_name(attribute_collection: ?*const skb_attribute_collection_t, name: [*c]const u8) skb_attribute_set_t;
pub extern fn skb_attribute_make_text_direction(direction: skb_text_direction_t) skb_attribute_t;
pub extern fn skb_attribute_make_lang(lang: [*c]const u8) skb_attribute_t;
pub extern fn skb_attribute_make_font_family(family: u8) skb_attribute_t;
pub extern fn skb_attribute_make_font_size(size: f32) skb_attribute_t;
pub extern fn skb_attribute_make_font_weight(weight: skb_weight_t) skb_attribute_t;
pub extern fn skb_attribute_make_font_style(style: skb_style_t) skb_attribute_t;
pub extern fn skb_attribute_make_font_stretch(stretch: skb_stretch_t) skb_attribute_t;
pub extern fn skb_attribute_make_font_feature(tag: u32, value: u32) skb_attribute_t;
pub extern fn skb_attribute_make_letter_spacing(letter_spacing: f32) skb_attribute_t;
pub extern fn skb_attribute_make_word_spacing(word_spacing: f32) skb_attribute_t;
pub extern fn skb_attribute_make_line_height(@"type": skb_line_height_t, height: f32) skb_attribute_t;
pub extern fn skb_attribute_make_tab_stop_increment(increment: f32) skb_attribute_t;
pub extern fn skb_attribute_make_text_wrap(text_wrap: skb_text_wrap_t) skb_attribute_t;
pub extern fn skb_attribute_make_text_overflow(text_overflow: skb_text_overflow_t) skb_attribute_t;
pub extern fn skb_attribute_make_vertical_trim(vertical_trim: skb_vertical_trim_t) skb_attribute_t;
pub extern fn skb_attribute_make_horizontal_align(horizontal_align: skb_align_t) skb_attribute_t;
pub extern fn skb_attribute_make_vertical_align(vertical_align: skb_align_t) skb_attribute_t;
pub extern fn skb_attribute_make_baseline_align(baseline_align: skb_baseline_t) skb_attribute_t;
pub extern fn skb_attribute_make_fill(color: skb_color_t) skb_attribute_t;
pub extern fn skb_attribute_make_decoration(position: skb_decoration_position_t, style: skb_decoration_style_t, thickness: f32, offset: f32, color: skb_color_t) skb_attribute_t;
pub extern fn skb_attribute_make_object_align(baseline_ratio: f32, align_ref: skb_object_align_reference_t, align_baseline: skb_baseline_t) skb_attribute_t;
pub extern fn skb_attribute_make_object_padding(start: f32, end: f32, top: f32, bottom: f32) skb_attribute_t;
pub extern fn skb_attribute_make_object_padding_hv(horizontal: f32, vertical: f32) skb_attribute_t;
pub extern fn skb_attribute_make_reference(set_handle: skb_attribute_set_handle_t) skb_attribute_t;
pub extern fn skb_attribute_make_reference_by_name(attribute_collection: ?*const skb_attribute_collection_t, name: [*c]const u8) skb_attribute_t;
pub extern fn skb_attributes_get_text_direction(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_text_direction_t;
pub extern fn skb_attributes_get_lang(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) [*c]const u8;
pub extern fn skb_attributes_get_font_family(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) u8;
pub extern fn skb_attributes_get_font_size(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) f32;
pub extern fn skb_attributes_get_font_weight(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_weight_t;
pub extern fn skb_attributes_get_font_style(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_style_t;
pub extern fn skb_attributes_get_font_stretch(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_stretch_t;
pub extern fn skb_attributes_get_letter_spacing(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) f32;
pub extern fn skb_attributes_get_word_spacing(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) f32;
pub extern fn skb_attributes_get_line_height(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_attribute_line_height_t;
pub extern fn skb_attributes_get_fill(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_attribute_fill_t;
pub extern fn skb_attributes_get_object_align(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_attribute_object_align_t;
pub extern fn skb_attributes_get_object_padding(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_attribute_object_padding_t;
pub extern fn skb_attributes_get_tab_stop_increment(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) f32;
pub extern fn skb_attributes_get_text_wrap(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_text_wrap_t;
pub extern fn skb_attributes_get_text_overflow(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_text_overflow_t;
pub extern fn skb_attributes_get_vertical_trim(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_vertical_trim_t;
pub extern fn skb_attributes_get_horizontal_align(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_align_t;
pub extern fn skb_attributes_get_vertical_align(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_align_t;
pub extern fn skb_attributes_get_baseline_align(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t) skb_baseline_t;
pub extern fn skb_attributes_get_by_kind(attributes: skb_attribute_set_t, collection: ?*const skb_attribute_collection_t, kind: u32, results: [*c][*c]const skb_attribute_t, results_cap: i32) i32;
pub extern fn skb_attributes_get_copy_flat_count(attributes: skb_attribute_set_t) i32;
pub extern fn skb_attributes_copy_flat(attributes: skb_attribute_set_t, dest: [*c]skb_attribute_t, dest_cap: i32) i32;
pub extern fn skb_attributes_hash_append(hash: u64, attributes: skb_attribute_set_t) u64;
pub fn skb_attribute_set_handle_get_group(arg_handle: skb_attribute_set_handle_t) callconv(.c) i32 {
    var handle = arg_handle;
    _ = &handle;
    return @bitCast(@as(c_uint, @truncate(handle & @as(skb_attribute_set_handle_t, 4294967295))));
}
pub extern fn skb_attribute_collection_create() ?*skb_attribute_collection_t;
pub extern fn skb_attribute_collection_destroy(attribute_collection: ?*skb_attribute_collection_t) void;
pub extern fn skb_attribute_collection_get_id(attribute_collection: ?*const skb_attribute_collection_t) u32;
pub extern fn skb_attribute_collection_add_set(attribute_collection: ?*skb_attribute_collection_t, name: [*c]const u8, attributes: skb_attribute_set_t) skb_attribute_set_handle_t;
pub extern fn skb_attribute_collection_add_set_with_group(attribute_collection: ?*skb_attribute_collection_t, name: [*c]const u8, group_name: [*c]const u8, attributes: skb_attribute_set_t) skb_attribute_set_handle_t;
pub extern fn skb_attribute_collection_find_set_by_name(attribute_collection: ?*const skb_attribute_collection_t, name: [*c]const u8) skb_attribute_set_handle_t;
pub extern fn skb_attribute_collection_get_set(attribute_collection: ?*const skb_attribute_collection_t, handle: skb_attribute_set_handle_t) skb_attribute_set_t;
pub extern fn skb_attribute_collection_get_set_by_name(attribute_collection: ?*const skb_attribute_collection_t, name: [*c]const u8) skb_attribute_set_t;
pub const SKB_SPREAD_PAD: c_int = 0;
pub const SKB_SPREAD_REPEAT: c_int = 1;
pub const SKB_SPREAD_REFLECT: c_int = 2;
pub const skb_gradient_spread_t = c_uint;
pub const struct_skb_canvas_t = opaque {
    pub const destroy = skb_canvas_destroy;
    pub const to = skb_canvas_move_to;
    pub const to1 = skb_canvas_line_to;
    pub const to2 = skb_canvas_quad_to;
    pub const to3 = skb_canvas_cubic_to;
    pub const close = skb_canvas_close;
    pub const transform = skb_canvas_push_transform;
    pub const transform1 = skb_canvas_pop_transform;
    pub const mask = skb_canvas_push_mask;
    pub const mask1 = skb_canvas_pop_mask;
    pub const layer = skb_canvas_push_layer;
    pub const layer1 = skb_canvas_pop_layer;
    pub const mask2 = skb_canvas_fill_mask;
    pub const color = skb_canvas_fill_solid_color;
    pub const gradient = skb_canvas_fill_linear_gradient;
    pub const gradient1 = skb_canvas_fill_radial_gradient;
};
pub const skb_canvas_t = struct_skb_canvas_t;
pub const struct_skb_color_stop_t = extern struct {
    offset: f32 = 0,
    color: skb_color_t = @import("std").mem.zeroes(skb_color_t),
};
pub const skb_color_stop_t = struct_skb_color_stop_t;
pub extern fn skb_canvas_create(temp_alloc: ?*skb_temp_alloc_t, target: [*c]skb_image_t) ?*skb_canvas_t;
pub extern fn skb_canvas_destroy(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_move_to(c: ?*skb_canvas_t, pt: skb_vec2_t) void;
pub extern fn skb_canvas_line_to(c: ?*skb_canvas_t, pt: skb_vec2_t) void;
pub extern fn skb_canvas_quad_to(c: ?*skb_canvas_t, cp: skb_vec2_t, pt: skb_vec2_t) void;
pub extern fn skb_canvas_cubic_to(c: ?*skb_canvas_t, cp0: skb_vec2_t, cp1: skb_vec2_t, pt: skb_vec2_t) void;
pub extern fn skb_canvas_close(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_push_transform(c: ?*skb_canvas_t, t: skb_mat2_t) void;
pub extern fn skb_canvas_pop_transform(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_push_mask(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_pop_mask(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_push_layer(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_pop_layer(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_fill_mask(c: ?*skb_canvas_t) void;
pub extern fn skb_canvas_fill_solid_color(c: ?*skb_canvas_t, color: skb_color_t) void;
pub extern fn skb_canvas_fill_linear_gradient(c: ?*skb_canvas_t, p0: skb_vec2_t, p1: skb_vec2_t, spread: skb_gradient_spread_t, stops: [*c]const skb_color_stop_t, stops_count: i32) void;
pub extern fn skb_canvas_fill_radial_gradient(c: ?*skb_canvas_t, p0: skb_vec2_t, r0: f32, p1: skb_vec2_t, r1: f32, spread: skb_gradient_spread_t, stops: [*c]const skb_color_stop_t, stops_count: i32) void;
pub const SKB_MAX_ACTIVE_ATTRIBUTES: c_int = 64;
const enum_unnamed_7 = c_uint;
pub const struct_skb_attribute_span_t = extern struct {
    text_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    attribute: skb_attribute_t = @import("std").mem.zeroes(skb_attribute_t),
};
pub const skb_attribute_span_t = struct_skb_attribute_span_t;
pub const struct_skb_text_t = opaque {
    pub const destroy = skb_text_destroy;
    pub const reset = skb_text_reset;
    pub const reserve = skb_text_reserve;
    pub const count = skb_text_get_utf32_count;
    pub const utf32 = skb_text_get_utf32;
    pub const range = skb_text_sanitize_range;
    pub const count1 = skb_text_get_attribute_spans_count;
    pub const spans = skb_text_get_attribute_spans;
    pub const append = skb_text_append;
    pub const range1 = skb_text_append_range;
    pub const utf8 = skb_text_append_utf8;
    pub const utf321 = skb_text_append_utf32;
    pub const replace = skb_text_replace;
    pub const utf81 = skb_text_replace_utf8;
    pub const utf322 = skb_text_replace_utf32;
    pub const remove = skb_text_remove;
    pub const @"if" = skb_text_remove_if;
    pub const attribute = skb_text_clear_attribute;
    pub const attributes = skb_text_clear_all_attributes;
    pub const attribute1 = skb_text_add_attribute;
    pub const runs = skb_text_iterate_attribute_runs;
};
pub const skb_text_t = struct_skb_text_t;
pub extern fn skb_text_create() ?*skb_text_t;
pub extern fn skb_text_create_temp(temp_alloc: ?*skb_temp_alloc_t) ?*skb_text_t;
pub extern fn skb_text_destroy(text: ?*skb_text_t) void;
pub extern fn skb_text_reset(text: ?*skb_text_t) void;
pub extern fn skb_text_reserve(text: ?*skb_text_t, text_count: i32, spans_count: i32) void;
pub extern fn skb_text_get_utf32_count(text: ?*const skb_text_t) i32;
pub extern fn skb_text_get_utf32(text: ?*const skb_text_t) [*c]const u32;
pub extern fn skb_text_sanitize_range(text: ?*const skb_text_t, range: skb_range_t) skb_range_t;
pub extern fn skb_text_get_attribute_spans_count(text: ?*const skb_text_t) i32;
pub extern fn skb_text_get_attribute_spans(text: ?*const skb_text_t) [*c]const skb_attribute_span_t;
pub extern fn skb_text_append(text: ?*skb_text_t, text_from: ?*const skb_text_t) void;
pub extern fn skb_text_append_range(text: ?*skb_text_t, from_text: ?*const skb_text_t, from_range: skb_range_t) void;
pub extern fn skb_text_append_utf8(text: ?*skb_text_t, utf8: [*c]const u8, utf8_count: i32, attributes: skb_attribute_set_t) void;
pub extern fn skb_text_append_utf32(text: ?*skb_text_t, utf32: [*c]const u32, utf32_count: i32, attributes: skb_attribute_set_t) void;
pub extern fn skb_text_replace(text: ?*skb_text_t, range: skb_range_t, other: ?*const skb_text_t) void;
pub extern fn skb_text_replace_utf8(text: ?*skb_text_t, range: skb_range_t, utf8: [*c]const u8, utf8_count: i32, attributes: skb_attribute_set_t) void;
pub extern fn skb_text_replace_utf32(text: ?*skb_text_t, range: skb_range_t, utf32: [*c]const u32, utf32_count: i32, attributes: skb_attribute_set_t) void;
pub extern fn skb_text_remove(text: ?*skb_text_t, range: skb_range_t) void;
pub const skb_text_remove_func_t = fn (codepoint: u32, index: i32, context: ?*anyopaque) callconv(.c) bool;
pub extern fn skb_text_remove_if(text: ?*skb_text_t, filter_func: ?*const skb_text_remove_func_t, context: ?*anyopaque) void;
pub extern fn skb_text_clear_attribute(text: ?*skb_text_t, range: skb_range_t, attribute: skb_attribute_t) void;
pub extern fn skb_text_clear_all_attributes(text: ?*skb_text_t, range: skb_range_t) void;
pub extern fn skb_text_add_attribute(text: ?*skb_text_t, range: skb_range_t, attribute: skb_attribute_t) void;
pub const skb_attribute_run_iterator_func_t = fn (text: ?*const skb_text_t, range: skb_range_t, active_spans: [*c][*c]skb_attribute_span_t, active_spans_count: i32, context: ?*anyopaque) callconv(.c) void;
pub extern fn skb_text_iterate_attribute_runs(text: ?*const skb_text_t, callback: ?*const skb_attribute_run_iterator_func_t, context: ?*anyopaque) void;
pub const struct_skb_icon_collection_t = opaque {
    pub const destroy = skb_icon_collection_destroy;
    pub const data = skb_icon_collection_add_picosvg_icon_from_data;
    pub const icon = skb_icon_collection_add_picosvg_icon;
    pub const icon1 = skb_icon_collection_add_icon;
    pub const icon2 = skb_icon_collection_remove_icon;
    pub const icon3 = skb_icon_collection_find_icon;
    pub const color = skb_icon_collection_set_is_color;
    pub const scale = skb_icon_collection_calc_proportional_scale;
    pub const size = skb_icon_collection_calc_proportional_size;
    pub const size1 = skb_icon_collection_get_icon_size;
    pub const icon4 = skb_icon_collection_get_icon;
    pub const id = skb_icon_collection_get_id;
    pub const make = skb_icon_builder_make;
};
pub const skb_icon_collection_t = struct_skb_icon_collection_t;
pub const struct_skb_icon_t = opaque {
    pub const dimensions = skb_rasterizer_get_icon_dimensions;
};
pub const skb_icon_t = struct_skb_icon_t;
pub const struct_skb_icon_shape_t = opaque {};
pub const skb_icon_shape_t = struct_skb_icon_shape_t;
pub const skb_icon_handle_t = u32;
pub extern fn skb_icon_collection_create() ?*skb_icon_collection_t;
pub extern fn skb_icon_collection_destroy(icon_collection: ?*skb_icon_collection_t) void;
pub extern fn skb_icon_collection_add_picosvg_icon_from_data(icon_collection: ?*skb_icon_collection_t, name: [*c]const u8, icon_data: [*c]const u8, icon_data_length: i32) skb_icon_handle_t;
pub extern fn skb_icon_collection_add_picosvg_icon(icon_collection: ?*skb_icon_collection_t, name: [*c]const u8, file_name: [*c]const u8) skb_icon_handle_t;
pub extern fn skb_icon_collection_add_icon(icon_collection: ?*skb_icon_collection_t, name: [*c]const u8, width: f32, height: f32) skb_icon_handle_t;
pub extern fn skb_icon_collection_remove_icon(icon_collection: ?*skb_icon_collection_t, icon_handle: skb_icon_handle_t) bool;
pub extern fn skb_icon_collection_find_icon(icon_collection: ?*const skb_icon_collection_t, name: [*c]const u8) skb_icon_handle_t;
pub extern fn skb_icon_collection_set_is_color(icon_collection: ?*skb_icon_collection_t, icon_handle: skb_icon_handle_t, is_color: bool) void;
pub extern fn skb_icon_collection_calc_proportional_scale(icon_collection: ?*const skb_icon_collection_t, icon_handle: skb_icon_handle_t, width: f32, height: f32) skb_vec2_t;
pub extern fn skb_icon_collection_calc_proportional_size(icon_collection: ?*const skb_icon_collection_t, icon_handle: skb_icon_handle_t, width: f32, height: f32) skb_vec2_t;
pub extern fn skb_icon_collection_get_icon_size(icon_collection: ?*const skb_icon_collection_t, icon_handle: skb_icon_handle_t) skb_vec2_t;
pub extern fn skb_icon_collection_get_icon(icon_collection: ?*const skb_icon_collection_t, icon_handle: skb_icon_handle_t) ?*const skb_icon_t;
pub extern fn skb_icon_collection_get_id(icon_collection: ?*const skb_icon_collection_t) u32;
pub const SKB_ICON_BUILDER_MAX_NESTED_SHAPES: c_int = 8;
const enum_unnamed_8 = c_uint;
pub const struct_skb_icon_builder_t = extern struct {
    icon_collection: ?*skb_icon_collection_t = null,
    icon_handle: skb_icon_handle_t = 0,
    shape_stack: [8]?*skb_icon_shape_t = @import("std").mem.zeroes([8]?*skb_icon_shape_t),
    shape_stack_idx: i32 = 0,
    pub const shape = skb_icon_builder_begin_shape;
    pub const shape1 = skb_icon_builder_end_shape;
    pub const to = skb_icon_builder_move_to;
    pub const to1 = skb_icon_builder_line_to;
    pub const to2 = skb_icon_builder_quad_to;
    pub const to3 = skb_icon_builder_cubic_to;
    pub const path = skb_icon_builder_close_path;
    pub const opacity = skb_icon_builder_fill_opacity;
    pub const color = skb_icon_builder_fill_color;
    pub const gradient = skb_icon_builder_fill_linear_gradient;
    pub const gradient1 = skb_icon_builder_fill_radial_gradient;
};
pub const skb_icon_builder_t = struct_skb_icon_builder_t;
pub extern fn skb_icon_builder_make(icon_collection: ?*skb_icon_collection_t, icon_handle: skb_icon_handle_t) skb_icon_builder_t;
pub extern fn skb_icon_builder_begin_shape(icon_builder: [*c]skb_icon_builder_t) void;
pub extern fn skb_icon_builder_end_shape(icon_builder: [*c]skb_icon_builder_t) void;
pub extern fn skb_icon_builder_move_to(icon_builder: [*c]skb_icon_builder_t, pt: skb_vec2_t) void;
pub extern fn skb_icon_builder_line_to(icon_builder: [*c]skb_icon_builder_t, pt: skb_vec2_t) void;
pub extern fn skb_icon_builder_quad_to(icon_builder: [*c]skb_icon_builder_t, cp: skb_vec2_t, pt: skb_vec2_t) void;
pub extern fn skb_icon_builder_cubic_to(icon_builder: [*c]skb_icon_builder_t, cp0: skb_vec2_t, cp1: skb_vec2_t, pt: skb_vec2_t) void;
pub extern fn skb_icon_builder_close_path(icon_builder: [*c]skb_icon_builder_t) void;
pub extern fn skb_icon_builder_fill_opacity(icon_builder: [*c]skb_icon_builder_t, opacity: f32) void;
pub extern fn skb_icon_builder_fill_color(icon_builder: [*c]skb_icon_builder_t, color: skb_color_t) void;
pub extern fn skb_icon_builder_fill_linear_gradient(icon_builder: [*c]skb_icon_builder_t, p0: skb_vec2_t, p1: skb_vec2_t, xform: skb_mat2_t, spread: skb_gradient_spread_t, stops: [*c]skb_color_stop_t, stops_count: i32) void;
pub extern fn skb_icon_builder_fill_radial_gradient(icon_builder: [*c]skb_icon_builder_t, p0: skb_vec2_t, p1: skb_vec2_t, radius: f32, xform: skb_mat2_t, spread: skb_gradient_spread_t, stops: [*c]skb_color_stop_t, stops_count: i32) void;
pub const struct_hb_language_impl_t = opaque {};
pub const hb_language_t = ?*const struct_hb_language_impl_t;
pub const SKB_LAYOUT_PARAMS_IGNORE_MUST_LINE_BREAKS: c_int = 1;
pub const enum_skb_layout_params_flags_t = c_uint;
pub const struct_skb_layout_params_t = extern struct {
    font_collection: ?*skb_font_collection_t = null,
    icon_collection: ?*skb_icon_collection_t = null,
    attribute_collection: ?*skb_attribute_collection_t = null,
    layout_width: f32 = 0,
    layout_height: f32 = 0,
    flags: u8 = 0,
    layout_attributes: skb_attribute_set_t = @import("std").mem.zeroes(skb_attribute_set_t),
    pub const create = skb_layout_create;
};
pub const skb_layout_params_t = struct_skb_layout_params_t;
pub const struct_skb_content_text_utf8_t = extern struct {
    text: [*c]const u8 = null,
    text_count: i32 = 0,
};
pub const skb_content_text_utf8_t = struct_skb_content_text_utf8_t;
pub const struct_skb_content_text_utf32_t = extern struct {
    text: [*c]const u32 = null,
    text_count: i32 = 0,
};
pub const skb_content_text_utf32_t = struct_skb_content_text_utf32_t;
pub const struct_skb_content_object_t = extern struct {
    width: f32 = 0,
    height: f32 = 0,
    data: isize = 0,
};
pub const skb_content_object_t = struct_skb_content_object_t;
pub const struct_skb_content_icon_t = extern struct {
    width: f32 = 0,
    height: f32 = 0,
    icon_handle: skb_icon_handle_t = 0,
};
pub const skb_content_icon_t = struct_skb_content_icon_t;
pub const SKB_CONTENT_RUN_UTF8: c_int = 0;
pub const SKB_CONTENT_RUN_UTF32: c_int = 1;
pub const SKB_CONTENT_RUN_OBJECT: c_int = 2;
pub const SKB_CONTENT_RUN_ICON: c_int = 3;
pub const skb_content_run_type_t = c_uint;
const union_unnamed_9 = extern union {
    utf8: skb_content_text_utf8_t,
    utf32: skb_content_text_utf32_t,
    object: skb_content_object_t,
    icon: skb_content_icon_t,
};
pub const struct_skb_content_run_t = extern struct {
    unnamed_0: union_unnamed_9 = @import("std").mem.zeroes(union_unnamed_9),
    run_id: isize = 0,
    attributes: skb_attribute_set_t = @import("std").mem.zeroes(skb_attribute_set_t),
    type: u8 = 0,
};
pub const skb_content_run_t = struct_skb_content_run_t;
pub extern fn skb_content_run_make_utf8(text: [*c]const u8, text_count: i32, attributes: skb_attribute_set_t, run_id: isize) skb_content_run_t;
pub extern fn skb_content_run_make_utf32(text: [*c]const u32, text_count: i32, attributes: skb_attribute_set_t, run_id: isize) skb_content_run_t;
pub extern fn skb_content_run_make_object(data: isize, width: f32, height: f32, attributes: skb_attribute_set_t, run_id: isize) skb_content_run_t;
pub extern fn skb_content_run_make_icon(icon_handle: skb_icon_handle_t, width: f32, height: f32, attributes: skb_attribute_set_t, run_id: isize) skb_content_run_t;
pub const SKB_LAYOUT_LINE_IS_TRUNCATED: c_int = 1;
pub const skb_layout_line_flags_t = c_uint;
pub const struct_skb_layout_line_t = extern struct {
    text_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    layout_run_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    decorations_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    last_grapheme_offset: i32 = 0,
    ascender: f32 = 0,
    descender: f32 = 0,
    baseline: f32 = 0,
    bounds: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    culling_bounds: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    common_glyph_bounds: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    flags: u8 = 0,
};
pub const skb_layout_line_t = struct_skb_layout_line_t;
const union_unnamed_10 = extern union {
    font_handle: skb_font_handle_t,
    object_data: isize,
    icon_handle: skb_icon_handle_t,
};
pub const struct_skb_layout_run_t = extern struct {
    type: u8 = 0,
    direction: u8 = 0,
    script: u8 = 0,
    bidi_level: u8 = 0,
    content_run_idx: i32 = 0,
    glyph_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    cluster_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    bounds: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    ref_baseline: f32 = 0,
    font_size: f32 = 0,
    attributes: skb_attribute_set_t = @import("std").mem.zeroes(skb_attribute_set_t),
    content_run_id: isize = 0,
    unnamed_0: union_unnamed_10 = @import("std").mem.zeroes(union_unnamed_10),
};
pub const skb_layout_run_t = struct_skb_layout_run_t;
pub const struct_skb_cluster_t = extern struct {
    text_offset: i32 = 0,
    glyphs_offset: i32 = 0,
    text_count: u8 = 0,
    glyphs_count: u8 = 0,
};
pub const skb_cluster_t = struct_skb_cluster_t;
pub const struct_skb_glyph_t = extern struct {
    offset_x: f32 = 0,
    offset_y: f32 = 0,
    advance_x: f32 = 0,
    cluster_idx: i32 = 0,
    gid: u16 = 0,
};
pub const skb_glyph_t = struct_skb_glyph_t;
pub const struct_skb_decoration_t = extern struct {
    layout_run_idx: i32 = 0,
    glyph_range: skb_range_t = @import("std").mem.zeroes(skb_range_t),
    offset_x: f32 = 0,
    offset_y: f32 = 0,
    length: f32 = 0,
    pattern_offset: f32 = 0,
    thickness: f32 = 0,
    color: skb_color_t = @import("std").mem.zeroes(skb_color_t),
    position: u8 = 0,
    style: u8 = 0,
};
pub const skb_decoration_t = struct_skb_decoration_t;
pub const SKB_TEXT_PROP_GRAPHEME_BREAK: c_int = 1;
pub const SKB_TEXT_PROP_WORD_BREAK: c_int = 2;
pub const SKB_TEXT_PROP_MUST_LINE_BREAK: c_int = 4;
pub const SKB_TEXT_PROP_ALLOW_LINE_BREAK: c_int = 8;
pub const SKB_TEXT_PROP_EMOJI: c_int = 16;
pub const SKB_TEXT_PROP_CONTROL: c_int = 32;
pub const SKB_TEXT_PROP_WHITESPACE: c_int = 64;
pub const SKB_TEXT_PROP_PUNCTUATION: c_int = 128;
pub const enum_skb_text_prop_flags_t = c_uint;
pub const struct_skb_text_property_t = extern struct {
    flags: u8 = 0,
    script: u8 = 0,
};
pub const skb_text_property_t = struct_skb_text_property_t;
pub const struct_skb_layout_t = opaque {
    pub const utf8 = skb_layout_set_utf8;
    pub const utf32 = skb_layout_set_utf32;
    pub const runs = skb_layout_set_from_runs;
    pub const text = skb_layout_set_from_text;
    pub const reset = skb_layout_reset;
    pub const destroy = skb_layout_destroy;
    pub const params = skb_layout_get_params;
    pub const count = skb_layout_get_text_count;
    pub const text1 = skb_layout_get_text;
    pub const properties = skb_layout_get_text_properties;
    pub const count1 = skb_layout_get_layout_runs_count;
    pub const runs1 = skb_layout_get_layout_runs;
    pub const count2 = skb_layout_get_glyphs_count;
    pub const glyphs = skb_layout_get_glyphs;
    pub const count3 = skb_layout_get_clusters_count;
    pub const clusters = skb_layout_get_clusters;
    pub const count4 = skb_layout_get_decorations_count;
    pub const decorations = skb_layout_get_decorations;
    pub const count5 = skb_layout_get_lines_count;
    pub const lines = skb_layout_get_lines;
    pub const bounds = skb_layout_get_bounds;
    pub const direction = skb_layout_get_resolved_direction;
    pub const offset = skb_layout_next_grapheme_offset;
    pub const offset1 = skb_layout_prev_grapheme_offset;
    pub const offset2 = skb_layout_align_grapheme_offset;
    pub const index = skb_layout_get_line_index;
    pub const offset3 = skb_layout_get_text_offset;
    pub const at = skb_layout_get_text_direction_at;
    pub const line = skb_layout_hit_test_at_line;
    pub const @"test" = skb_layout_hit_test;
    pub const line1 = skb_layout_hit_test_content_at_line;
    pub const content = skb_layout_hit_test_content;
    pub const line2 = skb_layout_get_content_bounds_at_line;
    pub const bounds1 = skb_layout_get_content_bounds;
    pub const line3 = skb_layout_get_visual_caret_at_line;
    pub const at1 = skb_layout_get_visual_caret_at;
    pub const at2 = skb_layout_get_line_start_at;
    pub const at3 = skb_layout_get_line_end_at;
    pub const at4 = skb_layout_get_word_start_at;
    pub const at5 = skb_layout_get_word_end_at;
    pub const start = skb_layout_get_selection_ordered_start;
    pub const end = skb_layout_get_selection_ordered_end;
    pub const range = skb_layout_get_selection_text_offset_range;
    pub const count6 = skb_layout_get_selection_count;
    pub const bounds2 = skb_layout_get_selection_bounds;
    pub const offset4 = skb_layout_get_selection_bounds_with_offset;
    pub const make = skb_caret_iterator_make;
};
pub const skb_layout_t = struct_skb_layout_t;
pub extern fn skb_layout_params_hash_append(hash: u64, params: [*c]const skb_layout_params_t) u64;
pub extern fn skb_layout_create(params: [*c]const skb_layout_params_t) ?*skb_layout_t;
pub extern fn skb_layout_create_utf8(temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: [*c]const u8, text_count: i32, attributes: skb_attribute_set_t) ?*skb_layout_t;
pub extern fn skb_layout_create_utf32(temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: [*c]const u32, text_count: i32, attributes: skb_attribute_set_t) ?*skb_layout_t;
pub extern fn skb_layout_create_from_runs(temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, runs: [*c]const skb_content_run_t, runs_count: i32) ?*skb_layout_t;
pub extern fn skb_layout_create_from_text(temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: ?*const skb_text_t, attributes: skb_attribute_set_t) ?*skb_layout_t;
pub extern fn skb_layout_set_utf8(layout: ?*skb_layout_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: [*c]const u8, text_count: i32, attributes: skb_attribute_set_t) void;
pub extern fn skb_layout_set_utf32(layout: ?*skb_layout_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: [*c]const u32, text_count: i32, attributes: skb_attribute_set_t) void;
pub extern fn skb_layout_set_from_runs(layout: ?*skb_layout_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, runs: [*c]const skb_content_run_t, runs_count: i32) void;
pub extern fn skb_layout_set_from_text(layout: ?*skb_layout_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: ?*const skb_text_t, attributes: skb_attribute_set_t) void;
pub extern fn skb_layout_reset(layout: ?*skb_layout_t) void;
pub extern fn skb_layout_destroy(layout: ?*skb_layout_t) void;
pub extern fn skb_layout_get_params(layout: ?*const skb_layout_t) [*c]const skb_layout_params_t;
pub extern fn skb_layout_get_text_count(layout: ?*const skb_layout_t) i32;
pub extern fn skb_layout_get_text(layout: ?*const skb_layout_t) [*c]const u32;
pub extern fn skb_layout_get_text_properties(layout: ?*const skb_layout_t) [*c]const skb_text_property_t;
pub extern fn skb_layout_get_layout_runs_count(layout: ?*const skb_layout_t) i32;
pub extern fn skb_layout_get_layout_runs(layout: ?*const skb_layout_t) [*c]const skb_layout_run_t;
pub extern fn skb_layout_get_glyphs_count(layout: ?*const skb_layout_t) i32;
pub extern fn skb_layout_get_glyphs(layout: ?*const skb_layout_t) [*c]const skb_glyph_t;
pub extern fn skb_layout_get_clusters_count(layout: ?*const skb_layout_t) i32;
pub extern fn skb_layout_get_clusters(layout: ?*const skb_layout_t) [*c]const skb_cluster_t;
pub extern fn skb_layout_get_decorations_count(layout: ?*const skb_layout_t) i32;
pub extern fn skb_layout_get_decorations(layout: ?*const skb_layout_t) [*c]const skb_decoration_t;
pub extern fn skb_layout_get_lines_count(layout: ?*const skb_layout_t) i32;
pub extern fn skb_layout_get_lines(layout: ?*const skb_layout_t) [*c]const skb_layout_line_t;
pub extern fn skb_layout_get_bounds(layout: ?*const skb_layout_t) skb_rect2_t;
pub extern fn skb_layout_get_resolved_direction(layout: ?*const skb_layout_t) skb_text_direction_t;
pub extern fn skb_layout_next_grapheme_offset(layout: ?*const skb_layout_t, offset: i32) i32;
pub extern fn skb_layout_prev_grapheme_offset(layout: ?*const skb_layout_t, offset: i32) i32;
pub extern fn skb_layout_align_grapheme_offset(layout: ?*const skb_layout_t, offset: i32) i32;
pub const struct_skb_visual_caret_t = extern struct {
    x: f32 = 0,
    y: f32 = 0,
    ascender: f32 = 0,
    descender: f32 = 0,
    slope: f32 = 0,
    direction: u8 = 0,
};
pub const skb_visual_caret_t = struct_skb_visual_caret_t;
pub extern fn skb_layout_get_line_index(layout: ?*const skb_layout_t, pos: skb_text_position_t) i32;
pub extern fn skb_layout_get_text_offset(layout: ?*const skb_layout_t, pos: skb_text_position_t) i32;
pub extern fn skb_layout_get_text_direction_at(layout: ?*const skb_layout_t, pos: skb_text_position_t) skb_text_direction_t;
pub const SKB_MOVEMENT_CARET: c_int = 0;
pub const SKB_MOVEMENT_SELECTION: c_int = 1;
pub const skb_movement_type_t = c_uint;
pub extern fn skb_layout_hit_test_at_line(layout: ?*const skb_layout_t, @"type": skb_movement_type_t, line_idx: i32, hit_x: f32) skb_text_position_t;
pub extern fn skb_layout_hit_test(layout: ?*const skb_layout_t, @"type": skb_movement_type_t, hit_x: f32, hit_y: f32) skb_text_position_t;
pub const struct_skb_layout_content_hit_t = extern struct {
    run_id: isize = 0,
    line_idx: i32 = 0,
    layout_run_idx: i32 = 0,
};
pub const skb_layout_content_hit_t = struct_skb_layout_content_hit_t;
pub extern fn skb_layout_hit_test_content_at_line(layout: ?*const skb_layout_t, line_idx: i32, hit_x: f32) skb_layout_content_hit_t;
pub extern fn skb_layout_hit_test_content(layout: ?*const skb_layout_t, hit_x: f32, hit_y: f32) skb_layout_content_hit_t;
pub const skb_content_rect_func_t = fn (rect: skb_rect2_t, layout_run_idx: i32, line_idx: i32, context: ?*anyopaque) callconv(.c) void;
pub extern fn skb_layout_get_content_bounds_at_line(layout: ?*const skb_layout_t, line_idx: i32, run_id: isize, callback: ?*const skb_content_rect_func_t, context: ?*anyopaque) void;
pub extern fn skb_layout_get_content_bounds(layout: ?*const skb_layout_t, run_id: isize, callback: ?*const skb_content_rect_func_t, context: ?*anyopaque) void;
pub extern fn skb_layout_get_visual_caret_at_line(layout: ?*const skb_layout_t, line_idx: i32, pos: skb_text_position_t) skb_visual_caret_t;
pub extern fn skb_layout_get_visual_caret_at(layout: ?*const skb_layout_t, pos: skb_text_position_t) skb_visual_caret_t;
pub extern fn skb_layout_get_line_start_at(layout: ?*const skb_layout_t, pos: skb_text_position_t) skb_text_position_t;
pub extern fn skb_layout_get_line_end_at(layout: ?*const skb_layout_t, pos: skb_text_position_t) skb_text_position_t;
pub extern fn skb_layout_get_word_start_at(layout: ?*const skb_layout_t, pos: skb_text_position_t) skb_text_position_t;
pub extern fn skb_layout_get_word_end_at(layout: ?*const skb_layout_t, pos: skb_text_position_t) skb_text_position_t;
pub extern fn skb_layout_get_selection_ordered_start(layout: ?*const skb_layout_t, selection: skb_text_selection_t) skb_text_position_t;
pub extern fn skb_layout_get_selection_ordered_end(layout: ?*const skb_layout_t, selection: skb_text_selection_t) skb_text_position_t;
pub extern fn skb_layout_get_selection_text_offset_range(layout: ?*const skb_layout_t, selection: skb_text_selection_t) skb_range_t;
pub extern fn skb_layout_get_selection_count(layout: ?*const skb_layout_t, selection: skb_text_selection_t) i32;
pub const skb_selection_rect_func_t = fn (rect: skb_rect2_t, context: ?*anyopaque) callconv(.c) void;
pub extern fn skb_layout_get_selection_bounds(layout: ?*const skb_layout_t, selection: skb_text_selection_t, callback: ?*const skb_selection_rect_func_t, context: ?*anyopaque) void;
pub extern fn skb_layout_get_selection_bounds_with_offset(layout: ?*const skb_layout_t, offset_y: f32, selection: skb_text_selection_t, callback: ?*const skb_selection_rect_func_t, context: ?*anyopaque) void;
pub const struct_skb_caret_iterator_result_t = extern struct {
    text_position: skb_text_position_t = @import("std").mem.zeroes(skb_text_position_t),
    layout_run_idx: i32 = 0,
    glyph_idx: i32 = 0,
    cluster_idx: i32 = 0,
    direction: u8 = 0,
};
pub const skb_caret_iterator_result_t = struct_skb_caret_iterator_result_t;
pub const struct_skb_caret_iterator_t = extern struct {
    layout: ?*const skb_layout_t = null,
    advance: f32 = 0,
    x: f32 = 0,
    layout_run_idx: i32 = 0,
    layout_run_end: i32 = 0,
    cluster_idx: i32 = 0,
    cluster_end: i32 = 0,
    glyph_idx: i32 = 0,
    grapheme_pos: i32 = 0,
    grapheme_end: i32 = 0,
    end_of_runs: bool = false,
    end_of_line: bool = false,
    line_first_grapheme_offset: i32 = 0,
    line_last_grapheme_offset: i32 = 0,
    pending_left: skb_caret_iterator_result_t = @import("std").mem.zeroes(skb_caret_iterator_result_t),
    pub const next = skb_caret_iterator_next;
};
pub const skb_caret_iterator_t = struct_skb_caret_iterator_t;
pub extern fn skb_caret_iterator_make(layout: ?*const skb_layout_t, line_idx: i32) skb_caret_iterator_t;
pub extern fn skb_caret_iterator_next(iter: [*c]skb_caret_iterator_t, x: [*c]f32, advance: [*c]f32, left: [*c]skb_caret_iterator_result_t, right: [*c]skb_caret_iterator_result_t) bool;
pub extern fn skb_script_to_iso15924_tag(script: u8) u32;
pub extern fn skb_script_from_iso15924_tag(script_tag: u32) u8;
pub const struct_skb_rich_text_t = opaque {
    pub const destroy = skb_rich_text_destroy;
    pub const reset = skb_rich_text_reset;
    pub const count = skb_rich_text_get_utf32_count;
    pub const count1 = skb_rich_text_get_range_utf8_count;
    pub const utf8 = skb_rich_text_get_range_utf8;
    pub const count2 = skb_rich_text_get_range_utf32_count;
    pub const utf32 = skb_rich_text_get_range_utf32;
    pub const count3 = skb_rich_text_get_paragraphs_count;
    pub const text = skb_rich_text_get_paragraph_text;
    pub const attributes = skb_rich_text_get_paragraph_attributes;
    pub const count4 = skb_rich_text_get_paragraph_text_utf32_count;
    pub const offset = skb_rich_text_get_paragraph_text_offset;
    pub const version = skb_rich_text_get_paragraph_version;
    pub const append = skb_rich_text_append;
    pub const range = skb_rich_text_append_range;
    pub const paragraph = skb_rich_text_add_paragraph;
    pub const text1 = skb_rich_text_append_text;
    pub const range1 = skb_rich_text_append_text_range;
    pub const utf81 = skb_rich_text_append_utf8;
    pub const utf321 = skb_rich_text_append_utf32;
    pub const replace = skb_rich_text_replace;
    pub const range2 = skb_rich_text_replace_range;
    pub const attribute = skb_rich_text_set_attribute;
    pub const attribute1 = skb_rich_text_clear_attribute;
    pub const attributes1 = skb_rich_text_clear_all_attributes;
    pub const count5 = skb_rich_text_get_attribute_count;
    pub const @"if" = skb_rich_text_remove_if;
};
pub const skb_rich_text_t = struct_skb_rich_text_t;
pub const struct_skb_rich_text_change_t = extern struct {
    start_paragraph_idx: i32 = 0,
    removed_paragraph_count: i32 = 0,
    inserted_paragraph_count: i32 = 0,
    edit_end_position: skb_text_position_t = @import("std").mem.zeroes(skb_text_position_t),
};
pub const skb_rich_text_change_t = struct_skb_rich_text_change_t;
pub extern fn skb_rich_text_create() ?*skb_rich_text_t;
pub extern fn skb_rich_text_destroy(rich_text: ?*skb_rich_text_t) void;
pub extern fn skb_rich_text_reset(rich_text: ?*skb_rich_text_t) void;
pub extern fn skb_rich_text_get_utf32_count(rich_text: ?*const skb_rich_text_t) i32;
pub extern fn skb_rich_text_get_range_utf8_count(rich_text: ?*const skb_rich_text_t, text_range: skb_range_t) i32;
pub extern fn skb_rich_text_get_range_utf8(rich_text: ?*const skb_rich_text_t, text_range: skb_range_t, utf8: [*c]u8, utf8_cap: i32) i32;
pub extern fn skb_rich_text_get_range_utf32_count(rich_text: ?*const skb_rich_text_t, text_range: skb_range_t) i32;
pub extern fn skb_rich_text_get_range_utf32(rich_text: ?*const skb_rich_text_t, text_range: skb_range_t, utf32: [*c]u32, utf32_cap: i32) i32;
pub extern fn skb_rich_text_get_paragraphs_count(text: ?*const skb_rich_text_t) i32;
pub extern fn skb_rich_text_get_paragraph_text(text: ?*const skb_rich_text_t, index: i32) ?*const skb_text_t;
pub extern fn skb_rich_text_get_paragraph_attributes(text: ?*const skb_rich_text_t, index: i32) skb_attribute_set_t;
pub extern fn skb_rich_text_get_paragraph_text_utf32_count(text: ?*const skb_rich_text_t, index: i32) i32;
pub extern fn skb_rich_text_get_paragraph_text_offset(text: ?*const skb_rich_text_t, index: i32) i32;
pub extern fn skb_rich_text_get_paragraph_version(text: ?*const skb_rich_text_t, index: i32) u32;
pub extern fn skb_rich_text_append(rich_text: ?*skb_rich_text_t, source_rich_text: ?*const skb_rich_text_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_append_range(rich_text: ?*skb_rich_text_t, source_rich_text: ?*const skb_rich_text_t, source_text_range: skb_range_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_add_paragraph(rich_text: ?*skb_rich_text_t, paragraph_attributes: skb_attribute_set_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_append_text(rich_text: ?*skb_rich_text_t, temp_alloc: ?*skb_temp_alloc_t, from_tex: ?*const skb_text_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_append_text_range(rich_text: ?*skb_rich_text_t, temp_alloc: ?*skb_temp_alloc_t, from_text: ?*const skb_text_t, from_range: skb_range_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_append_utf8(rich_text: ?*skb_rich_text_t, temp_alloc: ?*skb_temp_alloc_t, utf8: [*c]const u8, utf8_count: i32, attributes: skb_attribute_set_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_append_utf32(rich_text: ?*skb_rich_text_t, temp_alloc: ?*skb_temp_alloc_t, utf32: [*c]const u32, utf32_count: i32, attributes: skb_attribute_set_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_replace(rich_text: ?*skb_rich_text_t, text_range: skb_range_t, source_rich_text: ?*const skb_rich_text_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_replace_range(rich_text: ?*skb_rich_text_t, text_range: skb_range_t, source_rich_text: ?*const skb_rich_text_t, source_text_range: skb_range_t) skb_rich_text_change_t;
pub extern fn skb_rich_text_set_attribute(rich_text: ?*skb_rich_text_t, text_range: skb_range_t, attribute: skb_attribute_t) void;
pub extern fn skb_rich_text_clear_attribute(rich_text: ?*skb_rich_text_t, text_range: skb_range_t, attribute: skb_attribute_t) void;
pub extern fn skb_rich_text_clear_all_attributes(rich_text: ?*skb_rich_text_t, text_range: skb_range_t) void;
pub extern fn skb_rich_text_get_attribute_count(rich_text: ?*const skb_rich_text_t, text_range: skb_range_t, attribute_kind: u32) i32;
pub const skb_rich_text_remove_func_t = fn (codepoint: u32, paragraph_idx: i32, text_offset: i32, context: ?*anyopaque) callconv(.c) bool;
pub extern fn skb_rich_text_remove_if(rich_text: ?*skb_rich_text_t, filter_func: ?*const skb_rich_text_remove_func_t, context: ?*anyopaque) void;
pub const struct_skb_editor_t = opaque {
    pub const callback = skb_editor_set_on_change_callback;
    pub const callback1 = skb_editor_set_input_filter_callback;
    pub const destroy = skb_editor_destroy;
    pub const reset = skb_editor_reset;
    pub const utf8 = skb_editor_set_text_utf8;
    pub const utf32 = skb_editor_set_text_utf32;
    pub const text = skb_editor_set_text;
    pub const count = skb_editor_get_text_utf8_count;
    pub const utf81 = skb_editor_get_text_utf8;
    pub const count1 = skb_editor_get_text_utf32_count;
    pub const utf321 = skb_editor_get_text_utf32;
    pub const text1 = skb_editor_get_text;
    pub const count2 = skb_editor_get_paragraph_count;
    pub const layout = skb_editor_get_paragraph_layout;
    pub const y = skb_editor_get_paragraph_offset_y;
    pub const text2 = skb_editor_get_paragraph_text;
    pub const offset = skb_editor_get_paragraph_text_offset;
    pub const params = skb_editor_get_params;
    pub const at = skb_editor_get_line_index_at;
    pub const at1 = skb_editor_get_column_index_at;
    pub const at2 = skb_editor_get_text_offset_at;
    pub const at3 = skb_editor_get_text_direction_at;
    pub const caret = skb_editor_get_visual_caret;
    pub const @"test" = skb_editor_hit_test;
    pub const all = skb_editor_select_all;
    pub const none = skb_editor_select_none;
    pub const select = skb_editor_select;
    pub const selection = skb_editor_get_current_selection;
    pub const range = skb_editor_get_selection_text_offset_range;
    pub const count3 = skb_editor_get_selection_count;
    pub const bounds = skb_editor_get_selection_bounds;
    pub const count4 = skb_editor_get_selection_text_utf8_count;
    pub const utf82 = skb_editor_get_selection_text_utf8;
    pub const count5 = skb_editor_get_selection_text_utf32_count;
    pub const utf322 = skb_editor_get_selection_text_utf32;
    pub const text3 = skb_editor_get_selection_rich_text;
    pub const click = skb_editor_process_mouse_click;
    pub const drag = skb_editor_process_mouse_drag;
    pub const pressed = skb_editor_process_key_pressed;
    pub const codepoint = skb_editor_insert_codepoint;
    pub const utf83 = skb_editor_paste_utf8;
    pub const utf323 = skb_editor_paste_utf32;
    pub const text4 = skb_editor_paste_text;
    pub const text5 = skb_editor_paste_rich_text;
    pub const cut = skb_editor_cut;
    pub const attribute = skb_editor_toggle_attribute;
    pub const attribute1 = skb_editor_apply_attribute;
    pub const attribute2 = skb_editor_set_attribute;
    pub const attribute3 = skb_editor_clear_attribute;
    pub const attributes = skb_editor_clear_all_attributes;
    pub const count6 = skb_editor_get_attribute_count;
    pub const count7 = skb_editor_get_active_attributes_count;
    pub const attributes1 = skb_editor_get_active_attributes;
    pub const undo = skb_editor_can_undo;
    pub const undo1 = skb_editor_undo;
    pub const redo = skb_editor_can_redo;
    pub const redo1 = skb_editor_redo;
    pub const utf324 = skb_editor_set_composition_utf32;
    pub const utf325 = skb_editor_commit_composition_utf32;
    pub const composition = skb_editor_clear_composition;
};
pub const skb_editor_t = struct_skb_editor_t;
pub const skb_editor_on_change_func_t = fn (editor: ?*skb_editor_t, context: ?*anyopaque) callconv(.c) void;
pub const skb_editor_input_filter_func_t = fn (editor: ?*skb_editor_t, input_text: ?*skb_rich_text_t, selection: skb_text_selection_t, context: ?*anyopaque) callconv(.c) void;
pub const SKB_CARET_MODE_SKRIBIDI: c_int = 0;
pub const SKB_CARET_MODE_SIMPLE: c_int = 1;
pub const skb_editor_caret_mode_t = c_uint;
pub const SKB_BEHAVIOR_DEFAULT: c_int = 0;
pub const SKB_BEHAVIOR_MACOS: c_int = 1;
pub const skb_editor_behavior_t = c_uint;
pub const struct_skb_editor_params_t = extern struct {
    font_collection: ?*skb_font_collection_t = null,
    icon_collection: ?*skb_icon_collection_t = null,
    attribute_collection: ?*skb_attribute_collection_t = null,
    editor_width: f32 = 0,
    layout_attributes: skb_attribute_set_t = @import("std").mem.zeroes(skb_attribute_set_t),
    text_attributes: skb_attribute_set_t = @import("std").mem.zeroes(skb_attribute_set_t),
    composition_attributes: skb_attribute_set_t = @import("std").mem.zeroes(skb_attribute_set_t),
    caret_mode: skb_editor_caret_mode_t = @import("std").mem.zeroes(skb_editor_caret_mode_t),
    editor_behavior: skb_editor_behavior_t = @import("std").mem.zeroes(skb_editor_behavior_t),
    max_undo_levels: i32 = 0,
    pub const create = skb_editor_create;
};
pub const skb_editor_params_t = struct_skb_editor_params_t;
pub const SKB_KEY_NONE: c_int = 0;
pub const SKB_KEY_LEFT: c_int = 1;
pub const SKB_KEY_RIGHT: c_int = 2;
pub const SKB_KEY_UP: c_int = 3;
pub const SKB_KEY_DOWN: c_int = 4;
pub const SKB_KEY_HOME: c_int = 5;
pub const SKB_KEY_END: c_int = 6;
pub const SKB_KEY_BACKSPACE: c_int = 7;
pub const SKB_KEY_DELETE: c_int = 8;
pub const SKB_KEY_ENTER: c_int = 9;
pub const skb_editor_key_t = c_uint;
pub const SKB_MOD_NONE: c_int = 0;
pub const SKB_MOD_SHIFT: c_int = 1;
pub const SKB_MOD_CONTROL: c_int = 2;
pub const SKB_MOD_OPTION: c_int = 4;
pub const SKB_MOD_COMMAND: c_int = 8;
pub const skb_editor_key_mod_t = c_uint;
pub extern fn skb_editor_create(params: [*c]const skb_editor_params_t) ?*skb_editor_t;
pub extern fn skb_editor_set_on_change_callback(editor: ?*skb_editor_t, on_change_func: ?*const skb_editor_on_change_func_t, context: ?*anyopaque) void;
pub extern fn skb_editor_set_input_filter_callback(editor: ?*skb_editor_t, filter_func: ?*const skb_editor_input_filter_func_t, context: ?*anyopaque) void;
pub extern fn skb_editor_destroy(editor: ?*skb_editor_t) void;
pub extern fn skb_editor_reset(editor: ?*skb_editor_t, params: [*c]const skb_editor_params_t) void;
pub extern fn skb_editor_set_text_utf8(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, utf8: [*c]const u8, utf8_len: i32) void;
pub extern fn skb_editor_set_text_utf32(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, utf32: [*c]const u32, utf32_len: i32) void;
pub extern fn skb_editor_set_text(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, text: ?*skb_text_t) void;
pub extern fn skb_editor_get_text_utf8_count(editor: ?*const skb_editor_t) i32;
pub extern fn skb_editor_get_text_utf8(editor: ?*const skb_editor_t, utf8: [*c]u8, utf8_cap: i32) i32;
pub extern fn skb_editor_get_text_utf32_count(editor: ?*const skb_editor_t) i32;
pub extern fn skb_editor_get_text_utf32(editor: ?*const skb_editor_t, utf32: [*c]u32, utf32_cap: i32) i32;
pub extern fn skb_editor_get_text(editor: ?*const skb_editor_t, text: ?*skb_text_t) void;
pub extern fn skb_editor_get_paragraph_count(editor: ?*skb_editor_t) i32;
pub extern fn skb_editor_get_paragraph_layout(editor: ?*skb_editor_t, index: i32) ?*const skb_layout_t;
pub extern fn skb_editor_get_paragraph_offset_y(editor: ?*skb_editor_t, index: i32) f32;
pub extern fn skb_editor_get_paragraph_text(editor: ?*skb_editor_t, index: i32) ?*const skb_text_t;
pub extern fn skb_editor_get_paragraph_text_offset(editor: ?*skb_editor_t, index: i32) i32;
pub extern fn skb_editor_get_params(editor: ?*skb_editor_t) [*c]const skb_editor_params_t;
pub extern fn skb_editor_get_line_index_at(editor: ?*const skb_editor_t, pos: skb_text_position_t) i32;
pub extern fn skb_editor_get_column_index_at(editor: ?*const skb_editor_t, pos: skb_text_position_t) i32;
pub extern fn skb_editor_get_text_offset_at(editor: ?*const skb_editor_t, pos: skb_text_position_t) i32;
pub extern fn skb_editor_get_text_direction_at(editor: ?*const skb_editor_t, pos: skb_text_position_t) skb_text_direction_t;
pub extern fn skb_editor_get_visual_caret(editor: ?*const skb_editor_t, pos: skb_text_position_t) skb_visual_caret_t;
pub extern fn skb_editor_hit_test(editor: ?*const skb_editor_t, @"type": skb_movement_type_t, hit_x: f32, hit_y: f32) skb_text_position_t;
pub extern fn skb_editor_select_all(editor: ?*skb_editor_t) void;
pub extern fn skb_editor_select_none(editor: ?*skb_editor_t) void;
pub extern fn skb_editor_select(editor: ?*skb_editor_t, selection: skb_text_selection_t) void;
pub extern fn skb_editor_get_current_selection(editor: ?*skb_editor_t) skb_text_selection_t;
pub extern fn skb_editor_get_selection_text_offset_range(editor: ?*const skb_editor_t, selection: skb_text_selection_t) skb_range_t;
pub extern fn skb_editor_get_selection_count(editor: ?*const skb_editor_t, selection: skb_text_selection_t) i32;
pub extern fn skb_editor_get_selection_bounds(editor: ?*const skb_editor_t, selection: skb_text_selection_t, callback: ?*const skb_selection_rect_func_t, context: ?*anyopaque) void;
pub extern fn skb_editor_get_selection_text_utf8_count(editor: ?*const skb_editor_t, selection: skb_text_selection_t) i32;
pub extern fn skb_editor_get_selection_text_utf8(editor: ?*const skb_editor_t, selection: skb_text_selection_t, utf8: [*c]u8, utf8_cap: i32) i32;
pub extern fn skb_editor_get_selection_text_utf32_count(editor: ?*const skb_editor_t, selection: skb_text_selection_t) i32;
pub extern fn skb_editor_get_selection_text_utf32(editor: ?*const skb_editor_t, selection: skb_text_selection_t, utf32: [*c]u32, utf32_cap: i32) i32;
pub extern fn skb_editor_get_selection_rich_text(editor: ?*const skb_editor_t, selection: skb_text_selection_t, rich_text: ?*skb_rich_text_t) void;
pub extern fn skb_editor_process_mouse_click(editor: ?*skb_editor_t, x: f32, y: f32, mods: u32, time: f64) void;
pub extern fn skb_editor_process_mouse_drag(editor: ?*skb_editor_t, x: f32, y: f32) void;
pub extern fn skb_editor_process_key_pressed(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, key: skb_editor_key_t, mods: u32) void;
pub extern fn skb_editor_insert_codepoint(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, codepoint: u32) void;
pub extern fn skb_editor_paste_utf8(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, utf8: [*c]const u8, utf8_len: i32) void;
pub extern fn skb_editor_paste_utf32(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, utf32: [*c]const u32, utf32_len: i32) void;
pub extern fn skb_editor_paste_text(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, text: ?*const skb_text_t) void;
pub extern fn skb_editor_paste_rich_text(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, rich_text: ?*const skb_rich_text_t) void;
pub extern fn skb_editor_cut(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t) void;
pub extern fn skb_editor_toggle_attribute(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, attribute: skb_attribute_t) void;
pub extern fn skb_editor_apply_attribute(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, attribute: skb_attribute_t) void;
pub extern fn skb_editor_set_attribute(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, selection: skb_text_selection_t, attribute: skb_attribute_t) void;
pub extern fn skb_editor_clear_attribute(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, selection: skb_text_selection_t, attribute: skb_attribute_t) void;
pub extern fn skb_editor_clear_all_attributes(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, selection: skb_text_selection_t) void;
pub extern fn skb_editor_get_attribute_count(editor: ?*const skb_editor_t, selection: skb_text_selection_t, attribute_kind: u32) i32;
pub extern fn skb_editor_get_active_attributes_count(editor: ?*const skb_editor_t) i32;
pub extern fn skb_editor_get_active_attributes(editor: ?*const skb_editor_t) [*c]const skb_attribute_t;
pub extern fn skb_editor_can_undo(editor: ?*skb_editor_t) bool;
pub extern fn skb_editor_undo(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t) void;
pub extern fn skb_editor_can_redo(editor: ?*skb_editor_t) bool;
pub extern fn skb_editor_redo(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t) void;
pub extern fn skb_editor_set_composition_utf32(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, utf32: [*c]const u32, utf32_len: i32, caret_position: i32) void;
pub extern fn skb_editor_commit_composition_utf32(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t, utf32: [*c]const u32, utf32_len: i32) void;
pub extern fn skb_editor_clear_composition(editor: ?*skb_editor_t, temp_alloc: ?*skb_temp_alloc_t) void;
pub const struct_skb_rasterizer_t = opaque {
    pub const config = skb_rasterizer_get_config;
    pub const destroy = skb_rasterizer_destroy;
    pub const glyph = skb_rasterizer_draw_alpha_glyph;
    pub const glyph1 = skb_rasterizer_draw_color_glyph;
    pub const icon = skb_rasterizer_draw_alpha_icon;
    pub const icon1 = skb_rasterizer_draw_color_icon;
    pub const pattern = skb_rasterizer_draw_decoration_pattern;
};
pub const skb_rasterizer_t = struct_skb_rasterizer_t;
pub const struct_skb_rasterizer_config_t = extern struct {
    on_edge_value: u8 = 0,
    pixel_dist_scale: f32 = 0,
    pub const create = skb_rasterizer_create;
};
pub const skb_rasterizer_config_t = struct_skb_rasterizer_config_t;
pub const SKB_RASTERIZE_ALPHA_MASK: c_int = 0;
pub const SKB_RASTERIZE_ALPHA_SDF: c_int = 1;
pub const skb_rasterize_alpha_mode_t = c_uint;
pub extern fn skb_rasterizer_create(config: [*c]skb_rasterizer_config_t) ?*skb_rasterizer_t;
pub extern fn skb_rasterizer_get_default_config() skb_rasterizer_config_t;
pub extern fn skb_rasterizer_get_config(rasterizer: ?*const skb_rasterizer_t) skb_rasterizer_config_t;
pub extern fn skb_rasterizer_destroy(rasterizer: ?*skb_rasterizer_t) void;
pub extern fn skb_rasterizer_get_glyph_dimensions(glyph_id: u32, font: ?*const skb_font_t, font_size: f32, padding: i32) skb_rect2i_t;
pub extern fn skb_rasterizer_draw_alpha_glyph(rasterizer: ?*skb_rasterizer_t, temp_alloc: ?*skb_temp_alloc_t, glyph_id: u32, font: ?*const skb_font_t, font_size: f32, alpha_mode: skb_rasterize_alpha_mode_t, offset_x: f32, offset_y: f32, target: [*c]skb_image_t) bool;
pub extern fn skb_rasterizer_draw_color_glyph(rasterizer: ?*skb_rasterizer_t, temp_alloc: ?*skb_temp_alloc_t, glyph_id: u32, font: ?*const skb_font_t, font_size: f32, alpha_mode: skb_rasterize_alpha_mode_t, offset_x: i32, offset_y: i32, target: [*c]skb_image_t) bool;
pub extern fn skb_rasterizer_get_icon_dimensions(icon: ?*const skb_icon_t, icon_scale: skb_vec2_t, padding: i32) skb_rect2i_t;
pub extern fn skb_rasterizer_draw_alpha_icon(rasterizer: ?*skb_rasterizer_t, temp_alloc: ?*skb_temp_alloc_t, icon: ?*const skb_icon_t, icon_scale: skb_vec2_t, alpha_mode: skb_rasterize_alpha_mode_t, offset_x: i32, offset_y: i32, target: [*c]skb_image_t) bool;
pub extern fn skb_rasterizer_draw_color_icon(rasterizer: ?*skb_rasterizer_t, temp_alloc: ?*skb_temp_alloc_t, icon: ?*const skb_icon_t, icon_scale: skb_vec2_t, alpha_mode: skb_rasterize_alpha_mode_t, offset_x: i32, offset_y: i32, target: [*c]skb_image_t) bool;
pub extern fn skb_rasterizer_get_decoration_pattern_size(style: skb_decoration_style_t, thickness: f32) skb_vec2_t;
pub extern fn skb_rasterizer_get_decoration_pattern_dimensions(style: skb_decoration_style_t, thickness: f32, padding: i32) skb_rect2i_t;
pub extern fn skb_rasterizer_draw_decoration_pattern(rasterizer: ?*skb_rasterizer_t, temp_alloc: ?*skb_temp_alloc_t, style: skb_decoration_style_t, thickness: f32, alpha_mode: skb_rasterize_alpha_mode_t, offset_x: i32, offset_y: i32, target: [*c]skb_image_t) bool;
pub const struct_skb_image_atlas_t = opaque {
    pub const destroy = skb_image_atlas_destroy;
    pub const config = skb_image_atlas_get_config;
    pub const callback = skb_image_atlas_set_create_texture_callback;
    pub const count = skb_image_atlas_get_texture_count;
    pub const texture = skb_image_atlas_get_texture;
    pub const bounds = skb_image_atlas_get_texture_dirty_bounds;
    pub const bounds1 = skb_image_atlas_get_and_reset_texture_dirty_bounds;
    pub const data = skb_image_atlas_set_texture_user_data;
    pub const data1 = skb_image_atlas_get_texture_user_data;
    pub const rects = skb_image_atlas_debug_iterate_free_rects;
    pub const rects1 = skb_image_atlas_debug_iterate_used_rects;
    pub const bounds2 = skb_image_atlas_debug_get_texture_prev_dirty_bounds;
    pub const quad = skb_image_atlas_get_glyph_quad;
    pub const quad1 = skb_image_atlas_get_icon_quad;
    pub const quad2 = skb_image_atlas_get_decoration_quad;
    pub const compact = skb_image_atlas_compact;
    pub const items = skb_image_atlas_rasterize_missing_items;
};
pub const skb_image_atlas_t = struct_skb_image_atlas_t;
pub const SKB_QUAD_IS_COLOR: c_int = 1;
pub const SKB_QUAD_IS_SDF: c_int = 2;
pub const enum_skb_quad_flags_t = c_uint;
pub const struct_skb_quad_t = extern struct {
    geom: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    pattern: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    texture: skb_rect2_t = @import("std").mem.zeroes(skb_rect2_t),
    scale: f32 = 0,
    color: skb_color_t = @import("std").mem.zeroes(skb_color_t),
    texture_idx: u8 = 0,
    flags: u8 = 0,
};
pub const skb_quad_t = struct_skb_quad_t;
pub const skb_create_texture_func_t = fn (atlas: ?*skb_image_atlas_t, texture_idx: u8, context: ?*anyopaque) callconv(.c) void;
pub const struct_skb_image_item_config_t = extern struct {
    rounding: f32 = 0,
    min_size: f32 = 0,
    max_size: f32 = 0,
    padding: i32 = 0,
};
pub const skb_image_item_config_t = struct_skb_image_item_config_t;
pub const SKB_IMAGE_ATLAS_DEBUG_CLEAR_REMOVED: c_int = 1;
pub const enum_skb_image_atlas_config_flags_t = c_uint;
pub const struct_skb_image_atlas_config_t = extern struct {
    init_width: i32 = 0,
    init_height: i32 = 0,
    expand_size: i32 = 0,
    max_width: i32 = 0,
    max_height: i32 = 0,
    item_height_rounding: i32 = 0,
    fit_max_factor: f32 = 0,
    evict_inactive_duration: i32 = 0,
    flags: u8 = 0,
    glyph_sdf: skb_image_item_config_t = @import("std").mem.zeroes(skb_image_item_config_t),
    glyph_alpha: skb_image_item_config_t = @import("std").mem.zeroes(skb_image_item_config_t),
    icon_sdf: skb_image_item_config_t = @import("std").mem.zeroes(skb_image_item_config_t),
    icon_alpha: skb_image_item_config_t = @import("std").mem.zeroes(skb_image_item_config_t),
    pattern_sdf: skb_image_item_config_t = @import("std").mem.zeroes(skb_image_item_config_t),
    pattern_alpha: skb_image_item_config_t = @import("std").mem.zeroes(skb_image_item_config_t),
    pub const create = skb_image_atlas_create;
};
pub const skb_image_atlas_config_t = struct_skb_image_atlas_config_t;
pub extern fn skb_image_atlas_create(config: [*c]const skb_image_atlas_config_t) ?*skb_image_atlas_t;
pub extern fn skb_image_atlas_destroy(atlas: ?*skb_image_atlas_t) void;
pub extern fn skb_image_atlas_get_default_config() skb_image_atlas_config_t;
pub extern fn skb_image_atlas_get_config(atlas: ?*skb_image_atlas_t) skb_image_atlas_config_t;
pub extern fn skb_image_atlas_set_create_texture_callback(atlas: ?*skb_image_atlas_t, create_texture_callback: ?*const skb_create_texture_func_t, context: ?*anyopaque) void;
pub extern fn skb_image_atlas_get_texture_count(atlas: ?*skb_image_atlas_t) i32;
pub extern fn skb_image_atlas_get_texture(atlas: ?*skb_image_atlas_t, texture_idx: i32) [*c]const skb_image_t;
pub extern fn skb_image_atlas_get_texture_dirty_bounds(atlas: ?*skb_image_atlas_t, texture_idx: i32) skb_rect2i_t;
pub extern fn skb_image_atlas_get_and_reset_texture_dirty_bounds(atlas: ?*skb_image_atlas_t, texture_idx: i32) skb_rect2i_t;
pub extern fn skb_image_atlas_set_texture_user_data(atlas: ?*skb_image_atlas_t, texture_idx: i32, user_data: usize) void;
pub extern fn skb_image_atlas_get_texture_user_data(image_atlas: ?*skb_image_atlas_t, texture_idx: i32) usize;
pub const skb_debug_rect_iterator_func_t = fn (x: i32, y: i32, width: i32, height: i32, context: ?*anyopaque) callconv(.c) void;
pub extern fn skb_image_atlas_debug_iterate_free_rects(atlas: ?*skb_image_atlas_t, texture_idx: i32, callback: ?*const skb_debug_rect_iterator_func_t, context: ?*anyopaque) void;
pub extern fn skb_image_atlas_debug_iterate_used_rects(atlas: ?*skb_image_atlas_t, texture_idx: i32, callback: ?*const skb_debug_rect_iterator_func_t, context: ?*anyopaque) void;
pub extern fn skb_image_atlas_debug_get_texture_prev_dirty_bounds(atlas: ?*skb_image_atlas_t, texture_idx: i32) skb_rect2i_t;
pub extern fn skb_image_atlas_get_glyph_quad(atlas: ?*skb_image_atlas_t, x: f32, y: f32, pixel_scale: f32, font_collection: ?*skb_font_collection_t, font_handle: skb_font_handle_t, glyph_id: u32, font_size: f32, tint_color: skb_color_t, alpha_mode: skb_rasterize_alpha_mode_t) skb_quad_t;
pub extern fn skb_image_atlas_get_icon_quad(atlas: ?*skb_image_atlas_t, x: f32, y: f32, pixel_scale: f32, icon_collection: ?*const skb_icon_collection_t, icon_handle: skb_icon_handle_t, width: f32, height: f32, tint_color: skb_color_t, alpha_mode: skb_rasterize_alpha_mode_t) skb_quad_t;
pub extern fn skb_image_atlas_get_decoration_quad(atlas: ?*skb_image_atlas_t, x: f32, y: f32, pixel_scale: f32, position: skb_decoration_position_t, style: skb_decoration_style_t, length: f32, pattern_offset: f32, thickness: f32, tint_color: skb_color_t, alpha_mode: skb_rasterize_alpha_mode_t) skb_quad_t;
pub extern fn skb_image_atlas_compact(atlas: ?*skb_image_atlas_t) bool;
pub extern fn skb_image_atlas_rasterize_missing_items(atlas: ?*skb_image_atlas_t, temp_alloc: ?*skb_temp_alloc_t, rasterizer: ?*skb_rasterizer_t) bool;
pub const struct_skb_layout_cache_t = opaque {
    pub const destroy = skb_layout_cache_destroy;
    pub const utf8 = skb_layout_cache_get_utf8;
    pub const utf32 = skb_layout_cache_get_utf32;
    pub const runs = skb_layout_cache_get_from_runs;
    pub const compact = skb_layout_cache_compact;
};
pub const skb_layout_cache_t = struct_skb_layout_cache_t;
pub extern fn skb_layout_cache_create() ?*skb_layout_cache_t;
pub extern fn skb_layout_cache_destroy(cache: ?*skb_layout_cache_t) void;
pub extern fn skb_layout_cache_get_utf8(cache: ?*skb_layout_cache_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: [*c]const u8, text_count: i32, attributes: skb_attribute_set_t) ?*const skb_layout_t;
pub extern fn skb_layout_cache_get_utf32(cache: ?*skb_layout_cache_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: [*c]const u32, text_count: i32, attributes: skb_attribute_set_t) ?*const skb_layout_t;
pub extern fn skb_layout_cache_get_from_runs(cache: ?*skb_layout_cache_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, runs: [*c]const skb_content_run_t, runs_count: i32) ?*const skb_layout_t;
pub extern fn skb_layout_cache_compact(cache: ?*skb_layout_cache_t) bool;
pub const struct_skb_rich_layout_t = opaque {
    pub const destroy = skb_rich_layout_destroy;
    pub const reset = skb_rich_layout_reset;
    pub const count = skb_rich_layout_get_paragraphs_count;
    pub const layout = skb_rich_layout_get_layout;
    pub const y = skb_rich_layout_get_offset_y;
    pub const direction = skb_rich_layout_get_direction;
    pub const update = skb_rich_layout_update;
    pub const change = skb_rich_layout_update_with_change;
    pub const position = skb_rich_layout_get_paragraph_position;
    pub const offset = skb_rich_layout_text_position_to_offset;
    pub const range = skb_rich_layout_text_selection_to_range;
    pub const caret = skb_rich_layout_get_visual_caret;
    pub const bounds = skb_rich_layout_get_selection_bounds;
    pub const @"test" = skb_rich_layout_hit_test;
};
pub const skb_rich_layout_t = struct_skb_rich_layout_t;
pub extern fn skb_rich_layout_create() ?*skb_rich_layout_t;
pub extern fn skb_rich_layout_destroy(layout: ?*skb_rich_layout_t) void;
pub extern fn skb_rich_layout_reset(layout: ?*skb_rich_layout_t) void;
pub extern fn skb_rich_layout_get_paragraphs_count(layout: ?*const skb_rich_layout_t) i32;
pub extern fn skb_rich_layout_get_layout(layout: ?*const skb_rich_layout_t, index: i32) ?*const skb_layout_t;
pub extern fn skb_rich_layout_get_offset_y(layout: ?*const skb_rich_layout_t, index: i32) f32;
pub extern fn skb_rich_layout_get_direction(layout: ?*const skb_rich_layout_t, index: i32) skb_text_direction_t;
pub extern fn skb_rich_layout_update(rich_layout: ?*skb_rich_layout_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, rich_text: ?*const skb_rich_text_t, ime_text_offset: i32, ime_text: ?*skb_text_t) void;
pub extern fn skb_rich_layout_update_with_change(rich_layout: ?*skb_rich_layout_t, temp_alloc: ?*skb_temp_alloc_t, params: [*c]const skb_layout_params_t, text: ?*const skb_rich_text_t, change: skb_rich_text_change_t, ime_text_offset: i32, ime_text: ?*skb_text_t) void;
pub const SKB_AFFINITY_USE: c_int = 0;
pub const SKB_AFFINITY_IGNORE: c_int = 1;
pub const skb_affinity_usage_t = c_uint;
pub extern fn skb_rich_layout_get_paragraph_position(rich_layout: ?*const skb_rich_layout_t, text_pos: skb_text_position_t, affinity_usage: skb_affinity_usage_t) skb_paragraph_position_t;
pub extern fn skb_rich_layout_text_position_to_offset(rich_layout: ?*const skb_rich_layout_t, text_pos: skb_text_position_t) i32;
pub extern fn skb_rich_layout_text_selection_to_range(rich_layout: ?*const skb_rich_layout_t, selection: skb_text_selection_t) skb_range_t;
pub extern fn skb_rich_layout_get_visual_caret(rich_layout: ?*const skb_rich_layout_t, pos: skb_text_position_t) skb_visual_caret_t;
pub extern fn skb_rich_layout_get_selection_bounds(rich_layout: ?*const skb_rich_layout_t, selection: skb_text_selection_t, callback: ?*const skb_selection_rect_func_t, context: ?*anyopaque) void;
pub extern fn skb_rich_layout_hit_test(rich_layout: ?*const skb_rich_layout_t, @"type": skb_movement_type_t, hit_x: f32, hit_y: f32) skb_text_position_t;

pub const hb_language_impl_t = struct_hb_language_impl_t;
pub const skb_layout_params_flags_t = enum_skb_layout_params_flags_t;
pub const skb_text_prop_flags_t = enum_skb_text_prop_flags_t;
pub const skb_quad_flags_t = enum_skb_quad_flags_t;
pub const skb_image_atlas_config_flags_t = enum_skb_image_atlas_config_flags_t;
