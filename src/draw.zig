const std = @import("std");
const c = @cImport({
    @cInclude("SDL2/SDL.h");
});

// draws a rounded box with...
// corner radius of 'r'
// width of 'w'
// and height of 'h'
// draws the box right and down of...
// x-offset xo
// y-offset yo

// returns 0 if 2*r is bigger than w or h
// and draws nothing
// returns 1 on success

fn SDLColorToUint(color: c.SDL_Color) u32 {
    return color.a << 24 + color.r << 16 + color.g << 8 + color.b;
}

fn UintToSDLColor(color: u32) c.SDL_Color {
    return c.SDL_Color{
        .a = (color >> 24) & 0xFF,
        .r = (color >> 16) & 0xFF,
        .g = (color >> 8) & 0xFF,
        .b = color & 0xFF,
    };
}

pub fn fill_rounded_box_ext(dst: *c.SDL_Surface, rect: c.SDL_Rect, r: i32, color: c.SDL_Color) i32 {
    return fill_rounded_box(dst, rect.x, rect.y, rect.w, rect.h, r, SDLColorToUint(color));
}

pub fn fill_rounded_box(dst: *c.SDL_Surface, xo: i32, yo: i32, w: i32, h: i32, r: i32, color: u32) i32 {
    var pixels: *u32 = @as(*u32, dst.pixels);
    var x: i32 = 0;
    var y: i32 = 0;
    var i: i32 = 0;
    var j: i32 = 0;

    const rpsqrt2: i32 = r / std.math.sqrt(2);
    //var r2: c_longdouble = r * r;

    w /= 2;
    h /= 2;

    xo += w;
    yo += h;

    w -= r;
    h -= r;

    if (w < 0 or h < 0)
        return 0;

    c.SDL_LockSurface(dst);

    const yd: i32 = 1; // NOOOOO non so dove è il file originale :(
    const sy: i32 = (yo - h) * yd;
    const ey: i32 = (yo + h) * yd;
    const sx: i32 = (xo - w);
    const ex: i32 = (xo + w);

    i = sy;
    while (i <= ey) : (i += yd) {
        j = sx - r;
        while (j <= ex + r) : (j += 1) {
            pixels[i + j] = color;
        }
    }

    var d: i32 = -r;
    var x2m1: i32 = -1;
    y = r;
    x = 0;
    while (x <= rpsqrt2) : (x += 1) {
        x2m1 += 2;
        d += x2m1;
        if (d >= 0) {
            y -= 1;
            d -= (y * 2);
        }

        i = sx - x;
        while (i <= ex + x) : (i += 1)
            pixels[sy - y * yd + i] = color;

        i = sx - y;
        while (i <= ex + y) : (i += 1)
            pixels[sy - x * yd + i] = color;

        i = sx - y;
        while (i <= ex + y) : (i += 1)
            pixels[ey + x * yd + i] = color;

        i = sx - x;
        while (i <= ex + x) : (i += 1)
            pixels[ey + y * yd + i] = color;
    }

    c.SDL_UnlockSurface(dst);
    return 1;
}
