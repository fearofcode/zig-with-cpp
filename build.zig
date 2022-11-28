const std = @import("std");

const cflags = &.{"-fno-sanitize=undefined"};

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("zig_cpp_example.bin", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    // Link c interface for cpp code
    withCpp(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

}

fn withCpp(exe: *std.build.LibExeObjStep) void {

    exe.linkSystemLibraryName("c");
    exe.linkSystemLibraryName("c++");
    exe.addIncludePath("cpp-code/");
    exe.addCSourceFile("cpp-code/codecpp.h", cflags);
    exe.addCSourceFile("cpp-code/codecpp.cpp", cflags);

}