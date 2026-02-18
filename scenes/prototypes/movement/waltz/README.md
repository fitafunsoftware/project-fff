# Waltz Prototype
Prototype to get a feel for chasing down an optimal position. Named "Waltz" to emphasize a 
dance-like feel.

## Controls and Preamble
- Moves only left and right. Use the A and D keys, left thumbstick, or D-pad.
- Hold Shift, Left Trigger, or Right Trigger to sprint.
- Change speed values in Editor since that's not the focus of this prototype.
- Objective is to stay within the green zone (Goal) as long as possible.
- Goal starts moving randomly after set amount of time.
- Goal can sprint and stop in place.
- Goal's speed is set in Editor.

## Initial Thoughts
- Meant to emulate the feel of positioning and repositioning yourself during play.
- In-game, Goal would be where you wanna get to.
- Movement might feel like it's at a good speed, but might not feel good for repositioning.

## Takeaways
- Might not properly emulate the idea I'm going for.
  - Have a goal position I want to go to, instead of an area I want to be in.
- Following initial goal of a waltz.
  - Give the player enough time to get to their desired position.
  - Or give the player the proper tools to catch up to their desired position.
- Ignoring initial goal, if player is trying to stay within a moving area.
  - Take note of the players speed.
  - Keep speed of moving area slightly below player speed (base/sprint).
  - It's easier for player to stop and let the area catch up than it is for player to on/off 
  sprint to keep up.