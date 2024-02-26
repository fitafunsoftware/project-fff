# Occluder
A simple resource used to show or hide a node based on its position.

`set_height` tells the occluder the height of the node it occludes for. Based off of this height, it calculates whether it is still seen over the horizon and hides the node if it is not visible.

Use the `to_occlude()` function to check if the node should be occluded or not.
