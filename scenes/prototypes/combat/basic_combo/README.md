# Basic Combo Prototype
Prototype for the feel of a basic combo.

## Controls
- Press A or B button on gamepad or the 'K' or 'L' key on keyboard to swing.
- Swing again at the right time to chain the next attack.
- Swinging at the wrong time will lock the player, ending the combo early.
- The full combo is made up of the SwingStats in Swings.
- You can change up the swings by adding more or different SwingStats.
- SwingStats (all in seconds):
	- Up Swing: Is this swing up or down. Only visual.
	- Swing Time: How long the swings lasts.
	- Pause Time: How long the end of the swing lingers. The window to chain another swing.
	- Coyote Time: The window within Swing Time before Pause Time to chain another swing.

---

## Intents
- Figure out the flow for a basic melee attack.
- Parts of a melee attack:
  - Wind up
  - Swing
  - Follow through
- Possibly figure out how these string into combos.
  - Let there be a rhythm you can visually & audibally follow to time inputs.
- Timing of attacks
  - Focus on feel

## Non-Intents
- Hitbox sizes
- Working hitboxes
- Weapon types
  - This should not have to be tied to a specific weapon

---

## Takeaways
- Attacks having flow/follow through is important to the feel I'm going for.
- Have hitboxes move following through the attack.
- Instead of just having hitboxes activate like in a fighting game.
- Maybe have attack animations last a while and take time.
