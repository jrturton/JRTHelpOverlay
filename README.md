JRTHelpOverlay
==============

Help overlay for iPad (depends on UIPopoverController, so not available for iPhone). Passes through the view controller hierarchy (from the root view controller the overlay is presented on) and asks for help objects. These are then represented as highlighted areas on an overlay view, which open a custom popovercontroller containing text and / or images when tapped.

##Implementation

- Include QuartzCore in your project
- Make your view controllers conform to the protocol and return an array of help objects for any views of interest
- Call `+ (void)presentFromViewController:(UIViewController *)viewController;` on JRTHelpOverlay to present the help view. Typically `viewController` will be the root view controller of the window. 

##Known issues:

- Can get messy if your highlighted help objects are close together and the popover obscures the objects underneath.
