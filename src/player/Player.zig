const std = @import("std");

pub const Health = enum {
    alive,
    dead,
};
pub const Vec2 = @Vector(2, f32);

const Player = @This();

position: Vec2,
direction: enum { left, right },
health: i11,
velocity: Vec2,

pub fn init() Player {
    return .{
        .position = @splat(0.0),
        .direction = .right,
        .health = 100,
        .velocity = @splat(0.0),
    };
}

pub fn takeDamage(self: *Player, damage_amount: u8) Health {
    self.health -= damage_amount;
    if (self.health <= 0)
        return .dead;
    return .alive;
}

pub fn update(self: *Player, on_ground: bool, gravity_modifier: f32) void {
    self.position += self.velocity;
    if (!on_ground)
        self.velocity[1] += 1.0 * gravity_modifier;
}

pub fn jump(self: *Player, on_ground: bool, gravity_modifier: f32) void {
    if (on_ground)
        self.velocity[1] -= (1.0 / gravity_modifier);
}
