//
//  JRTHelpOverlay.m
//  HLiPad
//
//  Created by Richard Turton on 05/03/13.
//
//

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "JRTHelpOverlay.h"
#import "JRTHelpObject.h"
#import "MRDrawView.h"
#import "JRTHelpView.h"
#import "JRTHelpPopoverBackgroundView.h"

@interface JRTHelpOverlay ()
@property(nonatomic, strong) NSMutableArray *helpObjects;
@property (nonatomic, strong) UIView *maskingView;
@property(nonatomic, strong) UIPopoverController *popover;
@end

@implementation JRTHelpOverlay

#pragma mark - Class methods - presentation and data gathering

+(void)presentFromViewController:(UIViewController*)viewController
{
    NSMutableArray *helpObjects = [self collectHelpObjectsFromRootViewController:viewController];
    [self removeDuplicateHelpObjects:helpObjects];
    JRTHelpOverlay *overlay = [[self alloc] initWithFrame:viewController.view.bounds helpObjects:helpObjects];
    overlay.alpha = 0.0;
    [viewController.view addSubview:overlay];
    [overlay convertHelpObjectsToLocalCoordinates];
    [overlay buildMask];
    [overlay createHighlights];
    [UIView animateWithDuration:0.25 animations:^
    {
        overlay.alpha = 1.0;
    }];
}

+ (NSMutableArray *)collectHelpObjectsFromRootViewController:(UIViewController *)controller
{
    NSMutableArray *helpObjects = [NSMutableArray array];
    [helpObjects addObjectsFromArray:[self helpObjectsFromViewController:controller]];
    return helpObjects;
}

+ (NSMutableArray *)helpObjectsFromViewController:(UIViewController *)controller
{
    NSMutableArray *helpObjects = [NSMutableArray array];
    if ([controller conformsToProtocol:@protocol(JRTHelpOverlayHelpSource)])
    {
        [helpObjects addObjectsFromArray:[(UIViewController <JRTHelpOverlayHelpSource>*)controller helpObjects]];
    }

    CGRect parentFrameInWindowCoordinates = [controller.view convertRect:controller.view.bounds toView:nil];

    for (UIViewController *childController in controller.childViewControllers)
    {
        // Only do this if the child view controller is well within the current frame
        CGRect childFrameInWindowCoordinates = [childController.view convertRect:childController.view.bounds toView:nil];
        CGRect intersection = CGRectIntersection(parentFrameInWindowCoordinates, childFrameInWindowCoordinates);
        if (intersection.size.width > 10.0 && intersection.size.height > 10.0)
        {
            [helpObjects addObjectsFromArray:[self helpObjectsFromViewController:childController]];
        }
    }
    return helpObjects;
}

+ (void)removeDuplicateHelpObjects:(NSMutableArray *)helpObjects
{
    // Create a set of the identifiers in use
    NSSet *identifiers = [helpObjects valueForKey:@"identifier"];
    for (NSString *identifier in identifiers)
    {
        NSArray *matchingHelpObjects = [helpObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@",identifier]];
        NSUInteger count = [matchingHelpObjects count];
        if (count > 1)
        {
            [helpObjects removeObjectsInArray:[matchingHelpObjects subarrayWithRange:NSMakeRange(1, count - 1)]];
        }
    }
}
#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame helpObjects:(NSMutableArray *)aHelpObjects
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.maskingView = [[UIView alloc] initWithFrame:self.bounds];
        self.maskingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [self addSubview:self.maskingView];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self.maskingView addGestureRecognizer:tapGestureRecognizer];
        self.helpObjects = aHelpObjects;
    }
    return self;
}

#pragma mark - Handling the help objects

-(void)convertHelpObjectsToLocalCoordinates
{
    for (JRTHelpObject *helpObject in self.helpObjects)
    {
        CGRect nativeFrame = helpObject.view.bounds;
        nativeFrame = UIEdgeInsetsInsetRect(nativeFrame, helpObject.insets);
        CGRect localFrame = [helpObject.view convertRect:nativeFrame toView:self];
        helpObject.localFrame = localFrame;
    }
}

-(void)buildMask
{
    CAShapeLayer *layerMask = [CAShapeLayer layer];
    layerMask.frame = self.bounds;

    layerMask.backgroundColor = [UIColor clearColor].CGColor;
    layerMask.fillColor = [UIColor blackColor].CGColor;
    layerMask.fillRule = kCAFillRuleEvenOdd;
    self.maskingView.layer.mask = layerMask;

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:self.bounds];
    for (JRTHelpObject *helpObject in self.helpObjects)
    {
        [maskPath appendPath:[UIBezierPath bezierPathWithRect:helpObject.localFrame]];
    }
    layerMask.path = maskPath.CGPath;
}

-(void)createHighlights
{
    for (JRTHelpObject *helpObject in self.helpObjects)
    {
        UIView *highlightView = [self highlightViewWithFrame:CGRectIntegral(helpObject.localFrame)];
        [self addSubview:highlightView];
        helpObject.highlight = highlightView;
    }
}

-(UIView*)highlightViewWithFrame:(CGRect)frame
{
    MRDrawView *highlight = [[MRDrawView alloc] initWithFrame:CGRectInset(frame, -2.0, -2.0)];
    highlight.drawBlock = ^(UIView *view, CGContextRef context){

        [[UIColor blackColor] set];
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:view.bounds];
        shadowPath.lineWidth = 2.0;
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(1.0, 1.0), 4.0, [UIColor blackColor].CGColor);
        [shadowPath stroke];
        CGContextRestoreGState(context);

        [[UIColor whiteColor] set];
        CGRect borderRect = CGRectInset(view.bounds,1.0,1.0);
        UIBezierPath *border = [UIBezierPath bezierPathWithRect:borderRect];
        border.lineWidth = 2.0;
        [border stroke];
    };

    highlight.backgroundColor = [UIColor clearColor];
    highlight.userInteractionEnabled = NO;

    return highlight;

}

-(JRTHelpObject *)helpObjectAtPoint:(CGPoint)point
{
    for (JRTHelpObject *helpObject in self.helpObjects)
    {
        if (CGRectContainsPoint(helpObject.localFrame, point))
        {
            return helpObject;
        }
    }

    return nil;
}

#pragma mark - Touch handling

- (void)tapped:(UITapGestureRecognizer *)tapped
{
    JRTHelpObject *helpObject = [self helpObjectAtPoint:[tapped locationInView:self]];
    if (helpObject)
    {
        [self presentHelpPopoverWithHelpObject:helpObject];
    }
    else
    {
        [self.popover dismissPopoverAnimated:YES];
        [UIView animateWithDuration:0.25 animations:^
        {
            self.alpha = 0.0;
        } completion: ^(BOOL finished){
            [self removeFromSuperview];
        }
        ];
    }

}

- (void)presentHelpPopoverWithHelpObject:(JRTHelpObject *)helpObject
{
    [self.popover dismissPopoverAnimated:NO];
    JRTHelpView *helpView = [[JRTHelpView alloc] initWithHelpObject:helpObject];
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.view = helpView;
    viewController.contentSizeForViewInPopover = helpView.frame.size;
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
    popoverController.popoverBackgroundViewClass = [JRTHelpPopoverBackgroundView class];
    popoverController.passthroughViews = @[self];
    self.popover = popoverController;
    [popoverController presentPopoverFromRect:helpObject.highlight.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

@end
