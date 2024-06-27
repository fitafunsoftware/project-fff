# FrameManager
Base class for FrameManagers that help synchronize clients and servers.

## Functions To Override
- get_current_frame() -> Array
    - Returns the frame to be recorded. Frames are stored as Arrays with the 0th index being the frame time of the frame.
- frames_are_equal(frame: Array, to_compare: Array) -> bool
    - Compares two frames to see if they are equal. Returns true if the frames are considered equal and false if the frames are considered different enough to change.
- fix_frames(frame: Array, index: int)
    - Fix the frames array using the given frame at the given index.
- reconcile_differences()
    - Reconcile any changes that may have occured from fixing frames.
