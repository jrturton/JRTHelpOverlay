//
// Created by Richard Turton on 03/05/2013.
//

/**
* Objects representing a help item. View controllers implementing the JRTHelpOverlayHelpSource protocol will return an array of these objects representing the help-enabled parts of the interface. The JRTHelpOverlay will then create a highlight view for each help object currently on the screen.
*/

@interface JRTHelpObject : NSObject

/// Mandatory - the view to which the help item applies.
@property (nonatomic,strong) UIView *view;
/// Mandatory - an identifier for the type of view to eliminate duplicates
@property (nonatomic,strong) NSString *identifier;
/// Mandatory - the help text itself
@property (nonatomic,strong) NSString *helpText;
/// Optional - an image name to be displayed above the help text, will be used with UIImage's `imageNamed:` method.
@property (nonatomic,strong) NSString *imageIdentifier;
/// Optional - use this to adjust the highlight view's frame to a different size to that of the actual view, if required
@property (nonatomic) UIEdgeInsets insets;

/// The help overlay sets this to convert all frames to local coordinates.
@property (nonatomic) CGRect localFrame;
/// The help overlay sets this to aid display of the popover
@property (nonatomic, weak) UIView *highlight;

- (id)initWithView:(UIView *)view identifier:(NSString *)identifier helpText:(NSString *)helpText;

+ (id)helpObjectWithView:(UIView *)view identifier:(NSString *)identifier helpText:(NSString *)helpText;


@end

