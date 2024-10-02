const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
    @cInclude("SDL2/SDL_image.h");
});
const assets = @import("assets.zig");

const assert = std.debug.assert;

// Window Constants
const title = "Sdl Test #1";
const width = 800;
const height = 600;

// Color Palette Constants
const black: c.SDL_Color = .{ 0, 0, 0, 255 };

// Color Game Elements
const bg: c.SDL_Color = black;

// Game members
var should_quit: bool = false;
var window: *c.SDL_Window = undefined;
var renderer: *c.SDL_Renderer = undefined;

// Public function called by main()
pub fn run() !void {
    try init();
    while (!should_quit) {
        update();
        draw();
    }
    quit();
}

// Local function called by public run()
// Initializes all SDL resources
fn init() !void {
    // Initialize SDL
    if (c.SDL_Init(c.SDL_INIT_EVERYTHING) != 0) {
        c.SDL_Log("Unable to initialize SDL: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }

    // Create Window
    window = c.SDL_CreateWindow(title, c.SDL_WINDOWPOS_UNDEFINED, c.SDL_WINDOWPOS_UNDEFINED, @as(c_int, @intCast(width)), @as(c_int, @intCast(height)), c.SDL_WINDOW_SHOWN) orelse {
        c.SDL_Log("Unable to create window: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };

    // Set VSync on
    if (c.SDL_SetHint(c.SDL_HINT_RENDER_VSYNC, "1") == c.SDL_FALSE) {
        c.SDL_Log("Unable to set hint: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    }

    // Create Renderer
    renderer = c.SDL_CreateRenderer(window, -1, c.SDL_RENDERER_ACCELERATED) orelse {
        c.SDL_Log("Unable to create renderer: %s", c.SDL_GetError());
        return error.SDLInitializationFailed;
    };

    // Load Assets
    try assets.init(renderer);
}

// Local function called by run() in the game loop
// Polls events and updates game elements
fn update() void {
    // Poll events
    var sdlEvent: c.SDL_Event = undefined;
    while (c.SDL_PollEvent(&sdlEvent) > 0) {
        switch (sdlEvent.type) {
            c.SDL_QUIT => {
                should_quit = true;
            },
            c.SDL_KEYDOWN => {
                if (sdlEvent.key.keysym.sym == c.SDLK_ESCAPE)
                    should_quit = true;
            },
            else => {},
        }
    }
}

// Local function called by run() in the game loop
// Draws the elements to the window
fn draw() void {
    // Step1: Clear the screen
    _ = c.SDL_SetRenderDrawColor(renderer, 24, 24, 24, 255);
    _ = c.SDL_RenderClear(renderer);

    // Step2: Draw all elements
    // _ = c.SDL_RenderCopy(renderer, hero_texture, &assets.zero_src, &assets.zero_dst);
    // _ = c.SDL_RenderCopy(renderer, hero_texture, &assets.ziggy_src, &assets.ziggy_dst);
    assets.draw_texture_at(10, 20, assets.texture_type.zero_png);
    assets.draw_texture_at(250, 200, assets.texture_type.ziggy_png);

    // Step3: Display the textures
    c.SDL_RenderPresent(renderer);
}

// Local function called by run() after quitting the game loop
// It deallocates all remaining used resources
fn quit() void {
    c.SDL_DestroyRenderer(renderer);
    c.SDL_DestroyWindow(window);
    c.SDL_Quit();
}
