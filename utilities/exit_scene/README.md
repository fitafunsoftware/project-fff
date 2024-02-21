# Exit Scene
A helper scene that acts as a buffer between exiting the game and the program actually quitting.

Meant to help unload nodes that are still around. Change to this scene instead of just calling quit. Currently does not do much, but can be extended later to better clean up resources and nodes when this scene is changed to.
