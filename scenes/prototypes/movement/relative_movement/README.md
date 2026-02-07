# Relative Movement Prototypes
Prototypes to test values for character movement.

## Prototype 1
### Controls
- Moves only left and right. Use the A and D keys, left thumbstick, or D-pad.
- Hold Shift, Left Trigger, or Right Trigger to Sprint.
- Press the buttons on-screen to change the values:
  - Up and down buttons on the left change the value by 10.
  - Up and down buttons on the right change the value by 1.
- Stage Width changes the apparent size of the stage.
- Player Size changes the size of the player. Player is a square.
- Base Speed changes the normal speed of the player. It's relative to the size of the player.
- Sprint Speed changes the speed of the player while holding sprint. It's relative to the size 
of the player. Sprint Speed can be lower than Base Speed and act like a sneak instead of a sprint.

### Initial Thoughts
- Figuring out good values for the movement speeds of the player character.
- Assuming that what feels right depends on how big the stage feels, like the width of the stage,
and how small the character is relative to the stage.
- Speeds are relative to the size of the player. Once again, just assuming that relative values 
matter more than absolute values.
- Size of the screen, not the stage, will probably matter as well. How much of your vision it takes
up and how far away you are from it. Like relative screen size.

### Takeaways
- Stage size/width doesn't seem to have a big impact on perceived speed.
- Perceived character size has an impact on perceived speed. (Bigger looking character feels slower
even if they can traverse the stage in the same amount of time as a smaller looking character).
- Gotta figure out what makes a character perceptually bigger or smaller.
- Speed being a ratio of player size isn't very helpful right now. Might be more helpful when used
in relation to the other speeds. Make base speed absolute and all other speeds relative to base.

## Prototype 2
### Controls
- Moves only left and right. Use the A and D keys, left thumbstick, or D-pad.
- Hold Shift, Left Trigger, or Right Trigger to Sprint.
- Press the buttons on-screen to change the values:
  - Up and down buttons on the left change the value by 10.
  - Up and down buttons on the right change the value by 1.
- Player Size changes the size of the player.
- Player Height changes the height of the player.
- Base Speed changes the normal speed of the player. It's in absolute pixel values.
- Sprint Speed changes the speed of the player while holding sprint. It's relative to Base Speed.
Sprint Speed can be lower than Base Speed and act like a sneak instead of a sprint. 

### Initial Thoughts
- Stage width doesn't seem to matter much to perceived speed. Removed changing it.
- Add player height slider to see how the difference in width and height affect the perceived 
size of the character. Width is the main "size" of the character.
- Base speed is set in absolute values instead of relative to the character size cause perceived 
speed only feels loosely related to the size of the character.
- Sprint speed is now relative to the base speed. That feels like a better anchor than the player 
size.

### Takeaways
- Takeways at this point are personal preference.
- Height affects perceived size a small amount.
- With expected character size (32~ width, 80~ height), good feeling speeds are around 128 base 
speed, at most 160~ base speed, and 1.5 sprint speed. (There's a lot of room in pixel values 
to maintain the same feel but a different speed)
- Current feel is trying to make character not perceptually blur while sprinting.
