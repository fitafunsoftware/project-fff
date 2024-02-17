# GameGlobalParameters
Autoload that loads and stores the global parameters needed by Nodes and Resources in the game.

The `GLOBAL_PARAMS_JSON` holds the path to the json that keeps all the normal global parameters.

The `GLOBAL_SHADER_PARAMS_JSON` holds the path to the json that keeps all the shader global parameters. These also get set to the appropriate global shader parameter when the game starts, so the Editor can use fake values that don't cause the shaders to be active while editing the project.

While this is the autoload that stores the global parameters while the game is running, **do not** call this autoload. Instead, call the `GlobalParams` static class as it will properly get the parameters even if this Autoload is not loaded (while you're in Editor).
