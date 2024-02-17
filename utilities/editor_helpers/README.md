# Editor Helpers
A collection of helpers for use in the editor.

## Editor Runner Scene
A scene to help run single scenes in the Editor using the Run Current Scene button.

Due to the reliance of a lot of nodes and scenes to autoloads, this scene helps let you test scenes using the Run Current Scene button while not avoiding things from breaking. Pick the scene you want to test in the `Starting Scene` variable export.

## GlobalParams
The `GlobalParams` static class meant to be used to retrieve global parameters. This static class should be used instead of the `GameGlobalParams` autoload. This manages whether to use the `EditorGlobalParams` or `GameGlobalParams` depending on where the game is running, in editor or actually running.
