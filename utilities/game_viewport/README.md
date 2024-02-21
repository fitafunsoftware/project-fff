# Game Viewport
Collection of nodes that are meant to be the main viewport of the entire game.

## GameViewportContainer
Control container for the GameViewport. This node controls properly scaling and resizing the GameViewport. Also handles requesting a Window resize (actual resizing of Window is handled by the GlobalSettings autoload).

## GameViewport
The main SubViewport for the entire game. When `get_viewport()` is called, it is usually assumed that this node gets returned. Changing scene is done by calling the `change_scene()` function and scene resources can be queued up by calling `queue_scene()`. Queueing does not create the scene, just loads up the resource as if you called `load()` on the scene.

## NextSceneManager
A helper node for the GameViewport. Helps hold the next scene while the scene gets `ready`ed and informs the GameViewport when the new scene is ready.
