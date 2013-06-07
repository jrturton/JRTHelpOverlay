JRTHelpOverlay
==============

Help overlay for iOS. Passes through the view controller hierarchy (from the root view controller the overlay is presented on) and asks for help objects. These are then represented as highlighted areas on an overlay view, which open a custom popovercontroller containing text and / or images when tapped.

Known issues:

- Can get messy if your highlighted help objects are close together and the popover obscures the objects underneath.
