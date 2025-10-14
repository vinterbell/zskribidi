const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const should_link_libcpp = !(target.result.abi == .msvc);

    const harfbuzz = b.dependency("harfbuzz", .{});
    const lib_harfbuzz = b.addLibrary(.{
        .name = "harfbuzz",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
            .link_libcpp = should_link_libcpp,
        }),
    });
    lib_harfbuzz.addCSourceFile(.{
        .file = harfbuzz.path("src/harfbuzz.cc"),
    });

    const sheenbidi = b.dependency("sheenbidi", .{});
    const lib_sheenbidi = b.addLibrary(.{
        .name = "sheenbidi",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib_sheenbidi.addCSourceFile(.{
        .file = sheenbidi.path("Source/SheenBidi.c"),
    });
    lib_sheenbidi.root_module.addCMacro("SB_CONFIG_UNITY", "1");
    lib_sheenbidi.addIncludePath(sheenbidi.path("Headers"));

    const libunibreak = b.dependency("libunibreak", .{});
    const lib_libunibreak = b.addLibrary(.{
        .name = "unibreak",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib_libunibreak.addCSourceFiles(.{
        .root = libunibreak.path("src"),
        .files = &.{
            "eastasianwidthdata.c",
            "eastasianwidthdef.c",
            "eastasianwidthdef.h",
            "emojidata.c",
            "emojidef.c",
            "emojidef.h",
            "graphemebreak.c",
            "graphemebreak.h",
            "graphemebreakdata.c",
            "graphemebreakdef.h",
            "indicconjunctbreakdata.c",
            "indicconjunctbreakdef.h",
            "linebreak.c",
            "linebreak.h",
            "linebreakdata.c",
            "linebreakdef.c",
            "linebreakdef.h",
            "unibreakbase.c",
            "unibreakbase.h",
            "unibreakdef.c",
            "unibreakdef.h",
            "wordbreak.c",
            "wordbreak.h",
            "wordbreakdata.c",
            "wordbreakdef.h",
        },
    });

    const budouxc = b.dependency("budouxc", .{});
    const lib_budouxc = b.addLibrary(.{
        .name = "budouxc",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib_budouxc.addCSourceFile(.{
        .file = budouxc.path("src/budoux.c"),
    });
    lib_budouxc.addIncludePath(budouxc.path("include"));

    const upstream = b.dependency("upstream", .{});

    const lib_skribidi = b.addLibrary(.{
        .name = "skribidi",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib_skribidi.linkLibrary(lib_harfbuzz);
    lib_skribidi.linkLibrary(lib_sheenbidi);
    lib_skribidi.linkLibrary(lib_libunibreak);
    lib_skribidi.linkLibrary(lib_budouxc);
    lib_skribidi.addCSourceFiles(.{
        .root = upstream.path("src"),
        .files = &.{
            // "emoji_data.h",
            "skb_attributes.c",
            "skb_attribute_collection.c",
            "skb_canvas.c",
            "skb_common.c",
            // "skb_common_internal.h",
            "skb_editor.c",
            "skb_font_collection.c",
            // "skb_font_collection_internal.h",
            "skb_icon_collection.c",
            // "skb_icon_collection_internal.h",
            "skb_image_atlas.c",
            "skb_layout.c",
            // "skb_layout_internal.h",
            "skb_layout_cache.c",
            "skb_rasterizer.c",
            "skb_rich_layout.c",
            // "skb_rich_layout_internal.h",
            "skb_rich_text.c",
            // "skb_rich_text_internal.h",
            "skb_text.c",
            // "skb_text_internal.h",
        },
    });
    lib_skribidi.addIncludePath(harfbuzz.path("src"));
    lib_skribidi.addIncludePath(sheenbidi.path("Headers"));
    lib_skribidi.addIncludePath(libunibreak.path("src"));
    lib_skribidi.addIncludePath(budouxc.path("include"));
    lib_skribidi.addIncludePath(upstream.path("include"));
    lib_skribidi.installHeadersDirectory(upstream.path("include"), "", .{});

    b.installArtifact(lib_harfbuzz);
    b.installArtifact(lib_sheenbidi);
    b.installArtifact(lib_libunibreak);
    b.installArtifact(lib_budouxc);
    b.installArtifact(lib_skribidi);

    const mod = b.addModule("zskribidi", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .imports = &.{},
    });
    mod.linkLibrary(lib_skribidi);

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    const run_mod_tests = b.addRunArtifact(mod_tests);
    run_mod_tests.setCwd(upstream.path("example"));

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}
