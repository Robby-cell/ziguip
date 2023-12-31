const std = @import("std");
const ray = @import("raylib.zig");

const Game = @import("Game.zig");
const BACKGROUND_COLOR = ray.Color{ .r = 10, .g = 200, .b = 200, .a = 150 };

pub fn main() !void {
    const width = 1920;
    const height = 1080;

    ray.SetConfigFlags(ray.FLAG_MSAA_4X_HINT | ray.FLAG_VSYNC_HINT);
    ray.InitWindow(width, height, "zig raylib example");
    defer ray.CloseWindow();
    ray.SetTargetFPS(60);

    var gpa: std.heap.GeneralPurposeAllocator(.{ .stack_trace_frames = 8 }) = .{};
    const allocator = gpa.allocator();
    defer {
        switch (gpa.deinit()) {
            .leak => @panic("leaked memory"),
            else => {},
        }
    }

    var game = try Game.init(allocator);
    defer game.deinit();

    while (!ray.WindowShouldClose()) {
        game.handleKeyPress();

        // draw
        {
            ray.BeginDrawing();
            defer ray.EndDrawing();

            ray.ClearBackground(BACKGROUND_COLOR);

            const seconds: u32 = @intFromFloat(ray.GetTime());
            const dynamic = try std.fmt.allocPrintZ(allocator, "running since {d} seconds", .{seconds});
            defer allocator.free(dynamic);
            ray.DrawText(dynamic, 300, 250, 20, ray.WHITE);

            game.render();

            ray.DrawFPS(width - 100, 10);
        }
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
