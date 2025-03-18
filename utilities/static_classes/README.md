# Static Classes
A bunch of static classes meant to act as helper classes to organize functions.

## GlobalParams
The `GlobalParams` static class meant to be used to retrieve global parameters. This static class 
should be used instead of the `GameGlobalParams` autoload. This manages whether to use the 
`EditorGlobalParams` or `GameGlobalParams` depending on where the game is running, in editor or 
actually running.

## InputHelper
A collection of static functions meant to help with input handling.
