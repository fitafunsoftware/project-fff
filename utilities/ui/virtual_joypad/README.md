# Virtual Joypad
Collection of utilities for touch screen joypads.

## VirtualJoystick
A virtual joystick utility to make InputEventActions out of touch inputs. The inputs can either be snapped to the cardinal directions or be normalized values.<br>

The joystick values are mapped to InputEventActions for more flexibility. Note that the negative y action of the joystick relates to the up direction and the positive y action relates to the down direction.

### Static
A static joystick is a joystick with a fixed position at the center of the area. Touching a position in the area of the joystick moves the joystick in that direction.

### Floating
A floating joystick is a joystick without a fixed position in its area. Touching a position in the area of the joystick places the joystick at that position. Then, a drag is required to move the joystick in the desired direction.

## ActionButton
A virtual button utility to make InputEventActions out of touch inputs. Input strengths are either 0.0 for released or 1.0 for pressed.

