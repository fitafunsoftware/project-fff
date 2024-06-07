# Editor Helpers
A collection of helpers for use in the editor.

## DebugCollisionMeshManager
A node to help create MeshInstance3Ds for CollisionShape3Ds. They only get displayed as wireframes 
and can be given custom colors.

## Editor Runner Scene
A scene to help run single scenes in the Editor using the Run Current Scene button.<br>
Due to the reliance of a lot of nodes and scenes to the GameSubViewport, this just a template you can copy to a new scene to help you set up a simple scene to just run. You could also add the scene you want to run to the Starting Scene variable and just Run the Editor Runner Scene.

## GlobalParams
The `GlobalParams` static class meant to be used to retrieve global parameters. This static class should be used instead of the `GameGlobalParams` autoload. This manages whether to use the `EditorGlobalParams` or `GameGlobalParams` depending on where the game is running, in editor or actually running.

## PixelPositionHelper
A Node3D to help place other Node3Ds in positions that match the pixel positions once the shader is applied.<br>
Write the amount of pixels you want to offset the node by in Z Pixel Offset. The position of the helper node moves to the z position of that pixel's when the shader is applied.<br>
Z Offset is just the new z position. This is just here so it's easier to copy the value instead of needing to scroll down to the node's postion to get the z position.<br>
Note: These values are in local space, meaning they are relative to the parent's position. If the parent is not on a pixel correct position, the children won't be either.
