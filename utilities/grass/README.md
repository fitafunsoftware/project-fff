# GrassGenerator
A node to help generate grass.

The `grass_texture` is a texture of the single clump of grass to be repeated.<br>
The `grass_map` is a map of how much grass and where the grass should be placed. Transparent pixels will not have grass and visible pixels will have grass.<br>
The `y_offset` is meant to move the rows of grass closer.<br>
* If the offset is 0, the distance between rows matches the height of the `grass_texture`.
* If the offset is positive, the distance between rows gets closer.
* If the offset is negative, the distance between rows gets further.

Grass textures use a different shader than VerticleSprite3Ds. You can set it in the const `GRASS_SHADER`.
