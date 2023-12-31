const std = @import("std");

const Chunk = @This();

chunkType: ChunkType,
height: f32,

const ChunkType = enum {
    normal,
};
