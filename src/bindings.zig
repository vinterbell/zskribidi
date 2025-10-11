const std = @import("std");
const raw = @import("raw");

pub const Align = enum(c_uint) {
    start = raw.SKB_ALIGN_START,
    center = raw.SKB_ALIGN_CENTER,
    end = raw.SKB_ALIGN_END,
    left = raw.SKB_ALIGN_LEFT,
    right = raw.SKB_ALIGN_RIGHT,
    top = raw.SKB_ALIGN_TOP,
    bottom = raw.SKB_ALIGN_BOTTOM,
};

pub const TextWrap = enum(c_uint) {
    none = raw.SKB_WRAP_NONE,
    word = raw.SKB_WRAP_WORD,
    word_char = raw.SKB_WRAP_WORD_CHAR,
};

pub const TextOverflow = enum(c_uint) {
    none = raw.SKB_OVERFLOW_NONE,
    clip = raw.SKB_OVERFLOW_CLIP,
    ellipsis = raw.SKB_OVERFLOW_ELLIPSIS,
};

pub const VerticalTrim = enum(c_uint) {
    default = raw.SKB_VERTICAL_TRIM_DEFAULT,
    cap_to_baseline = raw.SKB_VERTICAL_TRIM_CAP_TO_BASELINE,
};

pub const LineHeight = enum(c_uint) {
    normal = raw.SKB_LINE_HEIGHT_NORMAL,
    metrics_relative = raw.SKB_LINE_HEIGHT_METRICS_RELATIVE,
    font_size_relative = raw.SKB_LINE_HEIGHT_FONT_SIZE_RELATIVE,
    absolute = raw.SKB_LINE_HEIGHT_ABSOLUTE,
};

pub const ObjectAlignReference = enum(c_uint) {
    self_ = raw.SKB_OBJECT_ALIGN_SELF,
    text_before = raw.SKB_OBJECT_ALIGN_TEXT_BEFORE,
    text_before_or_after = raw.SKB_OBJECT_ALIGN_TEXT_BEFORE_OR_AFTER,
    text_after = raw.SKB_OBJECT_ALIGN_TEXT_AFTER,
    text_after_or_before = raw.SKB_OBJECT_ALIGN_TEXT_AFTER_OR_BEFORE,
};

pub const DecorationStyle = enum(c_uint) {
    solid = raw.SKB_DECORATION_STYLE_SOLID,
    double_ = raw.SKB_DECORATION_STYLE_DOUBLE,
    dotted = raw.SKB_DECORATION_STYLE_DOTTED,
    dashed = raw.SKB_DECORATION_STYLE_DASHED,
    wavy = raw.SKB_DECORATION_STYLE_WAVY,
};

pub const DecorationPosition = enum(c_uint) {
    underline = raw.SKB_DECORATION_UNDERLINE,
    bottomline = raw.SKB_DECORATION_BOTTOMLINE,
    overline = raw.SKB_DECORATION_OVERLINE,
    throughline = raw.SKB_DECORATION_THROUGHLINE,
};

pub const CaretAffinity = enum(c_uint) {
    none = raw.SKB_AFFINITY_NONE,
    trailing = raw.SKB_AFFINITY_TRAILING,
    leading = raw.SKB_AFFINITY_LEADING,
    sol = raw.SKB_AFFINITY_SOL,
    eol = raw.SKB_AFFINITY_EOL,
};

pub const TextPosition = extern struct {
    offset: i32,
    affinity: CaretAffinity,

    pub const zero: TextPosition = .{ .offset = 0, .affinity = .none };

    pub fn toSkb(self: TextPosition) raw.skb_text_position_t {
        return .{
            .offset = self.offset,
            .affinity = @as(c_uint, self.affinity),
        };
    }

    pub fn fromSkb(skb_pos: raw.skb_text_position_t) TextPosition {
        return .{
            .offset = skb_pos.offset,
            .affinity = @enumFromInt(skb_pos.affinity),
        };
    }
};

pub const TextSelection = extern struct {
    start_pos: TextPosition,
    end_pos: TextPosition,

    pub const empty: TextSelection = .{
        .start_pos = .zero,
        .end_pos = .zero,
    };

    pub fn toSkb(self: TextSelection) raw.skb_text_selection_t {
        return .{
            .start = self.start_pos.toSkb(),
            .end = self.end_pos.toSkb(),
        };
    }

    pub fn fromSkb(skb_sel: raw.skb_text_selection_t) TextSelection {
        return .{
            .start_pos = .fromSkb(skb_sel.start),
            .end_pos = .fromSkb(skb_sel.end),
        };
    }
};

pub const ParagraphPosition = extern struct {
    paragraph_idx: i32,
    text_offset: i32,
    global_text_offset: i32,

    pub const zero: ParagraphPosition = .{
        .paragraph_idx = 0,
        .text_offset = 0,
        .global_text_offset = 0,
    };

    pub fn toSkb(self: ParagraphPosition) raw.skb_paragraph_position_t {
        return .{
            .paragraph_idx = self.paragraph_idx,
            .text_offset = self.text_offset,
            .global_text_offset = self.global_text_offset,
        };
    }

    pub fn fromSkb(skb_pos: raw.skb_paragraph_position_t) ParagraphPosition {
        return .{
            .paragraph_idx = skb_pos.paragraph_idx,
            .text_offset = skb_pos.text_offset,
            .global_text_offset = skb_pos.global_text_offset,
        };
    }
};

pub const ParagraphRange = extern struct {
    start_pos: ParagraphPosition,
    end_pos: ParagraphPosition,

    pub const zero: ParagraphRange = .{
        .start_pos = .zero,
        .end_pos = .zero,
    };

    pub fn toSkb(self: ParagraphRange) raw.skb_paragraph_range_t {
        return .{
            .start_pos = self.start_pos.toSkb(),
            .end_pos = self.end_pos.toSkb(),
        };
    }

    pub fn fromSkb(skb_range: raw.skb_paragraph_range_t) ParagraphRange {
        return .{
            .start_pos = .fromSkb(skb_range.start_pos),
            .end_pos = .fromSkb(skb_range.end_pos),
        };
    }
};

pub const Range = extern struct {
    start: i32,
    end: i32,

    pub const zero: Range = .{ .start = 0, .end = 0 };

    pub fn init(start: i32, end: i32) Range {
        return .{ .start = start, .end = end };
    }

    pub fn initLength(start: i32, length: i32) Range {
        return .{ .start = start, .end = start + length };
    }

    pub fn overlap(self: Range, other: Range) bool {
        return @max(self.start, other.start) < @min(self.end, other.end);
    }

    pub fn contains(self: Range, idx: i32) bool {
        return (idx >= self.start) and (idx < self.end);
    }

    pub fn empty(self: Range) bool {
        return self.start >= self.end;
    }

    // TODO: skb_emoji_run_iterator_make

    pub fn toSkb(self: Range) raw.skb_range_t {
        return .{
            .start = self.start,
            .end = self.end,
        };
    }

    pub fn fromSkb(skb_range: raw.skb_range_t) Range {
        return .{
            .start = skb_range.start,
            .end = skb_range.end,
        };
    }
};

pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub fn rgba(r: u8, g: u8, b: u8, a: u8) Color {
        return .{ .r = r, .g = g, .b = b, .a = a };
    }

    pub fn equals(self: Color, other: Color) bool {
        return self.toSkb().equals(other.toSkb());
    }

    pub fn mulAlpha(self: Color, alpha: u8) Color {
        const self_skb = self.toSkb();
        const res_skb = raw.skb_color_mul_alpha(self_skb, alpha);
        return .fromSkb(res_skb);
    }

    pub fn add(self: Color, other: Color) Color {
        const self_skb = self.toSkb();
        const other_skb = other.toSkb();
        const res_skb = raw.skb_color_add(self_skb, other_skb);
        return .fromSkb(res_skb);
    }

    pub fn average(self: Color, other: Color) Color {
        const self_skb = self.toSkb();
        const other_skb = other.toSkb();
        const res_skb = raw.skb_color_average(self_skb, other_skb);
        return .fromSkb(res_skb);
    }

    pub fn lerp(self: Color, other: Color, t: u8) Color {
        const self_skb = self.toSkb();
        const other_skb = other.toSkb();
        const res_skb = raw.skb_color_lerp(self_skb, other_skb, t);
        return .fromSkb(res_skb);
    }

    pub fn lerpf(self: Color, other: Color, t: f32) Color {
        const self_skb = self.toSkb();
        const other_skb = other.toSkb();
        const res_skb = raw.skb_color_lerpf(self_skb, other_skb, t);
        return .fromSkb(res_skb);
    }

    pub fn blend(self: Color, other: Color) Color {
        const self_skb = self.toSkb();
        const other_skb = other.toSkb();
        const res_skb = raw.skb_color_blend(other_skb, self_skb);
        return .fromSkb(res_skb);
    }

    pub fn premult(self: Color) Color {
        const self_skb = self.toSkb();
        const res_skb = raw.skb_color_premult(self_skb);
        return .fromSkb(res_skb);
    }

    pub fn fromSkb(skb_color: raw.skb_color_t) Color {
        return .{
            .r = skb_color.r,
            .g = skb_color.g,
            .b = skb_color.b,
            .a = skb_color.a,
        };
    }

    pub fn toSkb(self: Color) raw.skb_color_t {
        return raw.skb_rgba(self.r, self.g, self.b, self.a);
    }

    // TODO: make fill
};

pub const Image = extern struct {
    buffer: ?[*]u8 = null,
    width: i32,
    height: i32,
    stride_bytes: i32 = 0,
    bpp: u8,

    pub const empty: Image = .{
        .buffer = null,
        .width = 0,
        .height = 0,
        .stride_bytes = 0,
        .bpp = 0,
    };
};

pub const Vec2 = extern struct {
    x: f32,
    y: f32,

    pub const zero: Vec2 = .{ .x = 0, .y = 0 };

    pub fn add(self: Vec2, other: Vec2) Vec2 {
        return .{ .x = self.x + other.x, .y = self.y + other.y };
    }

    pub fn sub(self: Vec2, other: Vec2) Vec2 {
        return .{ .x = self.x - other.x, .y = self.y - other.y };
    }

    pub fn scale(self: Vec2, s: f32) Vec2 {
        return .{ .x = self.x * s, .y = self.y * s };
    }

    pub fn multiplyAdd(self: Vec2, b: Vec2, s: f32) Vec2 {
        return .{ .x = self.x + (b.x * s), .y = self.y + (b.y * s) };
    }

    pub fn lerp(self: Vec2, b: Vec2, t: f32) Vec2 {
        return .{ .x = self.x + ((b.x - self.x) * t), .y = self.y + ((b.y - self.y) * t) };
    }

    pub fn dot(self: Vec2, other: Vec2) f32 {
        return (self.x * other.x) + (self.y * other.y);
    }

    pub fn norm(self: Vec2) Vec2 {
        var a = self;
        const d: f32 = (a.x * a.x) + (a.y * a.y);
        if (d > 0.0) {
            const inv_d: f32 = @as(f32, 1) / @sqrt(d);
            a.x *= inv_d;
            a.y *= inv_d;
        }
        return a;
    }

    pub fn length(self: Vec2) f32 {
        return @sqrt((self.x * self.x) + (self.y * self.y));
    }

    pub fn distSqr(self: Vec2, other: Vec2) f32 {
        const dx: f32 = other.x - self.x;
        const dy: f32 = other.y - self.y;
        return (dx * dx) + (dy * dy);
    }

    pub fn dist(self: Vec2, other: Vec2) f32 {
        return @sqrt(self.distSqr(other));
    }

    pub fn equals(self: Vec2, other: Vec2, tol: f32) bool {
        const dx: f32 = other.x - self.x;
        const dy: f32 = other.y - self.y;
        return ((dx * dx) + (dy * dy)) < (tol * tol);
    }

    pub fn fromSkb(skb_vec: raw.skb_vec2_t) Vec2 {
        return .{ .x = skb_vec.x, .y = skb_vec.y };
    }

    pub fn toSkb(self: Vec2) raw.skb_vec2_t {
        return .{ .x = self.x, .y = self.y };
    }
};

pub const Mat2 = extern struct {
    xx: f32 = 0,
    yx: f32 = 0,
    xy: f32 = 0,
    yy: f32 = 0,
    dx: f32 = 0,
    dy: f32 = 0,

    pub const identity: Mat2 = .{
        .xx = 1,
        .yx = 0,
        .xy = 0,
        .yy = 1,
        .dx = 0,
        .dy = 0,
    };

    pub fn translation(tx: f32, ty: f32) Mat2 {
        return .{
            .xx = 1,
            .yx = 0,
            .xy = 0,
            .yy = 1,
            .dx = tx,
            .dy = ty,
        };
    }

    pub fn scale(sx: f32, sy: f32) Mat2 {
        return .{
            .xx = sx,
            .yx = 0,
            .xy = 0,
            .yy = sy,
            .dx = 0,
            .dy = 0,
        };
    }

    pub fn rotation(angle_radians: f32) Mat2 {
        const cs: f32 = @cos(angle_radians);
        const sn: f32 = @sin(angle_radians);
        return .{
            .xx = cs,
            .yx = sn,
            .xy = -sn,
            .yy = cs,
            .dx = 0,
            .dy = 0,
        };
    }

    pub fn multiply(self: Mat2, other: Mat2) Mat2 {
        return .fromSkb(raw.skb_mat2_multiply(self.toSkb(), other.toSkb()));
    }

    pub fn point(self: Mat2, pt: Vec2) Vec2 {
        return .fromSkb(raw.skb_mat2_point(self.toSkb(), pt.toSkb()));
    }

    pub fn inverse(self: Mat2) ?Mat2 {
        const inv = raw.skb_mat2_inverse(self.toSkb());
        return .fromSkb(inv);
    }

    pub fn fromSkb(skb_mat: raw.skb_mat2_t) Mat2 {
        return .{
            .xx = skb_mat.xx,
            .yx = skb_mat.yx,
            .xy = skb_mat.xy,
            .yy = skb_mat.yy,
            .dx = skb_mat.dx,
            .dy = skb_mat.dy,
        };
    }

    pub fn toSkb(self: Mat2) raw.skb_mat2_t {
        return .{
            .xx = self.xx,
            .yx = self.yx,
            .xy = self.xy,
            .yy = self.yy,
            .dx = self.dx,
            .dy = self.dy,
        };
    }
};

pub const Rect2 = extern struct {
    x: f32,
    y: f32,
    width: f32,
    height: f32,

    pub const undef: Rect2 = .{
        .x = @as(f32, 340282346638528860000000000000000000000) / @as(f32, 2),
        .y = @as(f32, 340282346638528860000000000000000000000) / @as(f32, 2),
        .width = -@as(f32, 340282346638528860000000000000000000000),
        .height = -@as(f32, 340282346638528860000000000000000000000),
    };

    pub const zero: Rect2 = .{ .x = 0, .y = 0, .width = 0, .height = 0 };

    pub fn init(x: f32, y: f32, width: f32, height: f32) Rect2 {
        return .{ .x = x, .y = y, .width = width, .height = height };
    }

    pub fn unionPoint(self: Rect2, pt: Vec2) Rect2 {
        return .fromSkb(raw.skb_rect2_union_point(self.toSkb(), pt.toSkb()));
    }

    pub fn @"union"(self: Rect2, other: Rect2) Rect2 {
        return .fromSkb(raw.skb_rect2_union(self.toSkb(), other.toSkb()));
    }

    pub fn intersection(self: Rect2, other: Rect2) Rect2 {
        return .fromSkb(raw.skb_rect2_intersection(self.toSkb(), other.toSkb()));
    }

    pub fn translate(self: Rect2, d: Vec2) Rect2 {
        return .fromSkb(raw.skb_rect2_translate(self.toSkb(), d.toSkb()));
    }

    pub fn isEmpty(self: Rect2) bool {
        return raw.skb_rect2_is_empty(self.toSkb());
    }

    pub fn pointInside(self: Rect2, pt: Vec2) bool {
        return raw.skb_rect2_pt_inside(self.toSkb(), pt.toSkb());
    }

    pub fn overlap(self: Rect2, other: Rect2) bool {
        return raw.arb_rect2_overlap(self.toSkb(), other.toSkb());
    }

    pub fn fromSkb(skb_rect: raw.skb_rect2_t) Rect2 {
        return .{
            .x = skb_rect.x,
            .y = skb_rect.y,
            .width = skb_rect.width,
            .height = skb_rect.height,
        };
    }

    pub fn toSkb(self: Rect2) raw.skb_rect2_t {
        return .{
            .x = self.x,
            .y = self.y,
            .width = self.width,
            .height = self.height,
        };
    }
};

pub const Rect2i = extern struct {
    x: i32,
    y: i32,
    width: i32,
    height: i32,

    pub const undef: Rect2i = .{
        .x = @divTrunc(@as(c_int, 2147483647), @as(c_int, 2)),
        .y = @divTrunc(@as(c_int, 2147483647), @as(c_int, 2)),
        .width = -@as(c_int, 2147483647) - @as(c_int, 1),
        .height = -@as(c_int, 2147483647) - @as(c_int, 1),
    };

    pub const zero: Rect2i = .{ .x = 0, .y = 0, .width = 0, .height = 0 };

    pub fn init(x: i32, y: i32, width: i32, height: i32) Rect2i {
        return .{ .x = x, .y = y, .width = width, .height = height };
    }

    pub fn unionPoint(self: Rect2i, px: i32, py: i32) Rect2i {
        return .fromSkb(
            raw.skb_rect2i_union_point(self.toSkb(), px, py),
        );
    }

    pub fn @"union"(self: Rect2i, other: Rect2i) Rect2i {
        return .fromSkb(raw.skb_rect2i_union(self.toSkb(), other.toSkb()));
    }

    pub fn intersection(self: Rect2i, other: Rect2i) Rect2i {
        return .fromSkb(raw.skb_rect2i_intersection(self.toSkb(), other.toSkb()));
    }

    pub fn fromSkb(skb_rect: raw.skb_rect2i_t) Rect2i {
        return .{
            .x = skb_rect.x,
            .y = skb_rect.y,
            .width = skb_rect.width,
            .height = skb_rect.height,
        };
    }

    pub fn isEmpty(self: Rect2i) bool {
        return raw.skb_rect2i_is_empty(self.toSkb());
    }

    pub fn toSkb(self: Rect2i) raw.skb_rect2i_t {
        return .{
            .x = self.x,
            .y = self.y,
            .width = self.width,
            .height = self.height,
        };
    }
};

