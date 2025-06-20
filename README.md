# Project FFF
<p align="center">
	<img src="assets/art/logos/project-fff-icon.png" alt="Project FFF Placeholder Logo"> 
</p>

## 2.5D Action RPG

**Project FFF is a 2.5D Action RPG featuring a unique visual style where you hunt monsters with a 
variety of weapons to choose from.** This is the repository for the open source components of Project 
FFF (placeholder name) by Fita Fun Software. As such, the contents of this repository are free to use
so long as the proper licenses are abided by.

## Target Platforms

Project FFF is made in Godot v4.5.
- Targetted to work on the Retroid Pocket 2S (Android 11, Vulkan 1.1, 8 Core, ARM64, 3GB RAM, 640x480 resolution) 
as the lowest requirement device for the Mobile Renderer at 30 FPS and 60 Physics FPS on the 
device's Performance mode.

## Usage

The [utilities](utilities), [shaders](shaders), and [global_params](global_params) folders along with
the addons are the reusable aspects of this project. The files and folders in assets, scenes, and 
scripts are meant as a demo project to demonstrate the use of the utilities.

The project is targetted to run in the Forward+ and Mobile rendering modes due to the shaders used.
Consistency with the Compatibility rendering mode is not guaranteed.

Lastly, other assets with licenses of their own are used within this repo. The proper licenses are 
accompanied alongside them in the appropriate folder, however, I would recommend getting those assets
straight from their source as those would be the most up to date versions of them.

## Assets Credits

- [debug-menu](https://github.com/godot-extended-libraries/godot-debug-menu) by [Hugo Locurcio](https://twitter.com/hugolocurcio)
- [LanaPixel font](https://opengameart.org/content/lanapixel-localization-friendly-pixel-font) by [eishiya](https://mastodon.art/@eishiya)
- The other assets besides the [logos](utilities/splash_screen/logos/) were made for this repository and fall under the same [license](LICENSE.md) as this repository with art in the assets folder falling under the accompanying [license](assets/art/LICENSE.md) in the folder.
