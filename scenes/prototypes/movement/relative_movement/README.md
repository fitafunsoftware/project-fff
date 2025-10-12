# Relative Movement Prototype
Prototype to test values for character movement.

## Controls
- Moves only left and right. Use the A and D keys, left thumbstick, or D-pad.
- Hold Shift or Left Trigger to Sprint.
- Press the buttons on-screen to change the values:
  - Up and down buttons on the left change the value by 10.
  - Up and down buttons on the right change the value by 1.
- Stage Width changes the apparent size of the stage.
- Player Size changes the size of the player. Player is a square.
- Base Speed changes the normal speed of the player. It's relative to the size of the player.
- Sprint Speed changes the speed of the player while holding sprint. It's relative to the size 
of the player. Sprint Speed can be lower than Base Speed and act like a sneak instead of a sprint.

## Initial Thoughts
- Figuring out good values for the movement speeds of the player character.
- Assuming that what feels right depends on how big the stage feels, like the width of the stage,
and how small the character is relative to the stage.
- Speeds are relative to the size of the player. Once again, just assuming that relative values 
matter more than absolute values.
- Size of the screen, not the stage, will probably matter as well. How much of your vision it takes
up and how far away you are from it. Like relative screen size.

