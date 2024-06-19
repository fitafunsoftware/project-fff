# StateMachine
A basic implementation of the State Machine pattern. Supports push down states and overwrite states.

# State
A basic implementation of the State in a State Machine. Extend this class to make your own custom States in code.
<br>Has the following hooks:
- enter
- resume
- exit
- seek
- handle_input
- update
- on_animation_finished

## ComponentState
An extension of the State class that lets you compose States in-editor as nodes using StateComponents.

### StateComponents
A set of components that help to compose a ComponentState in-editor. While these base StateComponents cover a good amount of situations, feel free to extend your own StateComponents that are more specific to your needs.
