const std = @import("std");
const Allocator = std.mem.Allocator;
const ray = @import("raylib.zig");

const Player = @import("player/Player.zig");
const Vec2 = Player.Vec2;

const Chunk = @import("Chunk.zig");
const CHUNKS_PER_SCREEN = 128;

const Game = @This();

player: Player,
terrain: []Chunk,
allocator: Allocator,
rng: std.rand.Xoshiro256,

pub fn init(allocator: Allocator) Allocator.Error!Game {
    const terrain = try allocator.alloc(Chunk, CHUNKS_PER_SCREEN);
    var rng = std.rand.DefaultPrng.init(seed: {
        var seed: usize = undefined;
        _ = std.os.getrandom(std.mem.asBytes(&seed)) catch break :seed 64;
        break :seed seed;
    });
    const random = rng.random();
    for (terrain) |*chunk| {
        const choice = random.int(u10);

        chunk.* = .{
            .chunkType = .normal,
            .height = @as(f32, @floatFromInt(choice)),
        };
    }

    return .{
        .player = Player.init(),
        .terrain = terrain,
        .allocator = allocator,
        .rng = rng,
    };
}
pub fn deinit(self: *Game) void {
    self.allocator.free(self.terrain);
}

fn playerIsOnGround(self: *const Game) bool {
    return self.player.position[1] >= self.terrain[self.chunkHeight()].height;
}
fn chunkHeight(self: *const Game) usize {
    return @as(usize, @intFromFloat(@floor(self.player.position[0] / 20.0)));
}

pub fn handleKeyPress(self: *Game) void {
    var x_buffer: f32 = 0.0;
    var needs_to_jump = false;
    switch (ray.GetKeyPressed()) {
        ray.KEY_A => x_buffer -= 1.0,
        ray.KEY_D => x_buffer += 1.0,
        ray.KEY_SPACE => needs_to_jump = true,
        else => {},
    }

    self.player.velocity[0] = x_buffer;
    self.player.jump(self.playerIsOnGround(), 1.0);
}
