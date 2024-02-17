# ControllerMapper
Autoload designed to add joy mappings when controllers are connected.

Godot joypad mappings follow SDL mappings. Usually, the mappings built in to the engine are sufficient and most joypads will map properly when connected. However, it can take time for the mappings to update, you might have to wait for the next minor engine version update, so a joypad that recently released and is not in the engine will not be mapped properly when connected.

This autoload can parse the `gamecontrollerdb.txt` you find on the SDL_GameControllerDB github repo. You would need to point to the proper path in the `GAMECONTROLLERDB_PATH` const. The fallback path is just a fallback that points to a text file in this folder.

**This autoload is currently deprecated cause the joypad mapping I needed has been merged into the engine.**
