# SDL TEST #1

This repo is meant as an exercise to learn SDL with Zig.
Can be used as a template to start a new game project.

## What is available

The main.zig program is complete and surprisingly short!
The file game.zig implements the run() loop and the main functions that must be fully implemented dipending on your game.

## The methods

- init() initializes SDL (must be completed if music and fonts are needed)
- run() is the main loop. Quits with the ESC key.
- update() reads the keyboard events. It should update all other game elements
- draw() draws the frame to the window. After drawing it calls SDL_Present()
- quit() It is called by run() on quit. It deallocates what has been allocated during init()

## Embedded Assets

I don't like to depend on the location of the assets to load them at runtime from the disk.
For this reason I created the assets folder and the assets.zig file.
The main game has to call assets.init() in its init() function to be able to access them.
The assets themselves are embedded using the @embedFile() directive.
They can be read using the c.IMG_LoadTextureTyped_RW()

## Screenshot

![alt text](<screenshot.png>)
