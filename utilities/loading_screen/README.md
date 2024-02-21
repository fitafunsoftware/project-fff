# Loading Screen
A default loading screen to be reused.

While this scene can be used by itself, the easier way to use the scene is through the `GameViewport` and calling the `change_to_loading_scene()` function. That function will cause the viewport switch to this loading screen first and then switch to the scene provided. This is mostly meant for really big scenes that do take time to load.
