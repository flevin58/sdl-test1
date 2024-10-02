const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
});

const zigxml = @import("zigxml");

pub const texture_type = enum(u16) {
    zero_png = 1,
    ziggy_png = 2,
    heroes_png = 3,
};

// They will be initialized by init() called by game.zig
var heroes_texture: *c.SDL_Texture = undefined;
var renderer_ptr: *c.SDL_Renderer = undefined;

pub const heroes_png = @embedFile("assets/images/heroes.png");
pub const zero_src = c.SDL_Rect{ .x = 0, .y = 0, .w = 288, .h = 288 };
pub var zero_dst = c.SDL_Rect{ .x = 0, .y = 0, .w = 288, .h = 288 };
pub const ziggy_src = c.SDL_Rect{ .x = 288, .y = 0, .w = 379, .h = 316 };
pub var ziggy_dst = c.SDL_Rect{ .x = 0, .y = 0, .w = 379, .h = 316 };

const Self = @This();

pub fn init(renderer: *c.SDL_Renderer) !void {
    renderer_ptr = renderer;
    const rwop = c.SDL_RWFromConstMem(
        @ptrCast(heroes_png),
        @intCast(heroes_png.len),
    ) orelse {
        c.SDL_Log("Unable to get heroes.png: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };

    heroes_texture = c.IMG_LoadTextureTyped_RW(renderer, rwop, 0, "PNG") orelse {
        c.SDL_Log("Unable to create texture from surface: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };
}

pub fn draw_texture_at(x: i32, y: i32, what: texture_type) void {
    switch (what) {
        texture_type.zero_png => {
            zero_dst.x = x;
            zero_dst.y = y;
            _ = c.SDL_RenderCopy(renderer_ptr, heroes_texture, &zero_src, &zero_dst);
        },
        texture_type.ziggy_png => {
            ziggy_dst.x = x;
            ziggy_dst.y = y;
            _ = c.SDL_RenderCopy(renderer_ptr, heroes_texture, &ziggy_src, &ziggy_dst);
        },
        else => {},
    }
}