pub const TempAlloc = opaque {
    pub const default_block_size = raw.SKB_TEMPALLOC_DEFAULT_BLOCK_SIZE;
    pub const alignment = raw.SKB_TEMPALLOC_ALIGN;

    pub const Stats = struct {
        allocated: usize,
        used: usize,
    };

    pub const Mark = struct {
        block_num: i32,
        offset: i32,
    };

    pub fn create(block_size: usize) std.mem.Allocator.Error!*TempAlloc {
        return @ptrCast(raw.skb_temp_alloc_create(@intCast(block_size)) orelse return error.OutOfMemory);
    }

    pub fn destroy(allocator: *TempAlloc) void {
        raw.skb_temp_alloc_destroy(@ptrCast(allocator));
    }

    pub fn stats(allocator: *TempAlloc) Stats {
        const skb_stats = raw.skb_temp_alloc_stats(@ptrCast(allocator));
        return .{
            .allocated = @intCast(skb_stats.allocated),
            .used = @intCast(skb_stats.used),
        };
    }

    pub fn reset(allocator: *TempAlloc) void {
        raw.skb_temp_alloc_reset(@ptrCast(allocator));
    }

    pub fn save(allocator: *TempAlloc) TempAlloc.Mark {
        const res = raw.skb_temp_alloc_save(@ptrCast(allocator));
        return .{
            .block_num = res.block_num,
            .offset = res.offset,
        };
    }

    pub fn restore(allocator: *TempAlloc, mark: TempAlloc.Mark) void {
        raw.skb_temp_alloc_restore(@ptrCast(allocator), .{
            .block_num = mark.block_num,
            .offset = mark.offset,
        });
    }

    pub fn alloc(allocator: *TempAlloc, size: usize) std.mem.Allocator.Error![]const u8 {
        const ptr = raw.skb_temp_alloc_alloc(
            @ptrCast(allocator),
            @intCast(size),
        ) orelse
            return error.OutOfMemory;
        const ptr_u8: [*]u8 = @ptrCast(ptr);
        return ptr_u8[0..size];
    }

    pub fn realloc(
        allocator: *TempAlloc,
        old_ptr: []const u8,
        new_size: usize,
    ) std.mem.Allocator.Error![]const u8 {
        const ptr = raw.skb_temp_alloc_realloc(
            @ptrCast(allocator),
            @ptrCast(old_ptr.ptr),
            @intCast(new_size),
        ) orelse
            return error.OutOfMemory;
        const ptr_u8: [*]u8 = @ptrCast(ptr);
        return ptr_u8[0..new_size];
    }

    pub fn free(allocator: *TempAlloc, ptr: []const u8) void {
        raw.skb_temp_alloc_free(@ptrCast(allocator), @ptrCast(ptr.ptr));
    }
};

