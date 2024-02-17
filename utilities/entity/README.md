# Entity
The base class for all dynamic entities in the game.

Set `target_velocity_2d` to allow for acceleration and friction to be applied. Set `velocity` directly to immediately apply the velocity. `set_velocity_2d` and `set_y_velocity` are functions just meant for convenience.

The Entity class will try to snap itself to units that match the pixels the camera displays, so the sprites of the Entities are pixel perfect.
