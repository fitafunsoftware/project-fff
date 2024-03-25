# Sprite3D
Collection of nodes that "extend" the functionality of the Sprite3D nodes in Godot. You could also just apply the proper shader to the ShaderMaterial, but these nodes have some conveniency built into them.

## HorizontalSprite3D
Despite the name, this node does not actually extend from the Sprite3D class, but from the MeshInstance3D class.<br>
Meant to be used for horizontal sprites in the 3D space like the ground or roofs.
### Caveats
- These sprites should not have transparency as transparency messes with draw order a lot.
- Make sure you give this mesh enough vertices so a smooth curve is generated.

## VerticalSprite3D
Basic Sprite3D node to be used for sprites to conform to the curved world shader.<br>
If you set or unset the shaded variable, a corresponding shaded or unshaded shader will be used.

## ParallaxBackground3D
A basic Sprite3D node that helps integrate the ParallaxBackground node functionality in 3D. The idea is to attach a ViewportTexture with a SubViewport that has a ParallaxBackground and to draw it onto the ParallaxBackground3D node. The ParallaxBackground3D node deals with setting the ParallaxBackground offset and making sure it follows the current Camera3D.<br>
### Caveats
- You can use the SpriteViewport to help with setting up a SubViewport with the right size, but it's recommended to increase the size to cover more than the screen shows.
	- Setting up mirroring helps properly repeat the background so a bigger SubViewport size shows the proper background.
- The global X and Z positions are what influence the ParallaxBackground offset scaled to the PIXEL_SIZE set in global parameters.
- Maintains the initial Y position set.