pub const HashTable = opaque {
    pub fn create() std.mem.Allocator.Error!*HashTable {
        return @ptrCast(raw.skb_hash_table_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(ht: *HashTable) void {
        raw.skb_hash_table_destroy(@ptrCast(ht));
    }

    pub fn add(ht: *HashTable, hash: u64, value: i32) bool {
        return raw.skb_hash_table_add(@ptrCast(ht), hash, value);
    }

    pub fn find(ht: *HashTable, hash: u64, value: [*]i32) bool {
        return raw.skb_hash_table_find(@ptrCast(ht), hash, @ptrCast(value));
    }

    pub fn remove(ht: *HashTable, hash: u64) bool {
        return raw.skb_hash_table_remove(@ptrCast(ht), hash);
    }
};

pub const ListItem = extern struct {
    prev: i32,
    next: i32,

    pub const init: ListItem = .{ .prev = raw.SKB_INVALID_INDEX, .next = raw.SKB_INVALID_INDEX };
};

pub const List = extern struct {
    head: i32,
    tail: i32,

    pub const init: List = .{ .head = raw.SKB_INVALID_INDEX, .tail = raw.SKB_INVALID_INDEX };

    pub fn remove(self: *List, item_idx: i32, get_item: *const raw.skb_list_get_item_func_t, context: ?*anyopaque) void {
        raw.skb_list_remove(@ptrCast(self), item_idx, get_item, context);
    }

    pub fn moveToFront(self: *List, item_idx: i32, get_item: *const raw.skb_list_get_item_func_t, context: ?*anyopaque) void {
        raw.skb_list_move_to_front(@ptrCast(self), item_idx, get_item, context);
    }
};

pub const TextDirection = enum(c_uint) {
    auto = raw.SKB_DIRECTION_AUTO,
    ltr = raw.SKB_DIRECTION_LTR,
    rtl = raw.SKB_DIRECTION_RTL,
};

pub const Character = enum(c_uint) {
    combining_enclosing_circle_backslash = raw.SKB_CHAR_COMBINING_ENCLOSING_CIRCLE_BACKSLASH,
    combining_enclosing_keycap = raw.SKB_CHAR_COMBINING_ENCLOSING_KEYCAP,
    variation_selector15 = raw.SKB_char_VARIATION_SELECTOR15,
    variation_selector16 = raw.SKB_CHAR_VARIATION_SELECTOR16,
    zero_width_joiner = raw.SKB_CHAR_ZERO_WIDTH_JOINER,
    regional_indicator_base = raw.SKB_CHAR_REGIONAL_INDICATOR_BASE,
    cancel_tag = raw.SKB_CHAR_CANCEL_TAG,
    horizontal_tab = raw.SKB_CHAR_HORIZONTAL_TAB,
    line_feed = raw.SKB_CHAR_LINE_FEED,
    vertical_tab = raw.SKB_CHAR_VERTICAL_TAB,
    form_feed = raw.SKB_CHAR_FORM_FEED,
    carriage_return = raw.SKB_CHAR_CARRIAGE_RETURN,
    next_line = raw.SKB_CHAR_NEXT_LINE,
    line_separator = raw.SKB_CHAR_LINE_SEPARATOR,
    paragraph_separator = raw.SKB_CHAR_PARAGRAPH_SEPARATOR,
    replacement_object = raw.SKB_CHAR_REPLACEMENT_OBJECT,
    _,

    pub fn fromInt(self: u32) Character {
        return @enumFromInt(self);
    }

    pub fn toInt(self: Character) u32 {
        return @intFromEnum(self);
    }

    pub fn isEmojiModifierBase(self: Character) bool {
        return raw.skb_is_emoji_modifier_base(self.toInt());
    }

    pub fn isEmojiPresentation(self: Character) bool {
        return raw.skb_is_emoji_presentation(self.toInt());
    }

    pub fn isEmoji(self: Character) bool {
        return raw.skb_is_emoji(self.toInt());
    }

    pub fn isEmojiModifier(self: Character) bool {
        return raw.skb_is_emoji_modifier(self.toInt());
    }

    pub fn isRegionalIndicatorSymbol(self: Character) bool {
        return raw.skb_is_regional_indicator_symbol(self.toInt());
    }

    pub fn isVariationSelector(self: Character) bool {
        return raw.skb_is_variation_selector(self.toInt());
    }

    pub fn isKeycapBase(self: Character) bool {
        return raw.skb_is_keycap_base(self.toInt());
    }

    pub fn isTagSpecChar(self: Character) bool {
        return raw.skb_is_tag_spec_char(self.toInt());
    }

    pub fn isParagraphSeparator(self: Character) bool {
        return raw.skb_is_paragraph_separator(self.toInt());
    }
};

pub const EmojiRunIterator = extern struct {
    emoji_category: [*:0]u8 = null,
    count: i32 = 0,
    pos: i32 = 0,
    start: i32 = 0,
    offset: i32 = 0,
    has_emoji: bool = false,

    pub fn init(range: Range, text: [:0]const u32, emoji_category_buffer: [:0]u8) EmojiRunIterator {
        return raw.skb_emoji_run_iterator_make(
            range.toSkb(),
            @ptrCast(text.ptr),
            @ptrCast(emoji_category_buffer),
        );
    }

    pub fn next(self: *EmojiRunIterator, range: *Range, range_has_emojis: *bool) bool {
        var r = range.toSkb();
        var has_emojis: c_int = 0;
        const res = raw.skb_emoji_run_iterator_next(
            @ptrCast(self),
            &r,
            &has_emojis,
        );
        range.* = .{ .start = r.start, .end = r.end };
        range_has_emojis.* = has_emojis != 0;
        return res;
    }
};

pub fn utf8ToUtf32(utf8: []const u8, utf32: []u32) usize {
    return @intCast(raw.skb_utf8_to_utf32(
        @ptrCast(utf8.ptr),
        @intCast(utf8.len),
        @ptrCast(utf32.ptr),
        @intCast(utf32.len),
    ));
}

pub fn utf8ToUtf32Count(utf8: []const u8) usize {
    return @intCast(raw.skb_utf8_to_utf32_count(
        @ptrCast(utf8.ptr),
        @intCast(utf8.len),
    ));
}

pub fn utf8CodepointOffset(utf8: []const u8, codepoint_offset: i32) i32 {
    return raw.skb_utf8_codepoint_offset(
        @ptrCast(utf8.ptr),
        @intCast(utf8.len),
        codepoint_offset,
    );
}

pub fn utf8NumUnits(utf8: []const u8) i32 {
    return raw.skb_utf8_num_units(
        @ptrCast(utf8.ptr),
        @intCast(utf8.len),
    );
}

pub fn utf8Encode(cp: u32, utf8: []u8) i32 {
    return raw.skb_utf8_encode(
        cp,
        @ptrCast(utf8.ptr),
        @intCast(utf8.len),
    );
}

pub fn utf32ToUtf8(utf32: []const u32, utf8: []u8) usize {
    return @intCast(raw.skb_utf32_to_utf8(
        @ptrCast(utf32.ptr),
        @intCast(utf32.len),
        @ptrCast(utf8.ptr),
        @intCast(utf8.len),
    ));
}

pub fn utf32ToUtf8Count(utf32: []const u32) i32 {
    return raw.skb_utf32_to_utf8_count(
        @ptrCast(utf32.ptr),
        @intCast(utf32.len),
    );
}

pub fn utf32Strlen(utf32: []const u32) i32 {
    return raw.skb_utf32_strlen(@ptrCast(utf32.ptr));
}

pub fn utf32Copy(src: []const u32, dst: []u32) i32 {
    return raw.skb_utf32_copy(
        @ptrCast(src.ptr),
        @intCast(src.len),
        @ptrCast(dst.ptr),
        @intCast(dst.len),
    );
}

pub const HbFont = opaque {};

pub const Style = enum(c_uint) {
    normal = raw.SKB_STYLE_NORMAL,
    italic = raw.SKB_STYLE_ITALIC,
    oblique = raw.SKB_STYLE_OBLIQUE,
};

pub const FontFamily = enum(u8) {
    default = raw.SKB_FONT_FAMILY_DEFAULT,
    emoji = raw.SKB_FONT_FAMILY_EMOJI,
    sans_serif = raw.SKB_FONT_FAMILY_SANS_SERIF,
    serif = raw.SKB_FONT_FAMILY_SERIF,
    monospace = raw.SKB_FONT_FAMILY_MONOSPACE,
    math = raw.SKB_FONT_FAMILY_MATH,
};

pub const Stretch = enum(c_uint) {
    normal = raw.SKB_STRETCH_NORMAL,
    ultra_condensed = raw.SKB_STRETCH_ULTRA_CONDENSED,
    extra_condensed = raw.SKB_STRETCH_EXTRA_CONDENSED,
    condensed = raw.SKB_STRETCH_CONDENSED,
    semi_condensed = raw.SKB_STRETCH_SEMI_CONDENSED,
    semi_expanded = raw.SKB_STRETCH_SEMI_EXPANDED,
    expanded = raw.SKB_STRETCH_EXPANDED,
    extra_expanded = raw.SKB_STRETCH_EXTRA_EXPANDED,
    ultra_expanded = raw.SKB_STRETCH_ULTRA_EXPANDED,
};

pub const Weight = enum(c_uint) {
    normal = raw.SKB_WEIGHT_NORMAL,
    thin = raw.SKB_WEIGHT_THIN,
    extralight = raw.SKB_WEIGHT_EXTRALIGHT,
    ultralight = raw.SKB_WEIGHT_ULTRALIGHT,
    light = raw.SKB_WEIGHT_LIGHT,
    regular = raw.SKB_WEIGHT_REGULAR,
    medium = raw.SKB_WEIGHT_MEDIUM,
    demibold = raw.SKB_WEIGHT_DEMIBOLD,
    semibold = raw.SKB_WEIGHT_SEMIBOLD,
    bold = raw.SKB_WEIGHT_BOLD,
    extrabold = raw.SKB_WEIGHT_EXTRABOLD,
    ultrabold = raw.SKB_WEIGHT_ULTRABOLD,
    black = raw.SKB_WEIGHT_BLACK,
    heavy = raw.SKB_WEIGHT_HEAVY,
    extrablack = raw.SKB_WEIGHT_EXTRABLACK,
    ultrablack = raw.SKB_WEIGHT_ULTRABLACK,
};

pub const Baseline = enum(c_uint) {
    alphabetic = raw.SKB_BASELINE_ALPHABETIC,
    ideographic = raw.SKB_BASELINE_IDEOGRAPHIC,
    central = raw.SKB_BASELINE_CENTRAL,
    hanging = raw.SKB_BASELINE_HANGING,
    mathematical = raw.SKB_BASELINE_MATHEMATICAL,
    middle = raw.SKB_BASELINE_MIDDLE,
    text_top = raw.SKB_BASELINE_TEXT_TOP,
    text_bottom = raw.SKB_BASELINE_TEXT_BOTTOM,
};

pub const FontMetrics = extern struct {
    ascender: f32,
    descender: f32,
    line_gap: f32,
    cap_height: f32,
    x_height: f32,
    underline_offset: f32,
    underline_size: f32,
    strikeout_offset: f32,
    strikeout_size: f32,

    pub const init: FontMetrics = .{
        .ascender = 0,
        .descender = 0,
        .line_gap = 0,
        .cap_height = 0,
        .x_height = 0,
        .underline_offset = 0,
        .underline_size = 0,
        .strikeout_offset = 0,
        .strikeout_size = 0,
    };

    pub fn fromSkb(skb_metrics: raw.skb_font_metrics_t) FontMetrics {
        return .{
            .ascender = skb_metrics.ascender,
            .descender = skb_metrics.descender,
            .line_gap = skb_metrics.line_gap,
            .cap_height = skb_metrics.cap_height,
            .x_height = skb_metrics.x_height,
            .underline_offset = skb_metrics.underline_offset,
            .underline_size = skb_metrics.underline_size,
            .strikeout_offset = skb_metrics.strikeout_offset,
            .strikeout_size = skb_metrics.strikeout_size,
        };
    }
};

pub const BaselineSet = extern struct {
    pub const NamedBaselines = extern struct {
        alphabetic: f32,
        ideographic: f32,
        central: f32,
        hanging: f32,
        mathematical: f32,
        middle: f32,
        text_bottom: f32,
        text_top: f32,
    };

    pub const Baselines = extern union {
        array: [8]f32,
        named: NamedBaselines,
    };

    baselines: Baselines,
    script: Script,
    direction: u8,

    pub const init: BaselineSet = .{
        .baselines = .{ .array = @splat(0) },
        .script = .none,
        .direction = 0,
    };

    pub fn fromSkb(skb_baseline_set: raw.skb_baseline_set_t) BaselineSet {
        return .{
            .baselines = switch (skb_baseline_set.unnamed_0) {
                .baselines => .{ .array = skb_baseline_set.unnamed_0.baselines },
                .unnamed_0 => |n| .{ .named = .{
                    .alphabetic = n.alphabetic,
                    .ideographic = n.ideographic,
                    .central = n.central,
                    .hanging = n.hanging,
                    .mathematical = n.mathematical,
                    .middle = n.middle,
                    .text_bottom = n.text_bottom,
                    .text_top = n.text_top,
                } },
            },
            .script = skb_baseline_set.script,
            .direction = skb_baseline_set.direction,
        };
    }

    pub fn toSkb(self: BaselineSet) raw.skb_baseline_set_t {
        return .{
            .unnamed_0 = switch (self.baselines) {
                .array => .{ .baselines = self.baselines.array },
                .named => |n| .{ .unnamed_0 = .{
                    .alphabetic = n.alphabetic,
                    .ideographic = n.ideographic,
                    .central = n.central,
                    .hanging = n.hanging,
                    .mathematical = n.mathematical,
                    .middle = n.middle,
                    .text_bottom = n.text_bottom,
                    .text_top = n.text_top,
                } },
            },
            .script = self.script,
            .direction = self.direction,
        };
    }
};

pub const CaretMetrics = extern struct {
    offset: f32,
    slope: f32,

    pub fn fromSkb(skb_caret: raw.skb_caret_metrics_t) CaretMetrics {
        return .{
            .offset = skb_caret.offset,
            .slope = skb_caret.slope,
        };
    }
};

pub const FontCreateParams = extern struct {
    embolden_x: f32,
    embolden_y: f32,
    slant: f32,
};

pub const FontHandle = enum(u32) {
    none = 0,
    _,
};

pub const Font = opaque {};

pub const FontFallbackFunc = fn (
    font_collection: *FontCollection,
    lang: [*:0]const u8,
    script: Script,
    font_family: FontFamily,
    context: ?*anyopaque,
) callconv(.c) bool;

pub const DestroyFunc = fn (data: ?*anyopaque, context: ?*anyopaque) callconv(.c) void;

pub const FontCollection = opaque {
    pub fn create() std.mem.Allocator.Error!*FontCollection {
        return @ptrCast(raw.skb_font_collection_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *FontCollection) void {
        raw.skb_font_collection_destroy(@ptrCast(self));
    }

    pub fn setOnFontFallback(self: *FontCollection, fallback_func: ?*const FontFallbackFunc, context: ?*anyopaque) void {
        raw.skb_font_collection_set_on_font_fallback(
            @ptrCast(self),
            @ptrCast(fallback_func),
            context,
        );
    }

    pub fn addFontFromData(
        self: *FontCollection,
        name: [:0]const u8,
        font_data: []const u8,
        context: ?*anyopaque,
        destroy_func: ?*const DestroyFunc,
        font_family: FontFamily,
        params: ?FontCreateParams,
    ) FontHandle {
        const skb_params: raw.skb_font_create_params_t = if (params) |p| .{
            .embolden_x = p.embolden_x,
            .embolden_y = p.embolden_y,
            .slant = p.slant,
        } else undefined;
        return @ptrCast(raw.skb_font_collection_add_font_from_data(
            @ptrCast(self),
            @ptrCast(name.ptr),
            @ptrCast(font_data.ptr),
            @intCast(font_data.len),
            context,
            @ptrCast(destroy_func),
            @intFromEnum(font_family),
            if (params) |_| @ptrCast(&skb_params) else null,
        ));
    }

    pub fn addFontFromPath(
        self: *FontCollection,
        file_name: [:0]const u8,
        font_family: FontFamily,
        params: ?FontCreateParams,
    ) FontHandle {
        const skb_params: raw.skb_font_create_params_t = if (params) |p| .{
            .embolden_x = p.embolden_x,
            .embolden_y = p.embolden_y,
            .slant = p.slant,
        } else undefined;
        return @enumFromInt(raw.skb_font_collection_add_font(
            @ptrCast(self),
            @ptrCast(file_name.ptr),
            @intFromEnum(font_family),
            if (params) |_| @ptrCast(&skb_params) else null,
        ));
    }

    pub fn addHarfbuzzFont(
        self: *FontCollection,
        name: [:0]const u8,
        hb_font: *HbFont,
        font_family: FontFamily,
        params: ?FontCreateParams,
    ) FontHandle {
        const skb_params: raw.skb_font_create_params_t = if (params) |p| .{
            .embolden_x = p.embolden_x,
            .embolden_y = p.embolden_y,
            .slant = p.slant,
        } else undefined;
        return @ptrCast(raw.skb_font_collection_add_hb_font(
            @ptrCast(self),
            @ptrCast(name.ptr),
            @ptrCast(hb_font),
            @intFromEnum(font_family),
            if (params) |_| @ptrCast(&skb_params) else null,
        ));
    }

    pub fn removeFont(self: *FontCollection, font_handle: FontHandle) bool {
        return raw.skb_font_collection_remove_font(@ptrCast(self), @intFromEnum(font_handle));
    }

    pub fn matchFonts(
        self: *FontCollection,
        lang: [:0]const u8,
        script: Script,
        font_family: FontFamily,
        weight: Weight,
        style: Style,
        stretch: Stretch,
        results: []FontHandle,
    ) i32 {
        return raw.skb_font_collection_match_fonts(
            @ptrCast(self),
            @ptrCast(lang.ptr),
            @intFromEnum(script),
            @intFromEnum(font_family),
            @intFromEnum(weight),
            @intFromEnum(style),
            @intFromEnum(stretch),
            @ptrCast(results.ptr),
            @intCast(results.len),
        );
    }

    pub fn fontHasCodepoint(self: *FontCollection, font_handle: FontHandle, codepoint: u32) bool {
        return raw.skb_font_collection_font_has_codepoint(
            @ptrCast(self),
            @intFromEnum(font_handle),
            codepoint,
        );
    }

    pub fn getDefaultFont(self: *FontCollection, font_family: FontFamily) FontHandle {
        return @ptrCast(raw.skb_font_collection_get_default_font(
            @ptrCast(self),
            @intFromEnum(font_family),
        ));
    }

    pub fn getFont(self: *FontCollection, font_handle: FontHandle) ?*Font {
        return @ptrCast(raw.skb_font_collection_get_font(
            @ptrCast(self),
            @intFromEnum(font_handle),
        ));
    }

    pub fn getId(self: *FontCollection) u32 {
        return raw.skb_font_collection_get_id(@ptrCast(self));
    }

    pub fn getGlyphBounds(self: *FontCollection, font_handle: FontHandle, glyph_id: u32, font_size: f32) Rect2 {
        return .fromSkb(raw.skb_font_get_glyph_bounds(
            @ptrCast(self),
            @intFromEnum(font_handle),
            glyph_id,
            font_size,
        ));
    }

    pub fn getMetrics(self: *FontCollection, font_handle: FontHandle) FontMetrics {
        return .fromSkb(raw.skb_font_get_metrics(
            @ptrCast(self),
            @intFromEnum(font_handle),
        ));
    }

    pub fn getCaretMetrics(self: *FontCollection, font_handle: FontHandle) CaretMetrics {
        return .fromSkb(raw.skb_font_get_caret_metrics(
            @ptrCast(self),
            @intFromEnum(font_handle),
        ));
    }

    pub fn getHarfbuzzFont(self: *FontCollection, font_handle: FontHandle) ?*HbFont {
        return @ptrCast(raw.skb_font_get_hb_font(
            @ptrCast(self),
            @intFromEnum(font_handle),
        ));
    }

    pub fn getBaseline(
        self: *FontCollection,
        font_handle: FontHandle,
        baseline: Baseline,
        direction: TextDirection,
        script: Script,
        font_size: f32,
    ) f32 {
        return raw.skb_font_get_baseline(
            @ptrCast(self),
            @intFromEnum(font_handle),
            @intFromEnum(baseline),
            @intFromEnum(direction),
            @intFromEnum(script),
            font_size,
        );
    }

    pub fn getBaselineSet(
        self: *FontCollection,
        font_handle: FontHandle,
        direction: TextDirection,
        script: Script,
        font_size: f32,
    ) BaselineSet {
        return .fromSkb(raw.skb_font_get_baseline_set(
            @ptrCast(self),
            @intFromEnum(font_handle),
            @intFromEnum(direction),
            @intFromEnum(script),
            font_size,
        ));
    }
};

pub const AttributeTextDirection = extern struct {
    kind: AttributeType = .text_direction,
    direction: TextDirection = .auto,
};

pub const AttributeLang = extern struct {
    kind: AttributeType = .lang,
    lang: ?[*:0]const u8 = null,
};

pub const AttributeFontFamily = extern struct {
    kind: AttributeType = .font_family,
    family: FontFamily = .default,
};

pub const AttributeFontSize = extern struct {
    kind: AttributeType = .font_size,
    size: f32 = 0,
};

pub const AttributeFontWeight = extern struct {
    kind: AttributeType = .font_weight,
    weight: Weight = .normal,
};

pub const AttributeFontStyle = extern struct {
    kind: AttributeType = .font_style,
    style: Style = .normal,
};

pub const AttributeFontStretch = extern struct {
    kind: AttributeType = .font_stretch,
    stretch: Stretch = .normal,
};

pub const AttributeFontFeature = extern struct {
    kind: AttributeType = .font_feature,
    tag: u32 = 0,
    value: u32 = 0,
};

pub const AttributeLetterSpacing = extern struct {
    kind: AttributeType = .letter_spacing,
    spacing: f32 = 0,
};

pub const AttributeWordSpacing = extern struct {
    kind: AttributeType = .word_spacing,
    spacing: f32 = 0,
};

pub const AttributeLineHeight = extern struct {
    kind: AttributeType = .line_height,
    type_: u8 = 0,
    height: f32 = 0,
};

pub const AttributeTabStopIncrement = extern struct {
    kind: AttributeType = .tab_stop_increment,
    increment: f32 = 0,
};

pub const AttributeTextWrap = extern struct {
    kind: AttributeType = .text_wrap,
    wrap: TextWrap = .word,
};

pub const AttributeTextOverflow = extern struct {
    kind: AttributeType = .text_overflow,
    overflow: TextOverflow = .clip,
};

pub const AttributeVerticalTrim = extern struct {
    kind: AttributeType = .vertical_trim,
    trim: VerticalTrim = .default,
};

pub const AttributeAlign = extern struct {
    kind: AttributeType = .horizontal_align, // or .vertical_align
    alignment: Align = .left, // or VerticalAlign
};

pub const AttributeBaselineAlign = extern struct {
    kind: AttributeType = .baseline_align,
    alignment: Baseline = .alphabetic,
};

pub const AttributeFill = extern struct {
    kind: AttributeType = .fill,
    color: Color = .rgba(0, 0, 0, 255),
};

pub const AttributeDecoration = extern struct {
    kind: AttributeType = .decoration,
    position: u8 = 0,
    style: u8 = 0,
    thickness: f32 = 0,
    offset: f32 = 0,
    color: Color = .rgba(0, 0, 0, 255),
};

pub const AttributeObjectAlign = extern struct {
    kind: AttributeType = .object_align,
    baseline_ratio: f32 = 0,
    align_ref: u8 = 0,
    align_baseline: u8 = 0,
};

pub const AttributeObjectPadding = extern struct {
    kind: AttributeType = .object_padding,
    start: f32 = 0,
    end: f32 = 0,
    top: f32 = 0,
    bottom: f32 = 0,
};

pub const AttributeReference = extern struct {
    kind: AttributeType = .reference,
    handle: AttributeSetHandle,
};

pub const AttributeType = enum(c_uint) {
    text_direction = raw.SKB_ATTRIBUTE_TEXT_DIRECTION,
    lang = raw.SKB_ATTRIBUTE_LANG,
    font_family = raw.SKB_ATTRIBUTE_FONT_FAMILY,
    font_stretch = raw.SKB_ATTRIBUTE_FONT_STRETCH,
    font_size = raw.SKB_ATTRIBUTE_FONT_SIZE,
    font_weight = raw.SKB_ATTRIBUTE_FONT_WEIGHT,
    font_style = raw.SKB_ATTRIBUTE_FONT_STYLE,
    font_feature = raw.SKB_ATTRIBUTE_FONT_FEATURE,
    letter_spacing = raw.SKB_ATTRIBUTE_LETTER_SPACING,
    word_spacing = raw.SKB_ATTRIBUTE_WORD_SPACING,
    line_height = raw.SKB_ATTRIBUTE_LINE_HEIGHT,
    tab_stop_increment = raw.SKB_ATTRIBUTE_TAB_STOP_INCREMENT,
    text_wrap = raw.SKB_ATTRIBUTE_TEXT_WRAP,
    text_overflow = raw.SKB_ATTRIBUTE_TEXT_OVERFLOW,
    vertical_trim = raw.SKB_ATTRIBUTE_VERTICAL_TRIM,
    horizontal_align = raw.SKB_ATTRIBUTE_HORIZONTAL_ALIGN,
    vertical_align = raw.SKB_ATTRIBUTE_VERTICAL_ALIGN,
    baseline_align = raw.SKB_ATTRIBUTE_BASELINE_ALIGN,
    fill = raw.SKB_ATTRIBUTE_FILL,
    decoration = raw.SKB_ATTRIBUTE_DECORATION,
    object_align = raw.SKB_ATTRIBUTE_OBJECT_ALIGN,
    object_padding = raw.SKB_ATTRIBUTE_OBJECT_PADDING,
    reference = raw.SKB_ATTRIBUTE_REFERENCE,
};

pub const Attribute = extern union {
    kind: AttributeType,
    text_direction: AttributeTextDirection,
    lang: AttributeLang,
    font_family: AttributeFontFamily,
    font_size: AttributeFontSize,
    font_weight: AttributeFontWeight,
    font_style: AttributeFontStyle,
    font_stretch: AttributeFontStretch,
    font_feature: AttributeFontFeature,
    letter_spacing: AttributeLetterSpacing,
    word_spacing: AttributeWordSpacing,
    line_height: AttributeLineHeight,
    tab_stop_increment: AttributeTabStopIncrement,
    text_wrap: AttributeTextWrap,
    text_overflow: AttributeTextOverflow,
    vertical_trim: AttributeVerticalTrim,
    horizontal_align: AttributeAlign,
    vertical_align: AttributeAlign,
    baseline_align: AttributeBaselineAlign,
    fill: AttributeFill,
    decoration: AttributeDecoration,
    object_align: AttributeObjectAlign,
    object_padding: AttributeObjectPadding,
    reference: AttributeReference,

    pub fn attrTextDirection(direction: TextDirection) Attribute {
        return .{ .text_direction = .{ .direction = direction } };
    }

    pub fn attrLang(lang: ?[:0]const u8) Attribute {
        return .{ .lang = .{ .lang = lang } };
    }

    pub fn attrFontFamily(family: FontFamily) Attribute {
        return .{ .font_family = .{ .family = family } };
    }

    pub fn attrFontSize(size: f32) Attribute {
        return .{ .font_size = .{ .size = size } };
    }

    pub fn attrFontWeight(weight: Weight) Attribute {
        return .{ .font_weight = .{ .weight = weight } };
    }

    pub fn attrFontStyle(style: Style) Attribute {
        return .{ .font_style = .{ .style = style } };
    }

    pub fn attrFontStretch(stretch: Stretch) Attribute {
        return .{ .font_stretch = .{ .stretch = stretch } };
    }

    pub fn attrFontFeature(tag: u32, value: u32) Attribute {
        return .{ .font_feature = .{ .tag = tag, .value = value } };
    }

    pub fn attrLetterSpacing(spacing: f32) Attribute {
        return .{ .letter_spacing = .{ .spacing = spacing } };
    }

    pub fn attrWordSpacing(spacing: f32) Attribute {
        return .{ .word_spacing = .{ .spacing = spacing } };
    }

    pub fn attrLineHeight(type_: u8, height: f32) Attribute {
        return .{ .line_height = .{ .type_ = type_, .height = height } };
    }

    pub fn attrTabStopIncrement(increment: f32) Attribute {
        return .{ .tab_stop_increment = .{ .increment = increment } };
    }

    pub fn attrTextWrap(wrap: TextWrap) Attribute {
        return .{ .text_wrap = .{ .wrap = wrap } };
    }

    pub fn attrTextOverflow(overflow: TextOverflow) Attribute {
        return .{ .text_overflow = .{ .overflow = overflow } };
    }

    pub fn attrVerticalTrim(trim: VerticalTrim) Attribute {
        return .{ .vertical_trim = .{ .trim = trim } };
    }

    pub fn attrHorizontalAlign(alignment: Align) Attribute {
        return .{ .horizontal_align = .{ .alignment = alignment } };
    }

    pub fn attrVerticalAlign(alignment: Align) Attribute {
        return .{ .vertical_align = .{ .alignment = alignment } };
    }

    pub fn attrBaselineAlign(alignment: Baseline) Attribute {
        return .{ .baseline_align = .{ .alignment = alignment } };
    }

    pub fn attrFill(color: Color) Attribute {
        return .{ .fill = .{ .color = color } };
    }

    pub fn attrDecoration(position: u8, style: u8, thickness: f32, offset: f32, color: Color) Attribute {
        return .{ .decoration = .{
            .position = position,
            .style = style,
            .thickness = thickness,
            .offset = offset,
            .color = color,
        } };
    }

    pub fn attrObjectAlign(alignment: Align, baseline_ratio: f32, align_ref: u8, align_baseline: u8) Attribute {
        return .{ .object_align = .{
            .alignment = alignment,
            .baseline_ratio = baseline_ratio,
            .align_ref = align_ref,
            .align_baseline = align_baseline,
        } };
    }

    pub fn attrObjectPadding(start: f32, end: f32, top: f32, bottom: f32) Attribute {
        return .{ .object_padding = .{
            .start = start,
            .end = end,
            .top = top,
            .bottom = bottom,
        } };
    }

    pub fn attrReferenceByName(attribute_collection: *const AttributeCollection, name: [:0]const u8) Attribute {
        return @bitCast(raw.skb_attribute_make_reference_by_name(
            @ptrCast(attribute_collection),
            @ptrCast(name.ptr),
        ));
    }
};

pub const AttributeSetHandle = enum(u64) {
    none = 0,
    _,

    pub fn makeReference(self: AttributeSetHandle) Attribute {
        return .{
            .reference = .{ .handle = self },
        };
    }

    pub fn getGroup(self: AttributeSetHandle) i32 {
        return raw.skb_attribute_set_handle_get_group(@intFromEnum(self));
    }
};

pub const AttributeCollection = opaque {
    pub fn create() std.mem.Allocator.Error!*AttributeCollection {
        return @ptrCast(raw.skb_attribute_collection_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *AttributeCollection) void {
        raw.skb_attribute_collection_destroy(@ptrCast(self));
    }

    pub fn getId(self: *const AttributeCollection) u32 {
        return raw.skb_attribute_collection_get_id(@ptrCast(self));
    }

    pub fn addSet(self: *AttributeCollection, name: [:0]const u8, attribute_set: AttributeSet) AttributeSetHandle {
        return raw.skb_attribute_collection_add_set(
            @ptrCast(self),
            @ptrCast(name.ptr),
            @bitCast(attribute_set),
        );
    }

    pub fn addSetWithGroup(self: *AttributeCollection, name: [:0]const u8, group_name: [:0]const u8, attribute_set: AttributeSet) AttributeSetHandle {
        return raw.skb_attribute_collection_add_set_with_group(
            @ptrCast(self),
            @ptrCast(name.ptr),
            @ptrCast(group_name.ptr),
            @bitCast(attribute_set),
        );
    }

    pub fn findSetByName(self: *const AttributeCollection, name: [:0]const u8) AttributeSetHandle {
        return raw.skb_attribute_collection_find_set_by_name(
            @ptrCast(self),
            @ptrCast(name.ptr),
        );
    }

    pub fn getSet(self: *const AttributeCollection, handle: AttributeSetHandle) AttributeSet {
        return @bitCast(raw.skb_attribute_collection_get_set(
            @ptrCast(self),
            @intFromEnum(handle),
        ));
    }

    pub fn getSetByName(self: *const AttributeCollection, name: [:0]const u8) AttributeSet {
        return @bitCast(raw.skb_attribute_collection_get_set_by_name(
            @ptrCast(self),
            @ptrCast(name.ptr),
        ));
    }
};

pub const AttributeSet = extern struct {
    attributes: ?[*]const Attribute = null,
    attributes_count: i32 = 0,
    set_handle: AttributeSetHandle = .none,
    parent_set: ?*const AttributeSet = null,

    pub fn initAttributes(attributes: []const Attribute) AttributeSet {
        return .{
            .attributes = attributes.ptr,
            .attributes_count = @intCast(attributes.len),
            .set_handle = .none,
            .parent_set = null,
        };
    }

    pub fn referenceByName(attribute_collection: *const AttributeCollection, name: [:0]const u8) AttributeSet {
        return @bitCast(raw.skb_attribute_set_make_reference_by_name(
            @ptrCast(attribute_collection),
            @ptrCast(name.ptr),
        ));
    }

    pub fn getTextDirection(self: AttributeSet, collection: *const AttributeCollection) TextDirection {
        return @enumFromInt(raw.skb_attributes_get_text_direction(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getLang(self: AttributeSet, collection: *const AttributeCollection) ?[:0]const u8 {
        const lang = raw.skb_attributes_get_lang(
            @bitCast(self),
            @ptrCast(collection),
        );
        if (lang == null) return null;
        return std.mem.sliceTo(lang, 0);
    }

    pub fn getFontFamily(self: AttributeSet, collection: *const AttributeCollection) FontFamily {
        return @enumFromInt(raw.skb_attributes_get_font_family(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getFontSize(self: AttributeSet, collection: *const AttributeCollection) f32 {
        return raw.skb_attributes_get_font_size(
            @bitCast(self),
            @ptrCast(collection),
        );
    }

    pub fn getFontWeight(self: AttributeSet, collection: *const AttributeCollection) Weight {
        return @enumFromInt(raw.skb_attributes_get_font_weight(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getFontStyle(self: AttributeSet, collection: *const AttributeCollection) Style {
        return @enumFromInt(raw.skb_attributes_get_font_style(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getFontStretch(self: AttributeSet, collection: *const AttributeCollection) Stretch {
        return @enumFromInt(raw.skb_attributes_get_font_stretch(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getLetterSpacing(self: AttributeSet, collection: *const AttributeCollection) f32 {
        return raw.skb_attributes_get_letter_spacing(
            @bitCast(self),
            @ptrCast(collection),
        );
    }

    pub fn getWordSpacing(self: AttributeSet, collection: *const AttributeCollection) f32 {
        return raw.skb_attributes_get_word_spacing(
            @bitCast(self),
            @ptrCast(collection),
        );
    }

    pub fn getLineHeight(self: AttributeSet, collection: *const AttributeCollection) AttributeLineHeight {
        const attr = raw.skb_attributes_get_line_height(
            @bitCast(self),
            @ptrCast(collection),
        );
        return .{
            .type_ = attr.type,
            .height = attr.height,
        };
    }

    pub fn getFill(self: AttributeSet, collection: *const AttributeCollection) AttributeFill {
        const attr = raw.skb_attributes_get_fill(
            @bitCast(self),
            @ptrCast(collection),
        );
        return .{
            .color = attr.color,
        };
    }

    pub fn getObjectAlign(self: AttributeSet, collection: *const AttributeCollection) AttributeObjectAlign {
        const attr = raw.skb_attributes_get_object_align(
            @bitCast(self),
            @ptrCast(collection),
        );
        return .{
            .baseline_ratio = attr.baseline_ratio,
            .align_ref = attr.align_ref,
            .align_baseline = attr.align_baseline,
        };
    }

    pub fn getObjectPadding(self: AttributeSet, collection: *const AttributeCollection) AttributeObjectPadding {
        const attr = raw.skb_attributes_get_object_padding(
            @bitCast(self),
            @ptrCast(collection),
        );
        return .{
            .start = attr.start,
            .end = attr.end,
            .top = attr.top,
            .bottom = attr.bottom,
        };
    }

    pub fn getTabStopIncrement(self: AttributeSet, collection: *const AttributeCollection) f32 {
        return raw.skb_attributes_get_tab_stop_increment(
            @bitCast(self),
            @ptrCast(collection),
        );
    }

    pub fn getTextWrap(self: AttributeSet, collection: *const AttributeCollection) TextWrap {
        return @enumFromInt(raw.skb_attributes_get_text_wrap(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getTextOverflow(self: AttributeSet, collection: *const AttributeCollection) TextOverflow {
        return @enumFromInt(raw.skb_attributes_get_text_overflow(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getVerticalTrim(self: AttributeSet, collection: *const AttributeCollection) VerticalTrim {
        return @enumFromInt(raw.skb_attributes_get_vertical_trim(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getHorizontalAlign(self: AttributeSet, collection: *const AttributeCollection) Align {
        return @enumFromInt(raw.skb_attributes_get_horizontal_align(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getVerticalAlign(self: AttributeSet, collection: *const AttributeCollection) Align {
        return @enumFromInt(raw.skb_attributes_get_vertical_align(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }
    pub fn getBaselineAlign(self: AttributeSet, collection: *const AttributeCollection) Baseline {
        return @enumFromInt(raw.skb_attributes_get_baseline_align(
            @bitCast(self),
            @ptrCast(collection),
        ));
    }

    pub fn getByKind(self: AttributeSet, collection: *const AttributeCollection, kind: AttributeType, results: []*const Attribute) usize {
        return @intCast(raw.skb_attributes_get_by_kind(
            @bitCast(self),
            @ptrCast(collection),
            @intFromEnum(kind),
            @ptrCast(results.ptr),
            @intCast(results.len),
        ));
    }

    pub fn getCopyFlatCount(self: AttributeSet) usize {
        return @intCast(raw.skb_attributes_get_copy_flat_count(@bitCast(self)));
    }

    pub fn copyFlat(self: AttributeSet, dest: []*const Attribute) usize {
        return @intCast(raw.skb_attributes_copy_flat(
            @bitCast(self),
            @ptrCast(dest.ptr),
            @intCast(dest.len),
        ));
    }
};

// TODO: pub extern fn skb_attributes_hash_append(hash: u64, attributes: skb_attribute_set_t) u64;

pub const GradientSpread = enum(c_uint) {
    pad = raw.SKB_SPREAD_PAD,
    repeat = raw.SKB_SPREAD_REPEAT,
    reflect = raw.SKB_SPREAD_REFLECT,
};

pub const ColorStop = extern struct {
    offset: f32,
    color: Color = .rgba(0, 0, 0, 255),

    pub fn init(offset: f32, color: Color) ColorStop {
        return .{
            .offset = offset,
            .color = color,
        };
    }
};

pub const Canvas = opaque {
    pub fn create(temp_alloc: *TempAlloc, target: *Image) std.mem.Allocator.Error!*Canvas {
        return @ptrCast(raw.skb_canvas_create(@ptrCast(temp_alloc), @ptrCast(target)) orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *Canvas) void {
        raw.skb_canvas_destroy(@ptrCast(self));
    }

    pub fn moveTo(self: *Canvas, pt: Vec2) void {
        raw.skb_canvas_move_to(@ptrCast(self), pt.toSkb());
    }

    pub fn lineTo(self: *Canvas, pt: Vec2) void {
        raw.skb_canvas_line_to(@ptrCast(self), pt.toSkb());
    }

    pub fn quadTo(self: *Canvas, cp: Vec2, pt: Vec2) void {
        raw.skb_canvas_quad_to(@ptrCast(self), cp.toSkb(), pt.toSkb());
    }

    pub fn cubicTo(self: *Canvas, cp0: Vec2, cp1: Vec2, pt: Vec2) void {
        raw.skb_canvas_cubic_to(@ptrCast(self), cp0.toSkb(), cp1.toSkb(), pt.toSkb());
    }

    pub fn close(self: *Canvas) void {
        raw.skb_canvas_close(@ptrCast(self));
    }

    pub fn pushTransform(self: *Canvas, t: Mat2) void {
        raw.skb_canvas_push_transform(@ptrCast(self), t.toSkb());
    }

    pub fn popTransform(self: *Canvas) void {
        raw.skb_canvas_pop_transform(@ptrCast(self));
    }

    pub fn pushMask(self: *Canvas) void {
        raw.skb_canvas_push_mask(@ptrCast(self));
    }

    pub fn popMask(self: *Canvas) void {
        raw.skb_canvas_pop_mask(@ptrCast(self));
    }

    pub fn pushLayer(self: *Canvas) void {
        raw.skb_canvas_push_layer(@ptrCast(self));
    }

    pub fn popLayer(self: *Canvas) void {
        raw.skb_canvas_pop_layer(@ptrCast(self));
    }

    pub fn fillMask(self: *Canvas) void {
        raw.skb_canvas_fill_mask(@ptrCast(self));
    }

    pub fn fillSolidColor(self: *Canvas, color: Color) void {
        raw.skb_canvas_fill_solid_color(@ptrCast(self), color);
    }

    pub fn fillLinearGradient(
        self: *Canvas,
        p0: Vec2,
        p1: Vec2,
        spread: GradientSpread,
        stops: []const ColorStop,
    ) void {
        raw.skb_canvas_fill_linear_gradient(
            @ptrCast(self),
            p0.toSkb(),
            p1.toSkb(),
            @intFromEnum(spread),
            @ptrCast(stops.ptr),
            @intCast(stops.len),
        );
    }

    pub fn fillRadialGradient(
        self: *Canvas,
        p0: Vec2,
        r0: f32,
        p1: Vec2,
        r1: f32,
        spread: GradientSpread,
        stops: []const ColorStop,
    ) void {
        raw.skb_canvas_fill_radial_gradient(
            @ptrCast(self),
            p0.toSkb(),
            r0,
            p1.toSkb(),
            r1,
            @intFromEnum(spread),
            @ptrCast(stops.ptr),
            @intCast(stops.len),
        );
    }
};

pub const max_active_attributes = raw.SKB_MAX_ACTIVE_ATTRIBUTES;

pub const AttributeSpan = extern struct {
    text_range: Range,
    attribute: Attribute,
};

pub const Text = opaque {
    pub fn create() std.mem.Allocator.Error!*Text {
        return @ptrCast(raw.skb_text_create() orelse return error.OutOfMemory);
    }

    pub fn createTemp(temp_alloc: *TempAlloc) std.mem.Allocator.Error!*Text {
        return @ptrCast(raw.skb_text_create_temp(@ptrCast(temp_alloc)) orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *Text) void {
        raw.skb_text_destroy(@ptrCast(self));
    }

    pub fn reset(self: *Text) void {
        raw.skb_text_reset(@ptrCast(self));
    }

    pub fn reserve(self: *Text, text_count: usize, spans_count: usize) void {
        raw.skb_text_reserve(@ptrCast(self), @intCast(text_count), @intCast(spans_count));
    }

    pub fn getUtf32Count(self: *const Text) usize {
        return @intCast(raw.skb_text_get_utf32_count(@ptrCast(self)));
    }

    pub fn getUtf32(self: *const Text) ?[*]const u32 {
        const ptr = raw.skb_text_get_utf32(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getUtf32Slice(self: *const Text) []const u32 {
        const count = self.getUtf32Count();
        const ptr = self.getUtf32() orelse return &.{};
        return ptr[0..count];
    }

    pub fn sanitizeRange(self: *const Text, range: Range) Range {
        return .fromSkb(raw.skb_text_sanitize_range(@ptrCast(self), range.toSkb()));
    }

    pub fn getAttributeSpansCount(self: *const Text) usize {
        return @intCast(raw.skb_text_get_attribute_spans_count(@ptrCast(self)));
    }

    pub fn getAttributeSpans(self: *const Text) ?[*]const AttributeSpan {
        const ptr = raw.skb_text_get_attribute_spans(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getAttributeSpansSlice(self: *const Text) []const AttributeSpan {
        const count = self.getAttributeSpansCount();
        const ptr = self.getAttributeSpans() orelse return &.{};
        return ptr[0..count];
    }

    pub fn append(self: *Text, text_from: *const Text) void {
        raw.skb_text_append(@ptrCast(self), @ptrCast(text_from));
    }

    pub fn appendRange(self: *Text, from_text: *const Text, from_range: Range) void {
        raw.skb_text_append_range(
            @ptrCast(self),
            @ptrCast(from_text),
            from_range.toSkb(),
        );
    }

    pub fn appendUtf8(self: *Text, utf8: [:0]const u8, attributes: AttributeSet) void {
        raw.skb_text_append_utf8(
            @ptrCast(self),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
            @bitCast(attributes),
        );
    }

    pub fn appendUtf32(self: *Text, utf32: []const u32, attributes: AttributeSet) void {
        raw.skb_text_append_utf32(
            @ptrCast(self),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
            @bitCast(attributes),
        );
    }

    pub fn replace(self: *Text, range: Range, other: *const Text) void {
        raw.skb_text_replace(@ptrCast(self), range.toSkb(), @ptrCast(other));
    }

    pub fn replaceUtf8(self: *Text, range: Range, utf8: []const u8, attributes: AttributeSet) void {
        raw.skb_text_replace_utf8(
            @ptrCast(self),
            range.toSkb(),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
            @bitCast(attributes),
        );
    }

    pub fn replaceUtf32(self: *Text, range: Range, utf32: []const u32, attributes: AttributeSet) void {
        raw.skb_text_replace_utf32(
            @ptrCast(self),
            range.toSkb(),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
            @bitCast(attributes),
        );
    }

    pub fn remove(self: *Text, range: Range) void {
        raw.skb_text_remove(@ptrCast(self), range.toSkb());
    }

    pub fn removeIf(self: *Text, filter_func: *const RemoveFunc, context: ?*anyopaque) void {
        raw.skb_text_remove_if(@ptrCast(self), @ptrCast(filter_func), context);
    }

    pub fn clearAttribute(self: *Text, range: Range, attribute: Attribute) void {
        raw.skb_text_clear_attribute(@ptrCast(self), range.toSkb(), @bitCast(attribute));
    }

    pub fn clearAllAttributes(self: *Text, range: Range) void {
        raw.skb_text_clear_all_attributes(@ptrCast(self), range.toSkb());
    }

    pub fn addAttribute(self: *Text, range: Range, attribute: Attribute) void {
        raw.skb_text_add_attribute(@ptrCast(self), range.toSkb(), @bitCast(attribute));
    }

    pub fn iterateAttributeRuns(self: *const Text, callback: *const TextIteratorFunc, context: ?*anyopaque) void {
        raw.skb_text_iterate_attribute_runs(@ptrCast(self), @ptrCast(callback), context);
    }
};

pub const RemoveFunc = fn (codepoint: u32, index: i32, context: ?*anyopaque) callconv(.c) bool;
pub const TextIteratorFunc = fn (text: *const Text, range: Range, active_spans: [*][*]AttributeSpan, active_spans_count: i32, context: ?*anyopaque) callconv(.c) void;

pub const Icon = opaque {};

pub const IconHandle = enum(u32) {
    none = 0,
    _,
};

pub const IconShape = opaque {};

pub const IconCollection = opaque {
    pub fn create() std.mem.Allocator.Error!*IconCollection {
        return @ptrCast(raw.skb_icon_collection_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *IconCollection) void {
        raw.skb_icon_collection_destroy(@ptrCast(self));
    }

    pub fn addPicosvgIconFromData(self: *IconCollection, name: [:0]const u8, icon_data: []const u8) u32 {
        return raw.skb_icon_collection_add_picosvg_icon_from_data(
            @ptrCast(self),
            @ptrCast(name.ptr),
            @ptrCast(icon_data.ptr),
            @intCast(icon_data.len),
        );
    }

    pub fn addPicosvgIconFromPath(self: *IconCollection, name: [:0]const u8, file_name: [:0]const u8) u32 {
        return raw.skb_icon_collection_add_picosvg_icon(
            @ptrCast(self),
            @ptrCast(name.ptr),
            @ptrCast(file_name.ptr),
        );
    }

    pub fn addIcon(self: *IconCollection, name: [:0]const u8, width: f32, height: f32) IconHandle {
        return @enumFromInt(raw.skb_icon_collection_add_icon(
            @ptrCast(self),
            @ptrCast(name.ptr),
            width,
            height,
        ));
    }

    pub fn removeIcon(self: *IconCollection, icon_handle: IconHandle) bool {
        return raw.skb_icon_collection_remove_icon(@ptrCast(self), @intFromEnum(icon_handle));
    }

    pub fn findIcon(self: *const IconCollection, name: [:0]const u8) IconHandle {
        return @enumFromInt(raw.skb_icon_collection_find_icon(
            @ptrCast(self),
            @ptrCast(name.ptr),
        ));
    }

    pub fn setIsColor(self: *IconCollection, icon_handle: IconHandle, is_color: bool) void {
        raw.skb_icon_collection_set_is_color(@ptrCast(self), @intFromEnum(icon_handle), is_color);
    }

    pub fn calcProportionalScale(self: *const IconCollection, icon_handle: IconHandle, width: f32, height: f32) Vec2 {
        return .fromSkb(raw.skb_icon_collection_calc_proportional_scale(
            @ptrCast(self),
            @intFromEnum(icon_handle),
            width,
            height,
        ));
    }

    pub fn calcProportionalSize(self: *const IconCollection, icon_handle: IconHandle, width: f32, height: f32) Vec2 {
        return .fromSkb(raw.skb_icon_collection_calc_proportional_size(
            @ptrCast(self),
            @intFromEnum(icon_handle),
            width,
            height,
        ));
    }

    pub fn getIconSize(self: *const IconCollection, icon_handle: IconHandle) Vec2 {
        return .fromSkb(raw.skb_icon_collection_get_icon_size(@ptrCast(self), @intFromEnum(icon_handle)));
    }

    pub fn getIcon(self: *const IconCollection, icon_handle: IconHandle) ?*const Icon {
        const ptr = raw.skb_icon_collection_get_icon(@ptrCast(self), @intFromEnum(icon_handle));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getId(self: *const IconCollection) u32 {
        return raw.skb_icon_collection_get_id(@ptrCast(self));
    }
};

pub const icon_builder_max_nested_shapes = raw.SKB_ICON_BUILDER_MAX_NESTED_SHAPES;
pub const IconBuilder = extern struct {
    icon_collection: *IconCollection,
    icon_handle: IconHandle,
    shape_stack: [icon_builder_max_nested_shapes]?*IconShape = @splat(null),
    shape_stack_idx: i32 = 0,

    pub fn create(icon_collection: *IconCollection, icon_handle: IconHandle) IconBuilder {
        return @bitCast(raw.skb_icon_builder_make(@ptrCast(icon_collection), @intFromEnum(icon_handle)));
    }

    pub fn beginShape(self: *IconBuilder) void {
        raw.skb_icon_builder_begin_shape(@ptrCast(self));
    }

    pub fn endShape(self: *IconBuilder) void {
        raw.skb_icon_builder_end_shape(@ptrCast(self));
    }

    pub fn moveTo(self: *IconBuilder, pt: Vec2) void {
        raw.skb_icon_builder_move_to(@ptrCast(self), pt.toSkb());
    }

    pub fn lineTo(self: *IconBuilder, pt: Vec2) void {
        raw.skb_icon_builder_line_to(@ptrCast(self), pt.toSkb());
    }

    pub fn quadTo(self: *IconBuilder, cp: Vec2, pt: Vec2) void {
        raw.skb_icon_builder_quad_to(@ptrCast(self), cp.toSkb(), pt.toSkb());
    }

    pub fn cubicTo(self: *IconBuilder, cp0: Vec2, cp1: Vec2, pt: Vec2) void {
        raw.skb_icon_builder_cubic_to(@ptrCast(self), cp0.toSkb(), cp1.toSkb(), pt.toSkb());
    }

    pub fn closePath(self: *IconBuilder) void {
        raw.skb_icon_builder_close_path(@ptrCast(self));
    }

    pub fn fillOpacity(self: *IconBuilder, opacity: f32) void {
        raw.skb_icon_builder_fill_opacity(@ptrCast(self), opacity);
    }

    pub fn fillColor(self: *IconBuilder, color: Color) void {
        raw.skb_icon_builder_fill_color(@ptrCast(self), color);
    }

    pub fn fillLinearGradient(self: *IconBuilder, p0: Vec2, p1: Vec2, xform: Mat2, spread: GradientSpread, stops: []const ColorStop) void {
        raw.skb_icon_builder_fill_linear_gradient(
            @ptrCast(self),
            p0.toSkb(),
            p1.toSkb(),
            xform.toSkb(),
            @intFromEnum(spread),
            @ptrCast(stops.ptr),
            @intCast(stops.len),
        );
    }

    pub fn fillRadialGradient(self: *IconBuilder, p0: Vec2, p1: Vec2, radius: f32, xform: Mat2, spread: GradientSpread, stops: []const ColorStop) void {
        raw.skb_icon_builder_fill_radial_gradient(
            @ptrCast(self),
            p0.toSkb(),
            p1.toSkb(),
            radius,
            xform.toSkb(),
            @intFromEnum(spread),
            @ptrCast(stops.ptr),
            @intCast(stops.len),
        );
    }
};

pub const HbLanguageImpl = opaque {};
pub const HbLanguage = *const HbLanguageImpl;

pub const layout_params_ignore_must_line_breaks = raw.SKB_LAYOUT_PARAMS_IGNORE_MUST_LINE_BREAKS;

pub const LayoutParams = extern struct {
    font_collection: ?*FontCollection = null,
    icon_collection: ?*IconCollection = null,
    attribute_collection: ?*AttributeCollection = null,
    layout_width: f32 = 0,
    layout_height: f32 = 0,
    flags: u8 = 0,
    layout_attributes: AttributeSet = .{},
    // TODO: create
};

pub const ContentTextUtf8 = extern struct {
    text: ?[*:0]const u8 = null,
    text_count: i32 = 0,

    pub fn toSkb(self: ContentTextUtf8) raw.struct_skb_content_text_utf8_t {
        return .{
            .text = @ptrCast(self.text),
            .text_count = self.text_count,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_content_text_utf8_t) ContentTextUtf8 {
        return .{
            .text = @ptrCast(skb.text),
            .text_count = skb.text_count,
        };
    }

    pub fn fromSlice(slice: []const u8) ContentTextUtf8 {
        return .{
            .text = @ptrCast(slice.ptr),
            .text_count = @intCast(slice.len),
        };
    }
};

pub const ContentTextUtf32 = extern struct {
    text: ?[*]const u32 = null,
    text_count: i32 = 0,

    pub fn toSkb(self: ContentTextUtf32) raw.struct_skb_content_text_utf32_t {
        return .{
            .text = @ptrCast(self.text),
            .text_count = self.text_count,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_content_text_utf32_t) ContentTextUtf32 {
        return .{
            .text = @ptrCast(skb.text),
            .text_count = skb.text_count,
        };
    }

    pub fn fromSlice(slice: []const u32) ContentTextUtf32 {
        return .{
            .text = @ptrCast(slice.ptr),
            .text_count = @intCast(slice.len),
        };
    }
};

pub const ContentObject = extern struct {
    width: f32 = 0,
    height: f32 = 0,
    data: isize = 0,

    pub fn toSkb(self: ContentObject) raw.struct_skb_content_object_t {
        return .{
            .width = self.width,
            .height = self.height,
            .data = self.data,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_content_object_t) ContentObject {
        return .{
            .width = skb.width,
            .height = skb.height,
            .data = skb.data,
        };
    }
};

pub const ContentIcon = extern struct {
    width: f32 = 0,
    height: f32 = 0,
    icon_handle: IconHandle = .none,

    pub fn toSkb(self: ContentIcon) raw.struct_skb_content_icon_t {
        return .{
            .width = self.width,
            .height = self.height,
            .icon_handle = @intFromEnum(self.icon_handle),
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_content_icon_t) ContentIcon {
        return .{
            .width = skb.width,
            .height = skb.height,
            .icon_handle = @enumFromInt(skb.icon_handle),
        };
    }
};

pub const ContentRunType = enum(c_uint) {
    utf8 = raw.SKB_CONTENT_RUN_UTF8,
    utf32 = raw.SKB_CONTENT_RUN_UTF32,
    object = raw.SKB_CONTENT_RUN_OBJECT,
    icon = raw.SKB_CONTENT_RUN_ICON,
};

pub const Content = extern union {
    utf8: ContentTextUtf8,
    utf32: ContentTextUtf32,
    object: ContentObject,
    icon: ContentIcon,
};

pub const ContentRun = extern struct {
    content: Content,
    run_id: isize,
    attributes: AttributeSet,
    type_: ContentRunType,

    pub fn makeUtf8(text: []const u8, attributes: AttributeSet, run_id: isize) ContentRun {
        return @bitCast(raw.skb_content_run_make_utf8(
            @ptrCast(text.ptr),
            @intCast(text.len),
            @bitCast(attributes),
            run_id,
        ));
    }

    pub fn makeUtf32(text: []const u32, attributes: AttributeSet, run_id: isize) ContentRun {
        return @bitCast(raw.skb_content_run_make_utf32(
            @ptrCast(text.ptr),
            @intCast(text.len),
            @bitCast(attributes),
            run_id,
        ));
    }

    pub fn makeObject(data: isize, width: f32, height: f32, attributes: AttributeSet, run_id: isize) ContentRun {
        return @bitCast(raw.skb_content_run_make_object(
            data,
            width,
            height,
            @bitCast(attributes),
            run_id,
        ));
    }

    pub fn makeIcon(icon_handle: IconHandle, width: f32, height: f32, attributes: AttributeSet, run_id: isize) ContentRun {
        return @bitCast(raw.skb_content_run_make_icon(
            @intFromEnum(icon_handle),
            width,
            height,
            @bitCast(attributes),
            run_id,
        ));
    }
};

pub const LayoutLineFlags = packed struct(c_uint) {
    is_truncated: bool = false,
    _: u31 = undefined,
};

pub const LayoutLine = extern struct {
    text_range: Range,
    layout_run_range: Range,
    decorations_range: Range,
    last_grapheme_offset: i32,
    ascender: f32,
    descender: f32,
    baseline: f32,
    bounds: Rect2,
    culling_bounds: Rect2,
    common_glyph_bounds: Rect2,
    flags: LayoutLineFlags,

    pub fn toSkb(self: LayoutLine) raw.struct_skb_layout_line_t {
        return .{
            .text_range = self.text_range.toSkb(),
            .layout_run_range = self.layout_run_range.toSkb(),
            .decorations_range = self.decorations_range.toSkb(),
            .last_grapheme_offset = self.last_grapheme_offset,
            .ascender = self.ascender,
            .descender = self.descender,
            .baseline = self.baseline,
            .bounds = self.bounds.toSkb(),
            .culling_bounds = self.culling_bounds.toSkb(),
            .common_glyph_bounds = self.common_glyph_bounds.toSkb(),
            .flags = @bitCast(self.flags),
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_layout_line_t) LayoutLine {
        return .{
            .text_range = .fromSkb(skb.text_range),
            .layout_run_range = .fromSkb(skb.layout_run_range),
            .decorations_range = .fromSkb(skb.decorations_range),
            .last_grapheme_offset = skb.last_grapheme_offset,
            .ascender = skb.ascender,
            .descender = skb.descender,
            .baseline = skb.baseline,
            .bounds = .fromSkb(skb.bounds),
            .culling_bounds = .fromSkb(skb.culling_bounds),
            .common_glyph_bounds = .fromSkb(skb.common_glyph_bounds),
            .flags = @bitCast(skb.flags),
        };
    }
};

pub const LayoutRunData = extern union {
    font_handle: FontHandle,
    object_data: isize,
    icon_handle: IconHandle,
};

pub const LayoutRun = extern struct {
    type: u8,
    direction: u8,
    script: Script,
    bidi_level: u8,
    content_run_idx: i32,
    glyph_range: Range,
    cluster_range: Range,
    bounds: Rect2,
    ref_baseline: f32,
    font_size: f32,
    attributes: AttributeSet,
    content_run_id: isize,
    data: LayoutRunData,
};

pub const Cluster = extern struct {
    text_offset: i32,
    glyphs_offset: i32,
    text_count: u8,
    glyphs_count: u8,

    pub fn toSkb(self: Cluster) raw.struct_skb_cluster_t {
        return .{
            .text_offset = self.text_offset,
            .glyphs_offset = self.glyphs_offset,
            .text_count = self.text_count,
            .glyphs_count = self.glyphs_count,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_cluster_t) Cluster {
        return .{
            .text_offset = skb.text_offset,
            .glyphs_offset = skb.glyphs_offset,
            .text_count = skb.text_count,
            .glyphs_count = skb.glyphs_count,
        };
    }
};

pub const Glyph = extern struct {
    offset_x: f32,
    offset_y: f32,
    advance_x: f32,
    cluster_idx: i32,
    gid: u16,

    pub fn toSkb(self: Glyph) raw.struct_skb_glyph_t {
        return .{
            .offset_x = self.offset_x,
            .offset_y = self.offset_y,
            .advance_x = self.advance_x,
            .cluster_idx = self.cluster_idx,
            .gid = self.gid,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_glyph_t) Glyph {
        return .{
            .offset_x = skb.offset_x,
            .offset_y = skb.offset_y,
            .advance_x = skb.advance_x,
            .cluster_idx = skb.cluster_idx,
            .gid = skb.gid,
        };
    }
};

pub const Decoration = extern struct {
    layout_run_idx: i32,
    glyph_range: Range,
    offset_x: f32,
    offset_y: f32,
    length: f32,
    pattern_offset: f32,
    thickness: f32,
    color: Color = .rgba(0, 0, 0, 255),
    position: u8 = 0,
    style: u8 = 0,
};

pub const TextProp = packed struct(u8) {
    grapheme_break: bool = false,
    word_break: bool = false,
    must_line_break: bool = false,
    allow_line_break: bool = false,
    emoji: bool = false,
    control: bool = false,
    whitespace: bool = false,
    punctuation: bool = false,
};

pub const TextProperty = extern struct {
    flags: TextProp,
    script: Script,
};

pub const Layout = opaque {
    pub fn create(params: *const LayoutParams) std.mem.Allocator.Error!*Layout {
        return @ptrCast(raw.skb_layout_create(@ptrCast(params)) orelse return error.OutOfMemory);
    }

    pub fn createUtf8(
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        text: []const u8,
        attributes: AttributeSet,
    ) std.mem.Allocator.Error!*Layout {
        return @ptrCast(raw.skb_layout_create_utf8(
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text.ptr),
            @intCast(text.len),
            @bitCast(attributes),
        ) orelse return error.OutOfMemory);
    }

    pub fn createUtf32(
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        text: []const u32,
        attributes: AttributeSet,
    ) std.mem.Allocator.Error!*Layout {
        return @ptrCast(raw.skb_layout_create_utf32(
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text.ptr),
            @intCast(text.len),
            @bitCast(attributes),
        ) orelse return error.OutOfMemory);
    }

    pub fn createFromRuns(
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        runs: []const ContentRun,
    ) std.mem.Allocator.Error!*Layout {
        return @ptrCast(raw.skb_layout_create_from_runs(
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(runs.ptr),
            @intCast(runs.len),
        ) orelse return error.OutOfMemory);
    }

    pub fn createFromText(
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        text: ?*const Text,
        attributes: AttributeSet,
    ) std.mem.Allocator.Error!*Layout {
        return @ptrCast(raw.skb_layout_create_from_text(
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text),
            @bitCast(attributes),
        ) orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *Layout) void {
        raw.skb_layout_destroy(@ptrCast(self));
    }

    pub fn setUtf8(self: *Layout, temp_alloc: *TempAlloc, params: *const LayoutParams, text: []const u8, attributes: AttributeSet) void {
        raw.skb_layout_set_utf8(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text.ptr),
            @intCast(text.len),
            @bitCast(attributes),
        );
    }

    pub fn setUtf32(self: *Layout, temp_alloc: *TempAlloc, params: *const LayoutParams, text: []const u32, attributes: AttributeSet) void {
        raw.skb_layout_set_utf32(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text.ptr),
            @intCast(text.len),
            @bitCast(attributes),
        );
    }

    pub fn setFromRuns(self: *Layout, temp_alloc: *TempAlloc, params: *const LayoutParams, runs: []const ContentRun) void {
        raw.skb_layout_set_from_runs(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(runs.ptr),
            @intCast(runs.len),
        );
    }

    pub fn setFromText(self: *Layout, temp_alloc: *TempAlloc, params: *const LayoutParams, text: *const Text, attributes: AttributeSet) void {
        raw.skb_layout_set_from_text(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text),
            @bitCast(attributes),
        );
    }

    pub fn reset(self: *Layout) void {
        raw.skb_layout_reset(@ptrCast(self));
    }

    pub fn getParams(self: *const Layout) *const LayoutParams {
        return @ptrCast(raw.skb_layout_get_params(@ptrCast(self)));
    }

    pub fn getTextCount(self: *const Layout) usize {
        return @intCast(raw.skb_layout_get_text_count(@ptrCast(self)));
    }

    pub fn getText(self: *const Layout) ?[*]const u32 {
        const ptr = raw.skb_layout_get_text(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getTextSlice(self: *const Layout) []const u32 {
        const count = self.getTextCount();
        const ptr = self.getText() orelse return &.{};
        return ptr[0..count];
    }

    pub fn getTextProperties(self: *const Layout) *const TextProperty {
        return @ptrCast(raw.skb_layout_get_text_properties(@ptrCast(self)));
    }

    pub fn getLayoutRunsCount(self: *const Layout) usize {
        return @intCast(raw.skb_layout_get_layout_runs_count(@ptrCast(self)));
    }

    pub fn getLayoutRuns(self: *const Layout) ?[*]const LayoutRun {
        const ptr = raw.skb_layout_get_layout_runs(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getLayoutRunsSlice(self: *const Layout) []const LayoutRun {
        const count = self.getLayoutRunsCount();
        const ptr = self.getLayoutRuns() orelse return &.{};
        return ptr[0..count];
    }

    pub fn getGlyphsCount(self: *const Layout) usize {
        return @intCast(raw.skb_layout_get_glyphs_count(@ptrCast(self)));
    }

    pub fn getGlyphs(self: *const Layout) ?[*]const Glyph {
        const ptr = raw.skb_layout_get_glyphs(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getGlyphsSlice(self: *const Layout) []const Glyph {
        const count = self.getGlyphsCount();
        const ptr = self.getGlyphs() orelse return &.{};
        return ptr[0..count];
    }

    pub fn getClustersCount(self: *const Layout) usize {
        return @intCast(raw.skb_layout_get_clusters_count(@ptrCast(self)));
    }

    pub fn getClusters(self: *const Layout) ?[*]const Cluster {
        const ptr = raw.skb_layout_get_clusters(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getClustersSlice(self: *const Layout) []const Cluster {
        const count = self.getClustersCount();
        const ptr = self.getClusters() orelse return &.{};
        return ptr[0..count];
    }

    pub fn getDecorationsCount(self: *const Layout) usize {
        return @intCast(raw.skb_layout_get_decorations_count(@ptrCast(self)));
    }

    pub fn getDecorations(self: *const Layout) ?[*]const Decoration {
        const ptr = raw.skb_layout_get_decorations(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getDecorationsSlice(self: *const Layout) []const Decoration {
        const count = self.getDecorationsCount();
        const ptr = self.getDecorations() orelse return &.{};
        return ptr[0..count];
    }

    pub fn getLinesCount(self: *const Layout) usize {
        return @intCast(raw.skb_layout_get_lines_count(@ptrCast(self)));
    }

    pub fn getLines(self: *const Layout) ?[*]const LayoutLine {
        const ptr = raw.skb_layout_get_lines(@ptrCast(self));
        if (ptr == null) return null;
        return @ptrCast(ptr);
    }

    pub fn getLinesSlice(self: *const Layout) []const LayoutLine {
        const count = self.getLinesCount();
        const ptr = self.getLines() orelse return &.{};
        return ptr[0..count];
    }

    pub fn getBounds(self: *const Layout) Rect2 {
        return .fromSkb(raw.skb_layout_get_bounds(@ptrCast(self)));
    }

    pub fn getResolvedDirection(self: *const Layout) TextDirection {
        return @enumFromInt(raw.skb_layout_get_resolved_direction(@ptrCast(self)));
    }

    pub fn nextGraphemeOffset(self: *const Layout, offset: i32) i32 {
        return @intCast(raw.skb_layout_next_grapheme_offset(@ptrCast(self), @intCast(offset)));
    }

    pub fn prevGraphemeOffset(self: *const Layout, offset: i32) i32 {
        return @intCast(raw.skb_layout_prev_grapheme_offset(@ptrCast(self), @intCast(offset)));
    }

    pub fn alignGraphemeOffset(self: *const Layout, offset: i32) i32 {
        return @intCast(raw.skb_layout_align_grapheme_offset(@ptrCast(self), @intCast(offset)));
    }

    pub fn getLineIndex(self: *const Layout, pos: TextPosition) i32 {
        return raw.skb_layout_get_line_index(@ptrCast(self), pos.toSkb());
    }

    pub fn getTextOffset(self: *const Layout, pos: TextPosition) i32 {
        return raw.skb_layout_get_text_offset(@ptrCast(self), pos.toSkb());
    }

    pub fn getTextDirectionAt(self: *const Layout, pos: TextPosition) TextDirection {
        return @enumFromInt(raw.skb_layout_get_text_direction_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn hitTestAtLine(self: *const Layout, type_: MovementType, line_idx: i32, hit_x: f32) TextPosition {
        return .fromSkb(raw.skb_layout_hit_test_at_line(@ptrCast(self), @intFromEnum(type_), line_idx, hit_x));
    }

    pub fn hitTest(self: *const Layout, type_: MovementType, hit_x: f32, hit_y: f32) TextPosition {
        return .fromSkb(raw.skb_layout_hit_test(@ptrCast(self), @intFromEnum(type_), hit_x, hit_y));
    }

    pub fn hitTestContentAtLine(self: *const Layout, line_idx: i32, hit_x: f32) LayoutContentHit {
        return @bitCast(raw.skb_layout_hit_test_content_at_line(@ptrCast(self), line_idx, hit_x));
    }

    pub fn hitTestContent(self: *const Layout, hit_x: f32, hit_y: f32) LayoutContentHit {
        return @bitCast(raw.skb_layout_hit_test_content(@ptrCast(self), hit_x, hit_y));
    }

    pub fn getContentBoundsAtLine(self: *const Layout, line_idx: i32, run_id: isize, callback: *const ContentRectFunc, context: ?*anyopaque) void {
        raw.skb_layout_get_content_bounds_at_line(@ptrCast(self), line_idx, run_id, @ptrCast(callback), context);
    }

    pub fn getContentBounds(self: *const Layout, run_id: isize, callback: *const ContentRectFunc, context: ?*anyopaque) void {
        raw.skb_layout_get_content_bounds(@ptrCast(self), run_id, @ptrCast(callback), context);
    }

    pub fn getVisualCaretAtLine(self: *const Layout, line_idx: i32, pos: TextPosition) VisualCaret {
        return @bitCast(raw.skb_layout_get_visual_caret_at_line(@ptrCast(self), line_idx, pos.toSkb()));
    }

    pub fn getVisualCaretAt(self: *const Layout, pos: TextPosition) VisualCaret {
        return @bitCast(raw.skb_layout_get_visual_caret_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn getLineStartAt(self: *const Layout, pos: TextPosition) TextPosition {
        return .fromSkb(raw.skb_layout_get_line_start_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn getLineEndAt(self: *const Layout, pos: TextPosition) TextPosition {
        return .fromSkb(raw.skb_layout_get_line_end_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn getWordStartAt(self: *const Layout, pos: TextPosition) TextPosition {
        return .fromSkb(raw.skb_layout_get_word_start_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn getWordEndAt(self: *const Layout, pos: TextPosition) TextPosition {
        return .fromSkb(raw.skb_layout_get_word_end_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn getSelectionOrderedStart(self: *const Layout, selection: TextSelection) TextPosition {
        return .fromSkb(raw.skb_layout_get_selection_ordered_start(@ptrCast(self), @intFromEnum(selection)));
    }

    pub fn getSelectionOrderedEnd(self: *const Layout, selection: TextSelection) TextPosition {
        return .fromSkb(raw.skb_layout_get_selection_ordered_end(@ptrCast(self), @intFromEnum(selection)));
    }

    pub fn getSelectionTextOffsetRange(self: *const Layout, selection: TextSelection) Range {
        return .fromSkb(raw.skb_layout_get_selection_text_offset_range(@ptrCast(self), @intFromEnum(selection)));
    }

    pub fn getSelectionCount(self: *const Layout, selection: TextSelection) i32 {
        return raw.skb_layout_get_selection_count(@ptrCast(self), @intFromEnum(selection));
    }

    pub fn getSelectionBounds(
        self: *const Layout,
        selection: TextSelection,
        callback: *const SelectionRectFunc,
        context: ?*anyopaque,
    ) void {
        raw.skb_layout_get_selection_bounds(
            @ptrCast(self),
            @intFromEnum(selection),
            @ptrCast(callback),
            context,
        );
    }

    pub fn getSelectionBoundsWithOffset(
        self: *const Layout,
        offset_y: f32,
        selection: TextSelection,
        callback: *const SelectionRectFunc,
        context: ?*anyopaque,
    ) void {
        raw.skb_layout_get_selection_bounds_with_offset(
            @ptrCast(self),
            offset_y,
            @intFromEnum(selection),
            @ptrCast(callback),
            context,
        );
    }
};

pub const VisualCaret = extern struct {
    x: f32,
    y: f32,
    ascender: f32,
    descender: f32,
    slope: f32,
    direction: u8,
};

pub const MovementType = enum(c_uint) {
    caret = raw.SKB_MOVEMENT_CARET,
    selection = raw.SKB_MOVEMENT_SELECTION,
};

pub const LayoutContentHit = extern struct {
    run_id: isize,
    line_idx: i32,
    layout_run_idx: i32,
};

pub const ContentRectFunc = fn (rect: Rect2, layout_run_idx: i32, line_idx: i32, context: ?*anyopaque) callconv(.c) void;
pub const SelectionRectFunc = fn (rect: Rect2, context: ?*anyopaque) callconv(.c) void;

// TODO: pub extern fn skb_layout_params_hash_append(hash: u64, params: [*c]const skb_layout_params_t) u64;

pub const CaretIteratorResult = extern struct {
    text_position: TextPosition = .zero,
    layout_run_idx: i32 = 0,
    glyph_idx: i32 = 0,
    cluster_idx: i32 = 0,
    direction: u8 = 0,
};

pub const CaretIterator = extern struct {
    layout: ?*const Layout = null,
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
    pending_left: CaretIteratorResult = .{},

    pub fn create(layout: *const Layout, line_idx: i32) CaretIterator {
        return @bitCast(raw.skb_caret_iterator_make(@ptrCast(layout), line_idx));
    }

    pub fn next(self: *CaretIterator, x: *f32, advance: *f32, left: *CaretIteratorResult, right: *CaretIteratorResult) bool {
        return raw.skb_caret_iterator_next(
            @ptrCast(self),
            @ptrCast(x),
            @ptrCast(advance),
            @ptrCast(left),
            @ptrCast(right),
        );
    }
};

pub const Iso15924Tag = u32;

pub fn defineIso15924TagString(tag: []const u8) Iso15924Tag {
    if (tag.len != 4) @panic("ISO 15924 tag must be exactly 4 characters long");
    return defineIso15924Tag(tag[0..4].*);
}

pub fn defineIso15924Tag(arr: [4]u8) Iso15924Tag {
    const a = arr[0];
    const b = arr[1];
    const c = arr[2];
    const d = arr[3];
    return (@as(u32, a) << 24) | (@as(u32, b) << 16) | (@as(u32, c) << 8) | @as(u32, d);
}

pub const Script = enum(u8) {
    none = 0,
    _,

    pub fn toIso15924Tag(self: Script) Iso15924Tag {
        return raw.skb_script_to_iso15924_tag(@intFromEnum(self));
    }

    pub fn fromIso15924Tag(tag: Iso15924Tag) Script {
        const script = raw.skb_script_from_iso15924_tag(tag);
        return @enumFromInt(script);
    }
};

pub const RichText = opaque {
    pub fn create() std.mem.Allocator.Error!*RichText {
        return @ptrCast(raw.skb_rich_text_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *RichText) void {
        raw.skb_rich_text_destroy(@ptrCast(self));
    }

    pub fn reset(self: *RichText) void {
        raw.skb_rich_text_reset(@ptrCast(self));
    }

    pub fn getUtf32Count(self: *const RichText) i32 {
        return raw.skb_rich_text_get_utf32_count(@ptrCast(self));
    }

    pub fn getRangeUtf8Count(self: *const RichText, text_range: Range) i32 {
        return raw.skb_rich_text_get_range_utf8_count(@ptrCast(self), text_range.toSkb());
    }

    pub fn getRangeUtf8(self: *const RichText, text_range: Range, utf8: []u8) i32 {
        return raw.skb_rich_text_get_range_utf8(
            @ptrCast(self),
            text_range.toSkb(),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
        );
    }

    pub fn getRangeUtf32Count(self: *const RichText, text_range: Range) i32 {
        return raw.skb_rich_text_get_range_utf32_count(@ptrCast(self), text_range.toSkb());
    }

    pub fn getRangeUtf32(self: *const RichText, text_range: Range, utf32: []u32) i32 {
        return raw.skb_rich_text_get_range_utf32(
            @ptrCast(self),
            text_range.toSkb(),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
        );
    }

    pub fn getParagraphsCount(self: *const RichText) i32 {
        return raw.skb_rich_text_get_paragraphs_count(@ptrCast(self));
    }

    pub fn getParagraphText(self: *const RichText, index: i32) ?*const Text {
        return @ptrCast(raw.skb_rich_text_get_paragraph_text(@ptrCast(self), index));
    }

    pub fn getParagraphAttributes(self: *const RichText, index: i32) AttributeSet {
        return @bitCast(raw.skb_rich_text_get_paragraph_attributes(@ptrCast(self), index));
    }

    pub fn getParagraphTextUtf32Count(self: *const RichText, index: i32) i32 {
        return raw.skb_rich_text_get_paragraph_text_utf32_count(@ptrCast(self), index);
    }

    pub fn getParagraphTextOffset(self: *const RichText, index: i32) i32 {
        return raw.skb_rich_text_get_paragraph_text_offset(@ptrCast(self), index);
    }

    pub fn getParagraphVersion(self: *const RichText, index: i32) u32 {
        return raw.skb_rich_text_get_paragraph_version(@ptrCast(self), index);
    }

    pub fn append(self: *RichText, source_rich_text: *const RichText) RichTextChange {
        return .fromSkb(raw.skb_rich_text_append(@ptrCast(self), @ptrCast(source_rich_text)));
    }

    pub fn appendRange(self: *RichText, source_rich_text: *const RichText, source_text_range: Range) RichTextChange {
        return .fromSkb(raw.skb_rich_text_append_range(
            @ptrCast(self),
            @ptrCast(source_rich_text),
            source_text_range.toSkb(),
        ));
    }

    pub fn addParagraph(self: *RichText, paragraph_attributes: AttributeSet) RichTextChange {
        return .fromSkb(raw.skb_rich_text_add_paragraph(@ptrCast(self), @bitCast(paragraph_attributes)));
    }

    pub fn appendText(self: *RichText, temp_alloc: *TempAlloc, from_text: *const Text) RichTextChange {
        return .fromSkb(raw.skb_rich_text_append_text(@ptrCast(self), @ptrCast(temp_alloc), @ptrCast(from_text)));
    }

    pub fn appendTextRange(self: *RichText, temp_alloc: *TempAlloc, from_text: *const Text, from_range: Range) RichTextChange {
        return .fromSkb(raw.skb_rich_text_append_text_range(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(from_text),
            from_range.toSkb(),
        ));
    }

    pub fn appendUtf8(self: *RichText, temp_alloc: *TempAlloc, utf8: []const u8, attributes: AttributeSet) RichTextChange {
        return .fromSkb(raw.skb_rich_text_append_utf8(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
            @bitCast(attributes),
        ));
    }

    pub fn appendUtf32(self: *RichText, temp_alloc: *TempAlloc, utf32: []const u32, attributes: AttributeSet) RichTextChange {
        return .fromSkb(raw.skb_rich_text_append_utf32(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
            @bitCast(attributes),
        ));
    }

    pub fn replace(self: *RichText, text_range: Range, source_rich_text: *const RichText) RichTextChange {
        return .fromSkb(raw.skb_rich_text_replace(
            @ptrCast(self),
            text_range.toSkb(),
            @ptrCast(source_rich_text),
        ));
    }

    pub fn replaceRange(self: *RichText, text_range: Range, source_rich_text: *const RichText, source_text_range: Range) RichTextChange {
        return .fromSkb(raw.skb_rich_text_replace_range(
            @ptrCast(self),
            text_range.toSkb(),
            @ptrCast(source_rich_text),
            source_text_range.toSkb(),
        ));
    }

    pub fn setAttribute(self: *RichText, text_range: Range, attribute: Attribute) void {
        raw.skb_rich_text_set_attribute(@ptrCast(self), text_range.toSkb(), @bitCast(attribute));
    }

    pub fn clearAttribute(self: *RichText, text_range: Range, attribute: Attribute) void {
        raw.skb_rich_text_clear_attribute(@ptrCast(self), text_range.toSkb(), @bitCast(attribute));
    }

    pub fn clearAllAttributes(self: *RichText, text_range: Range) void {
        raw.skb_rich_text_clear_all_attributes(@ptrCast(self), text_range.toSkb());
    }

    pub fn getAttributeCount(self: *const RichText, text_range: Range, attribute_kind: AttributeType) i32 {
        return raw.skb_rich_text_get_attribute_count(
            @ptrCast(self),
            text_range.toSkb(),
            attribute_kind,
        );
    }

    pub fn removeIf(self: *RichText, filter_func: ?*const RichTextRemoveFunc, context: ?*anyopaque) void {
        raw.skb_rich_text_remove_if(@ptrCast(self), @ptrCast(filter_func), context);
    }
};

pub const RichTextChange = extern struct {
    start_paragraph_idx: i32,
    removed_paragraph_count: i32,
    inserted_paragraph_count: i32,
    edit_end_position: TextPosition,

    pub fn toSkb(self: RichTextChange) raw.struct_skb_rich_text_change_t {
        return .{
            .start_paragraph_idx = self.start_paragraph_idx,
            .removed_paragraph_count = self.removed_paragraph_count,
            .inserted_paragraph_count = self.inserted_paragraph_count,
            .edit_end_position = self.edit_end_position.toSkb(),
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_rich_text_change_t) RichTextChange {
        return .{
            .start_paragraph_idx = skb.start_paragraph_idx,
            .removed_paragraph_count = skb.removed_paragraph_count,
            .inserted_paragraph_count = skb.inserted_paragraph_count,
            .edit_end_position = .fromSkb(skb.edit_end_position),
        };
    }
};

pub const RichTextRemoveFunc = fn (codepoint: u32, paragraph_idx: i32, text_offset: i32, context: ?*anyopaque) callconv(.c) bool;

pub const Editor = opaque {
    pub fn create(params: *const EditorParams) std.mem.Allocator.Error!*Editor {
        return @ptrCast(raw.skb_editor_create(@ptrCast(params)) orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *Editor) void {
        raw.skb_editor_destroy(@ptrCast(self));
    }

    pub fn reset(self: *Editor, params: *const EditorParams) void {
        raw.skb_editor_reset(@ptrCast(self), @ptrCast(params));
    }

    pub fn setOnChangeCallback(self: *Editor, on_change_func: ?*const EditorOnChangeFunc, context: ?*anyopaque) void {
        raw.skb_editor_set_on_change_callback(@ptrCast(self), @ptrCast(on_change_func), context);
    }

    pub fn setInputFilterCallback(self: *Editor, filter_func: ?*const EditorInputFilterFunc, context: ?*anyopaque) void {
        raw.skb_editor_set_input_filter_callback(@ptrCast(self), @ptrCast(filter_func), context);
    }

    pub fn setTextUtf8(self: *Editor, temp_alloc: *TempAlloc, utf8: []const u8) void {
        raw.skb_editor_set_text_utf8(@ptrCast(self), @ptrCast(temp_alloc), @ptrCast(utf8.ptr), @intCast(utf8.len));
    }

    pub fn setTextUtf32(self: *Editor, temp_alloc: *TempAlloc, utf32: []const u32) void {
        raw.skb_editor_set_text_utf32(@ptrCast(self), @ptrCast(temp_alloc), @ptrCast(utf32.ptr), @intCast(utf32.len));
    }

    pub fn setText(self: *Editor, temp_alloc: *TempAlloc, text: ?*const Text) void {
        raw.skb_editor_set_text(@ptrCast(self), @ptrCast(temp_alloc), @ptrCast(text));
    }

    pub fn getTextUtf8Count(self: *const Editor) i32 {
        return raw.skb_editor_get_text_utf8_count(@ptrCast(self));
    }

    pub fn getTextUtf8(self: *const Editor, utf8: []u8) i32 {
        return raw.skb_editor_get_text_utf8(
            @ptrCast(self),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
        );
    }

    pub fn getTextUtf32Count(self: *const Editor) i32 {
        return raw.skb_editor_get_text_utf32_count(@ptrCast(self));
    }

    pub fn getTextUtf32(self: *const Editor, utf32: []u32) i32 {
        return raw.skb_editor_get_text_utf32(
            @ptrCast(self),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
        );
    }

    pub fn getText(self: *const Editor) ?*const Text {
        return @ptrCast(raw.skb_editor_get_text(@ptrCast(self)));
    }

    pub fn getParagraphCount(self: *const Editor) i32 {
        return raw.skb_editor_get_paragraph_count(@ptrCast(self));
    }

    pub fn getParagraphLayout(self: *const Editor, index: i32) ?*const Layout {
        return @ptrCast(raw.skb_editor_get_paragraph_layout(@ptrCast(self), index));
    }

    pub fn getParagraphOffsetY(self: *const Editor, index: i32) f32 {
        return raw.skb_editor_get_paragraph_offset_y(@ptrCast(self), index);
    }

    pub fn getParagraphText(self: *const Editor, index: i32) ?*const Text {
        return @ptrCast(raw.skb_editor_get_paragraph_text(@ptrCast(self), index));
    }

    pub fn getParagraphTextOffset(self: *const Editor, index: i32) i32 {
        return raw.skb_editor_get_paragraph_text_offset(@ptrCast(self), index);
    }

    pub fn getParams(self: *const Editor) *const EditorParams {
        return @ptrCast(raw.skb_editor_get_params(@ptrCast(self)));
    }

    pub fn getLineIndexAt(self: *const Editor, pos: TextPosition) i32 {
        return raw.skb_editor_get_line_index_at(@ptrCast(self), pos.toSkb());
    }

    pub fn getColumnIndexAt(self: *const Editor, pos: TextPosition) i32 {
        return raw.skb_editor_get_column_index_at(@ptrCast(self), pos.toSkb());
    }

    pub fn getTextOffsetAt(self: *const Editor, pos: TextPosition) i32 {
        return raw.skb_editor_get_text_offset_at(@ptrCast(self), pos.toSkb());
    }

    pub fn getTextDirectionAt(self: *const Editor, pos: TextPosition) TextDirection {
        return @enumFromInt(raw.skb_editor_get_text_direction_at(@ptrCast(self), pos.toSkb()));
    }

    pub fn getVisualCaret(self: *const Editor, pos: TextPosition) VisualCaret {
        return @bitCast(raw.skb_editor_get_visual_caret(@ptrCast(self), pos.toSkb()));
    }

    pub fn hitTest(self: *const Editor, type_: MovementType, hit_x: f32, hit_y: f32) TextPosition {
        return .fromSkb(raw.skb_editor_hit_test(@ptrCast(self), @intFromEnum(type_), hit_x, hit_y));
    }

    pub fn selectAll(self: *Editor) void {
        raw.skb_editor_select_all(@ptrCast(self));
    }

    pub fn selectNone(self: *Editor) void {
        raw.skb_editor_select_none(@ptrCast(self));
    }

    pub fn select(self: *Editor, selection: TextSelection) void {
        raw.skb_editor_select(@ptrCast(self), @intFromEnum(selection));
    }

    pub fn getCurrentSelection(self: *const Editor) TextSelection {
        return @enumFromInt(raw.skb_editor_get_current_selection(@ptrCast(self)));
    }

    pub fn getSelectionTextOffsetRange(self: *const Editor, selection: TextSelection) Range {
        return .fromSkb(raw.skb_editor_get_selection_text_offset_range(@ptrCast(self), @intFromEnum(selection)));
    }

    pub fn getSelectionCount(self: *const Editor, selection: TextSelection) i32 {
        return raw.skb_editor_get_selection_count(@ptrCast(self), @intFromEnum(selection));
    }

    pub fn getSelectionBounds(self: *const Editor, selection: TextSelection, callback: *const SelectionRectFunc, context: ?*anyopaque) void {
        raw.skb_editor_get_selection_bounds(
            @ptrCast(self),
            @intFromEnum(selection),
            @ptrCast(callback),
            context,
        );
    }

    pub fn getSelectionTextUtf8Count(self: *const Editor, selection: TextSelection) i32 {
        return raw.skb_editor_get_selection_text_utf8_count(@ptrCast(self), @intFromEnum(selection));
    }

    pub fn getSelectionTextUtf8(self: *const Editor, selection: TextSelection, utf8: []u8) i32 {
        return raw.skb_editor_get_selection_text_utf8(
            @ptrCast(self),
            @intFromEnum(selection),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
        );
    }

    pub fn getSelectionTextUtf32Count(self: *const Editor, selection: TextSelection) i32 {
        return raw.skb_editor_get_selection_text_utf32_count(@ptrCast(self), @intFromEnum(selection));
    }

    pub fn getSelectionTextUtf32(self: *const Editor, selection: TextSelection, utf32: []u32) i32 {
        return raw.skb_editor_get_selection_text_utf32(
            @ptrCast(self),
            @intFromEnum(selection),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
        );
    }

    pub fn getSelectionRichText(self: *const Editor, selection: TextSelection) ?*const RichText {
        return @ptrCast(raw.skb_editor_get_selection_rich_text(@ptrCast(self), @intFromEnum(selection)));
    }

    pub fn processMouseClick(self: *Editor, x: f32, y: f32, mods: u32, time: f64) void {
        raw.skb_editor_process_mouse_click(@ptrCast(self), x, y, mods, time);
    }

    pub fn processMouseDrag(self: *Editor, x: f32, y: f32) void {
        raw.skb_editor_process_mouse_drag(@ptrCast(self), x, y);
    }

    pub fn processKeyPressed(self: *Editor, temp_alloc: *TempAlloc, key: EditorKey, mods: u32) void {
        raw.skb_editor_process_key_pressed(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @intFromEnum(key),
            mods,
        );
    }

    pub fn insertCodepoint(self: *Editor, temp_alloc: *TempAlloc, codepoint: u32) void {
        raw.skb_editor_insert_codepoint(@ptrCast(self), @ptrCast(temp_alloc), codepoint);
    }

    pub fn pasteUtf8(self: *Editor, temp_alloc: *TempAlloc, utf8: []const u8) void {
        raw.skb_editor_paste_utf8(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(utf8.ptr),
            @intCast(utf8.len),
        );
    }

    pub fn pasteUtf32(self: *Editor, temp_alloc: *TempAlloc, utf32: []const u32) void {
        raw.skb_editor_paste_utf32(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
        );
    }

    pub fn pasteText(self: *Editor, temp_alloc: *TempAlloc, text: ?*const Text) void {
        raw.skb_editor_paste_text(@ptrCast(self), @ptrCast(temp_alloc), @ptrCast(text));
    }

    pub fn pasteRichText(self: *Editor, temp_alloc: *TempAlloc, rich_text: ?*const RichText) void {
        raw.skb_editor_paste_rich_text(@ptrCast(self), @ptrCast(temp_alloc), @ptrCast(rich_text));
    }

    pub fn cut(self: *Editor, temp_alloc: *TempAlloc) void {
        raw.skb_editor_cut(@ptrCast(self), @ptrCast(temp_alloc));
    }

    pub fn toggleAttribute(self: *Editor, temp_alloc: *TempAlloc, attribute: Attribute) void {
        raw.skb_editor_toggle_attribute(@ptrCast(self), @ptrCast(temp_alloc), @bitCast(attribute));
    }

    pub fn applyAttribute(self: *Editor, temp_alloc: *TempAlloc, attribute: Attribute) void {
        raw.skb_editor_apply_attribute(@ptrCast(self), @ptrCast(temp_alloc), @bitCast(attribute));
    }

    pub fn setAttribute(self: *Editor, temp_alloc: *TempAlloc, selection: TextSelection, attribute: Attribute) void {
        raw.skb_editor_set_attribute(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @intFromEnum(selection),
            @bitCast(attribute),
        );
    }

    pub fn clearAttribute(self: *Editor, temp_alloc: *TempAlloc, selection: TextSelection, attribute: Attribute) void {
        raw.skb_editor_clear_attribute(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @intFromEnum(selection),
            @bitCast(attribute),
        );
    }

    pub fn clearAllAttributes(self: *Editor, temp_alloc: *TempAlloc, selection: TextSelection) void {
        raw.skb_editor_clear_all_attributes(@ptrCast(self), @ptrCast(temp_alloc), @intFromEnum(selection));
    }

    pub fn getAttributeCount(self: *const Editor, selection: TextSelection, attribute_kind: AttributeType) i32 {
        return raw.skb_editor_get_attribute_count(@ptrCast(self), @intFromEnum(selection), attribute_kind);
    }

    pub fn getActiveAttributesCount(self: *const Editor) i32 {
        return raw.skb_editor_get_active_attributes_count(@ptrCast(self));
    }

    pub fn getActiveAttributes(self: *const Editor) []const Attribute {
        const count = self.getActiveAttributesCount();
        const ptr = raw.skb_editor_get_active_attributes(@ptrCast(self)) orelse return &.{};
        return @ptrCast(ptr[0..count]);
    }

    pub fn canUndo(self: *const Editor) bool {
        return raw.skb_editor_can_undo(@ptrCast(self));
    }

    pub fn undo(self: *Editor, temp_alloc: *TempAlloc) void {
        raw.skb_editor_undo(@ptrCast(self), @ptrCast(temp_alloc));
    }

    pub fn canRedo(self: *const Editor) bool {
        return raw.skb_editor_can_redo(@ptrCast(self));
    }

    pub fn redo(self: *Editor, temp_alloc: *TempAlloc) void {
        raw.skb_editor_redo(@ptrCast(self), @ptrCast(temp_alloc));
    }

    pub fn setCompositionUtf32(self: *Editor, temp_alloc: *TempAlloc, utf32: []const u32, caret_position: i32) void {
        raw.skb_editor_set_composition_utf32(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
            caret_position,
        );
    }

    pub fn commitCompositionUtf32(self: *Editor, temp_alloc: *TempAlloc, utf32: []const u32) void {
        raw.skb_editor_commit_composition_utf32(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(utf32.ptr),
            @intCast(utf32.len),
        );
    }

    pub fn clearComposition(self: *Editor, temp_alloc: *TempAlloc) void {
        raw.skb_editor_clear_composition(@ptrCast(self), @ptrCast(temp_alloc));
    }
};

pub const EditorOnChangeFunc = fn (editor: ?*Editor, context: ?*anyopaque) callconv(.c) void;
pub const EditorInputFilterFunc = fn (editor: ?*Editor, input_text: ?*RichText, selection: TextSelection, context: ?*anyopaque) callconv(.c) void;

pub const EditorCaretMode = enum(c_uint) {
    skribidi = raw.SKB_CARET_MODE_SKRIBIDI,
    simple = raw.SKB_CARET_MODE_SIMPLE,
};

pub const EditorBehavior = enum(c_uint) {
    default = raw.SKB_BEHAVIOR_DEFAULT,
    macos = raw.SKB_BEHAVIOR_MACOS,
};

pub const EditorParams = extern struct {
    font_collection: ?*FontCollection = null,
    icon_collection: ?*IconCollection = null,
    attribute_collection: ?*AttributeCollection = null,
    editor_width: f32 = 0,
    layout_attributes: AttributeSet = @import("std").mem.zeroes(AttributeSet),
    text_attributes: AttributeSet = @import("std").mem.zeroes(AttributeSet),
    composition_attributes: AttributeSet = @import("std").mem.zeroes(AttributeSet),
    caret_mode: EditorCaretMode = .skribidi,
    editor_behavior: EditorBehavior = .default,
    max_undo_levels: i32 = 0,
};

pub const EditorKey = enum(c_uint) {
    none = raw.SKB_KEY_NONE,
    left = raw.SKB_KEY_LEFT,
    right = raw.SKB_KEY_RIGHT,
    up = raw.SKB_KEY_UP,
    down = raw.SKB_KEY_DOWN,
    home = raw.SKB_KEY_HOME,
    end = raw.SKB_KEY_END,
    backspace = raw.SKB_KEY_BACKSPACE,
    delete = raw.SKB_KEY_DELETE,
    enter = raw.SKB_KEY_ENTER,
};

pub const EditorKeyMod = packed struct(c_uint) {
    shift: bool = false,
    control: bool = false,
    option: bool = false,
    command: bool = false,

    _: u28 = 0,

    pub fn toInt(self: EditorKeyMod) c_uint {
        var result: c_uint = 0;
        if (self.shift) result |= raw.SKB_MOD_SHIFT;
        if (self.control) result |= raw.SKB_MOD_CONTROL;
        if (self.option) result |= raw.SKB_MOD_OPTION;
        if (self.command) result |= raw.SKB_MOD_COMMAND;
        return result;
    }

    pub fn fromInt(value: c_uint) EditorKeyMod {
        return .{
            .shift = (value & raw.SKB_MOD_SHIFT) != 0,
            .control = (value & raw.SKB_MOD_CONTROL) != 0,
            .option = (value & raw.SKB_MOD_OPTION) != 0,
            .command = (value & raw.SKB_MOD_COMMAND) != 0,
        };
    }
};

pub const Rasterizer = opaque {
    pub fn create(config: ?*const RasterizerConfig) std.mem.Allocator.Error!*Rasterizer {
        return @ptrCast(raw.skb_rasterizer_create(
            @constCast(if (config) |cfg| &cfg.toSkb() else null),
        ) orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *Rasterizer) void {
        raw.skb_rasterizer_destroy(@ptrCast(self));
    }

    pub fn getConfig(self: *const Rasterizer) RasterizerConfig {
        return RasterizerConfig.fromSkb(raw.skb_rasterizer_get_config(@ptrCast(self)));
    }

    pub fn getGlyphDimensions(self: *const Rasterizer, glyph_id: u32, font: *const Font, font_size: f32, padding: i32) Rect2i {
        return .fromSkb(raw.skb_rasterizer_get_glyph_dimensions(
            @ptrCast(self),
            glyph_id,
            @ptrCast(font),
            font_size,
            padding,
        ));
    }

    pub fn drawAlphaGlyph(
        self: *Rasterizer,
        temp_alloc: *TempAlloc,
        glyph_id: u32,
        font: *const Font,
        font_size: f32,
        alpha_mode: RasterizerAlphaMode,
        offset_x: f32,
        offset_y: f32,
        target: *Image,
    ) bool {
        return raw.skb_rasterizer_draw_alpha_glyph(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            glyph_id,
            @ptrCast(font),
            font_size,
            @intFromEnum(alpha_mode),
            offset_x,
            offset_y,
            @ptrCast(target),
        );
    }

    pub fn drawColorGlyph(
        self: *Rasterizer,
        temp_alloc: *TempAlloc,
        glyph_id: u32,
        font: *const Font,
        font_size: f32,
        alpha_mode: RasterizerAlphaMode,
        offset_x: f32,
        offset_y: f32,
        target: *Image,
    ) bool {
        return raw.skb_rasterizer_draw_color_glyph(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            glyph_id,
            @ptrCast(font),
            font_size,
            @intFromEnum(alpha_mode),
            offset_x,
            offset_y,
            @ptrCast(target),
        );
    }

    pub fn getIconDimensions(icon: ?*const Icon, icon_scale: Vec2, padding: i32) Rect2i {
        return .fromSkb(raw.skb_rasterizer_get_icon_dimensions(@ptrCast(icon), icon_scale.toSkb(), padding));
    }

    pub fn drawAlphaIcon(
        self: *Rasterizer,
        temp_alloc: *TempAlloc,
        icon: ?*const Icon,
        icon_scale: Vec2,
        alpha_mode: RasterizerAlphaMode,
        offset_x: i32,
        offset_y: i32,
        target: *Image,
    ) bool {
        return raw.skb_rasterizer_draw_alpha_icon(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(icon),
            icon_scale.toSkb(),
            @intFromEnum(alpha_mode),
            offset_x,
            offset_y,
            @ptrCast(target),
        );
    }

    pub fn drawColorIcon(
        self: *Rasterizer,
        temp_alloc: *TempAlloc,
        icon: ?*const Icon,
        icon_scale: Vec2,
        alpha_mode: RasterizerAlphaMode,
        offset_x: i32,
        offset_y: i32,
        target: *Image,
    ) bool {
        return raw.skb_rasterizer_draw_color_icon(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(icon),
            icon_scale.toSkb(),
            @intFromEnum(alpha_mode),
            offset_x,
            offset_y,
            @ptrCast(target),
        );
    }

    pub fn getDecorationPatternSize(style: DecorationStyle, thickness: f32) Vec2 {
        return Vec2.fromSkb(raw.skb_rasterizer_get_decoration_pattern_size(
            @intFromEnum(style),
            thickness,
        ));
    }

    pub fn getDecorationPatternDimensions(style: DecorationStyle, thickness: f32, padding: i32) Rect2i {
        return .fromSkb(raw.skb_rasterizer_get_decoration_pattern_dimensions(
            @intFromEnum(style),
            thickness,
            padding,
        ));
    }

    pub fn drawDecorationPattern(
        self: *Rasterizer,
        temp_alloc: *TempAlloc,
        style: DecorationStyle,
        thickness: f32,
        alpha_mode: RasterizerAlphaMode,
        offset_x: i32,
        offset_y: i32,
        target: *Image,
    ) bool {
        return raw.skb_rasterizer_draw_decoration_pattern(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @intFromEnum(style),
            thickness,
            @intFromEnum(alpha_mode),
            offset_x,
            offset_y,
            @ptrCast(target),
        );
    }
};

pub const RasterizerConfig = extern struct {
    on_edge_value: u8 = 0,
    pixel_dist_scale: f32 = 0,

    pub fn default() RasterizerConfig {
        return @bitCast(raw.skb_rasterizer_get_default_config());
    }

    pub fn toSkb(self: RasterizerConfig) raw.struct_skb_rasterizer_config_t {
        return .{
            .on_edge_value = self.on_edge_value,
            .pixel_dist_scale = self.pixel_dist_scale,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_rasterizer_config_t) RasterizerConfig {
        return .{
            .on_edge_value = skb.on_edge_value,
            .pixel_dist_scale = skb.pixel_dist_scale,
        };
    }
};

pub const RasterizerAlphaMode = enum(c_uint) {
    mask = raw.SKB_RASTERIZE_ALPHA_MASK,
    sdf = raw.SKB_RASTERIZE_ALPHA_SDF,
};

pub const ImageAtlas = opaque {
    pub fn create(config: ?*const ImageAtlasConfig) std.mem.Allocator.Error!*ImageAtlas {
        return @ptrCast(raw.skb_image_atlas_create(
            @constCast(if (config) |cfg| &cfg.toSkb() else null),
        ) orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *ImageAtlas) void {
        raw.skb_image_atlas_destroy(@ptrCast(self));
    }

    pub fn getConfig(self: *const ImageAtlas) ImageAtlasConfig {
        return @bitCast(raw.skb_image_atlas_get_config(@ptrCast(self)));
    }

    pub fn setCreateTextureCallback(self: *ImageAtlas, create_texture_callback: *const CreateTextureFunc, context: ?*anyopaque) void {
        raw.skb_image_atlas_set_create_texture_callback(@ptrCast(self), @ptrCast(create_texture_callback), context);
    }

    pub fn getTextureCount(self: *const ImageAtlas) i32 {
        return raw.skb_image_atlas_get_texture_count(@ptrCast(self));
    }

    pub fn getTexture(self: *const ImageAtlas, texture_idx: i32) ?*const Image {
        return @ptrCast(raw.skb_image_atlas_get_texture(@ptrCast(self), texture_idx));
    }

    pub fn getTextureDirtyBounds(self: *const ImageAtlas, texture_idx: i32) Rect2i {
        return .fromSkb(raw.skb_image_atlas_get_texture_dirty_bounds(@ptrCast(self), texture_idx));
    }

    pub fn getAndResetTextureDirtyBounds(self: *ImageAtlas, texture_idx: i32) Rect2i {
        return .fromSkb(raw.skb_image_atlas_get_and_reset_texture_dirty_bounds(@ptrCast(self), texture_idx));
    }

    pub fn setTextureUserData(self: *ImageAtlas, texture_idx: i32, user_data: usize) void {
        raw.skb_image_atlas_set_texture_user_data(@ptrCast(self), texture_idx, user_data);
    }

    pub fn getTextureUserData(self: *const ImageAtlas, texture_idx: i32) usize {
        return raw.skb_image_atlas_get_texture_user_data(@ptrCast(self), texture_idx);
    }

    pub const DebugRectIteratorFunc = fn (x: i32, y: i32, width: i32, height: i32, context: ?*anyopaque) callconv(.c) void;

    pub fn debugIterateFreeRects(self: *const ImageAtlas, texture_idx: i32, callback: *const DebugRectIteratorFunc, context: ?*anyopaque) void {
        raw.skb_image_atlas_debug_iterate_free_rects(
            @ptrCast(self),
            texture_idx,
            @ptrCast(callback),
            context,
        );
    }

    pub fn debugIterateUsedRects(self: *const ImageAtlas, texture_idx: i32, callback: *const DebugRectIteratorFunc, context: ?*anyopaque) void {
        raw.skb_image_atlas_debug_iterate_used_rects(
            @ptrCast(self),
            texture_idx,
            @ptrCast(callback),
            context,
        );
    }

    pub fn debugGetTexturePrevDirtyBounds(self: *const ImageAtlas, texture_idx: i32) Rect2i {
        return .fromSkb(raw.skb_image_atlas_debug_get_texture_prev_dirty_bounds(@ptrCast(self), texture_idx));
    }

    pub fn getGlyphQuad(
        atlas: ?*ImageAtlas,
        x: f32,
        y: f32,
        pixel_scale: f32,
        font_collection: *FontCollection,
        font_handle: FontHandle,
        glyph_id: u32,
        font_size: f32,
        tint_color: Color,
        alpha_mode: RasterizerAlphaMode,
    ) Quad {
        return @bitCast(raw.skb_image_atlas_get_glyph_quad(
            @ptrCast(atlas),
            x,
            y,
            pixel_scale,
            @ptrCast(font_collection),
            @intFromEnum(font_handle),
            glyph_id,
            font_size,
            tint_color.toSkb(),
            @intFromEnum(alpha_mode),
        ));
    }

    pub fn getIconQuad(
        atlas: ?*ImageAtlas,
        x: f32,
        y: f32,
        pixel_scale: f32,
        icon_collection: *IconCollection,
        icon_handle: IconHandle,
        width: f32,
        height: f32,
        tint_color: Color,
        alpha_mode: RasterizerAlphaMode,
    ) Quad {
        return @bitCast(raw.skb_image_atlas_get_icon_quad(
            @ptrCast(atlas),
            x,
            y,
            pixel_scale,
            @ptrCast(icon_collection),
            @intFromEnum(icon_handle),
            width,
            height,
            tint_color.toSkb(),
            @intFromEnum(alpha_mode),
        ));
    }

    pub fn getDecorationQuad(
        atlas: ?*ImageAtlas,
        x: f32,
        y: f32,
        pixel_scale: f32,
        position: DecorationPosition,
        style: DecorationStyle,
        length: f32,
        pattern_offset: f32,
        thickness: f32,
        tint_color: Color,
        alpha_mode: RasterizerAlphaMode,
    ) Quad {
        return @bitCast(raw.skb_image_atlas_get_decoration_quad(
            @ptrCast(atlas),
            x,
            y,
            pixel_scale,
            @intFromEnum(position),
            @intFromEnum(style),
            length,
            pattern_offset,
            thickness,
            tint_color.toSkb(),
            @intFromEnum(alpha_mode),
        ));
    }

    pub fn compact(self: *ImageAtlas) bool {
        return raw.skb_image_atlas_compact(@ptrCast(self));
    }

    pub fn rasterizeMissingItems(self: *ImageAtlas, temp_alloc: *TempAlloc, rasterizer: *Rasterizer) bool {
        return raw.skb_image_atlas_rasterize_missing_items(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(rasterizer),
        );
    }
};

pub const QuadFlags = packed struct(c_uint) {
    is_color: bool = false,
    is_sdf: bool = false,

    _: u30 = 0,

    pub fn toInt(self: QuadFlags) c_uint {
        var result: c_uint = 0;
        if (self.is_color) result |= raw.SKB_QUAD_IS_COLOR;
        if (self.is_sdf) result |= raw.SKB_QUAD_IS_SDF;
        return result;
    }

    pub fn fromInt(value: c_uint) QuadFlags {
        return .{
            .is_color = (value & raw.SKB_QUAD_IS_COLOR) != 0,
            .is_sdf = (value & raw.SKB_QUAD_IS_SDF) != 0,
        };
    }
};

pub const Quad = extern struct {
    geom: Rect2 = .zero,
    pattern: Rect2 = .zero,
    texture: Rect2 = .zero,
    scale: f32 = 0,
    color: Color = .rgba(0, 0, 0, 0),
    texture_idx: u8 = 0,
    flags: u8 = 0,
};

pub const CreateTextureFunc = fn (atlas: *const ImageAtlas, texture_idx: u8, context: ?*anyopaque) callconv(.c) void;

pub const ImageItemConfig = extern struct {
    rounding: f32 = 0,
    min_size: f32 = 0,
    max_size: f32 = 0,
    padding: i32 = 0,

    pub fn toSkb(self: ImageItemConfig) raw.struct_skb_image_item_config_t {
        return .{
            .rounding = self.rounding,
            .min_size = self.min_size,
            .max_size = self.max_size,
            .padding = self.padding,
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_image_item_config_t) ImageItemConfig {
        return .{
            .rounding = skb.rounding,
            .min_size = skb.min_size,
            .max_size = skb.max_size,
            .padding = skb.padding,
        };
    }
};

pub const ImageAtlasConfigFlags = packed struct(u8) {
    debug_clear_removed: bool = false,

    _: u7 = 0,

    pub fn toInt(self: ImageAtlasConfigFlags) u8 {
        var result: u8 = 0;
        if (self.debug_clear_removed) result |= raw.SKB_IMAGE_ATLAS_DEBUG_CLEAR_REMOVED;
        return result;
    }

    pub fn fromInt(value: u8) ImageAtlasConfigFlags {
        return .{
            .debug_clear_removed = (value & raw.SKB_IMAGE_ATLAS_DEBUG_CLEAR_REMOVED) != 0,
        };
    }
};

pub const ImageAtlasConfig = extern struct {
    init_width: i32 = 0,
    init_height: i32 = 0,
    expand_size: i32 = 0,
    max_width: i32 = 0,
    max_height: i32 = 0,
    item_height_rounding: i32 = 0,
    fit_max_factor: f32 = 0,
    evict_inactive_duration: i32 = 0,
    flags: ImageAtlasConfigFlags = .{},
    glyph_sdf: ImageItemConfig = .{},
    glyph_alpha: ImageItemConfig = .{},
    icon_sdf: ImageItemConfig = .{},
    icon_alpha: ImageItemConfig = .{},
    pattern_sdf: ImageItemConfig = .{},
    pattern_alpha: ImageItemConfig = .{},

    pub fn default() ImageAtlasConfig {
        return .fromSkb(raw.skb_image_atlas_get_default_config());
    }

    pub fn toSkb(self: ImageAtlasConfig) raw.struct_skb_image_atlas_config_t {
        return .{
            .init_width = self.init_width,
            .init_height = self.init_height,
            .expand_size = self.expand_size,
            .max_width = self.max_width,
            .max_height = self.max_height,
            .item_height_rounding = self.item_height_rounding,
            .fit_max_factor = self.fit_max_factor,
            .evict_inactive_duration = self.evict_inactive_duration,
            .flags = self.flags.toInt(),
            .glyph_sdf = self.glyph_sdf.toSkb(),
            .glyph_alpha = self.glyph_alpha.toSkb(),
            .icon_sdf = self.icon_sdf.toSkb(),
            .icon_alpha = self.icon_alpha.toSkb(),
            .pattern_sdf = self.pattern_sdf.toSkb(),
            .pattern_alpha = self.pattern_alpha.toSkb(),
        };
    }

    pub fn fromSkb(skb: raw.struct_skb_image_atlas_config_t) ImageAtlasConfig {
        return .{
            .init_width = skb.init_width,
            .init_height = skb.init_height,
            .expand_size = skb.expand_size,
            .max_width = skb.max_width,
            .max_height = skb.max_height,
            .item_height_rounding = skb.item_height_rounding,
            .fit_max_factor = skb.fit_max_factor,
            .evict_inactive_duration = skb.evict_inactive_duration,
            .flags = .fromInt(skb.flags),
            .glyph_sdf = ImageItemConfig.fromSkb(skb.glyph_sdf),
            .glyph_alpha = ImageItemConfig.fromSkb(skb.glyph_alpha),
            .icon_sdf = ImageItemConfig.fromSkb(skb.icon_sdf),
            .icon_alpha = ImageItemConfig.fromSkb(skb.icon_alpha),
            .pattern_sdf = ImageItemConfig.fromSkb(skb.pattern_sdf),
            .pattern_alpha = ImageItemConfig.fromSkb(skb.pattern_alpha),
        };
    }
};

pub const LayoutCache = opaque {
    pub fn create() std.mem.Allocator.Error!*LayoutCache {
        return @ptrCast(raw.skb_layout_cache_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *LayoutCache) void {
        raw.skb_layout_cache_destroy(@ptrCast(self));
    }

    pub fn getUtf8(
        self: *LayoutCache,
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        text: []const u8,
        attributes: AttributeSet,
    ) ?*const Layout {
        return @ptrCast(raw.skb_layout_cache_get_utf8(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text.ptr),
            @intCast(text.len),
            attributes.toSkb(),
        ));
    }

    pub fn getUtf32(
        self: *LayoutCache,
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        text: []const u32,
        attributes: AttributeSet,
    ) ?*const Layout {
        return @ptrCast(raw.skb_layout_cache_get_utf32(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text.ptr),
            @intCast(text.len),
            attributes.toSkb(),
        ));
    }

    pub fn getFromRuns(
        self: *LayoutCache,
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        runs: []const ContentRun,
    ) ?*const Layout {
        return @ptrCast(raw.skb_layout_cache_get_from_runs(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(runs.ptr),
            @intCast(runs.len),
        ));
    }

    pub fn compact(self: *LayoutCache) bool {
        return raw.skb_layout_cache_compact(@ptrCast(self));
    }
};

pub const RichLayout = opaque {
    pub fn create() std.mem.Allocator.Error!*RichLayout {
        return @ptrCast(raw.skb_rich_layout_create() orelse return error.OutOfMemory);
    }

    pub fn destroy(self: *RichLayout) void {
        raw.skb_rich_layout_destroy(self);
    }

    pub fn reset(self: *RichLayout) void {
        raw.skb_rich_layout_reset(self);
    }

    pub fn getParagraphsCount(self: *const RichLayout) i32 {
        return raw.skb_rich_layout_get_paragraphs_count(@ptrCast(self));
    }

    pub fn getLayout(self: *const RichLayout, index: i32) ?*const Layout {
        return @ptrCast(raw.skb_rich_layout_get_layout(@ptrCast(self), index));
    }

    pub fn getOffsetY(self: *const RichLayout, index: i32) f32 {
        return raw.skb_rich_layout_get_offset_y(@ptrCast(self), index);
    }

    pub fn getDirection(self: *const RichLayout, index: i32) TextDirection {
        return @enumFromInt(raw.skb_rich_layout_get_direction(@ptrCast(self), index));
    }

    pub fn update(
        self: *RichLayout,
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        rich_text: *const RichText,
        ime_text_offset: i32,
        ime_text: *const Text,
    ) void {
        raw.skb_rich_layout_update(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(rich_text),
            ime_text_offset,
            @ptrCast(ime_text),
        );
    }

    pub fn updateWithChange(
        self: *RichLayout,
        temp_alloc: *TempAlloc,
        params: *const LayoutParams,
        text: *const RichText,
        change: RichTextChange,
        ime_text_offset: i32,
        ime_text: *const Text,
    ) void {
        raw.skb_rich_layout_update_with_change(
            @ptrCast(self),
            @ptrCast(temp_alloc),
            @ptrCast(params),
            @ptrCast(text),
            @intFromEnum(change),
            ime_text_offset,
            @ptrCast(ime_text),
        );
    }

    pub fn getParagraphPosition(
        self: *const RichLayout,
        text_pos: TextPosition,
        affinity_usage: AffinityUsage,
    ) ParagraphPosition {
        return .fromSkb(raw.skb_rich_layout_get_paragraph_position(
            @ptrCast(self),
            text_pos.toSkb(),
            @intFromEnum(affinity_usage),
        ));
    }

    pub fn textPositionToOffset(self: *const RichLayout, text_pos: TextPosition) i32 {
        return raw.skb_rich_layout_text_position_to_offset(@ptrCast(self), text_pos.toSkb());
    }

    pub fn textSelectionToRange(self: *const RichLayout, selection: TextSelection) Range {
        return .fromSkb(raw.skb_rich_layout_text_selection_to_range(@ptrCast(self), @intFromEnum(selection)));
    }

    pub fn getVisualCaret(self: *const RichLayout, pos: TextPosition) VisualCaret {
        return @bitCast(raw.skb_rich_layout_get_visual_caret(@ptrCast(self), pos.toSkb()));
    }

    pub fn getSelectionBounds(self: *const RichLayout, selection: TextSelection, callback: *const SelectionRectFunc, context: ?*anyopaque) void {
        raw.skb_rich_layout_get_selection_bounds(
            @ptrCast(self),
            @intFromEnum(selection),
            @ptrCast(callback),
            context,
        );
    }

    pub fn hitTest(self: *const RichLayout, movement_type: MovementType, hit_x: f32, hit_y: f32) TextPosition {
        return .fromSkb(raw.skb_rich_layout_hit_test(@ptrCast(self), @intFromEnum(movement_type), hit_x, hit_y));
    }
};

pub const AffinityUsage = enum(c_uint) {
    use = raw.SKB_AFFINITY_USE,
    ignore = raw.SKB_AFFINITY_IGNORE,
};
