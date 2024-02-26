# SpriteViewport
A SubViewport to help use CanvasItems as sprites.<br>
Use alongside ViewportTexture and Sprite3Ds to have it appear in 3D space.

## Caveats
The CanvasItems must be within the positive X and Y region with the top-left (0, 0) being the origin of the SubViewport. While the SubViewport may resize correctly, anything within the negative values will be cut off.

# SpriteAreaPolygon
Helper node to draw area polygons for SpriteViewport sprites.

## Caveats
Positive Y in 2D is down and in 3D is up. Be sure to set the total height properly so it reorients itself properly.<br>
The total height should be the distance from y = 0 to the highest y point of the sprites in the SubViewport.
