# Menu Scene
A basic reusable scene that can act as a menu.

## Usage
- Add names of the options to the `options` array.
- Add the paths to the corresponding scenes in the `scenes` array.
- If the scene might require a loading scene in between this scene and the next scene, check the bool in the `loading` array.

Each value should match the corresponding index. As in the first button will use the name, the scene path, and the loading bool in the the 0th index and so on.

If the path to the scene does not exist or is left blank, that button will not be generated.
