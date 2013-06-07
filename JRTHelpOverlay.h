//
//  JRTHelpOverlay.h
//  HLiPad
//
//  Created by Richard Turton on 05/03/13.
//
//

@class JRTHelpObject;

/**
* View controllers implement this protocol to provide help objects for the overlay to display. The help overlay walks the view controller hierarchy and collects all of the help objects for the currently displayed content.
*/

@protocol JRTHelpOverlayHelpSource <NSObject>

/// An array of JRTHelpObjects representing the help enabled views in the view controller
-(NSArray*)helpObjects;

@end

/**
* The help overlay is presented in response to the help button being tapped.
 */

@interface JRTHelpOverlay : UIView

/// Presents the help overlay.
+ (void)presentFromViewController:(UIViewController *)viewController;
@end
