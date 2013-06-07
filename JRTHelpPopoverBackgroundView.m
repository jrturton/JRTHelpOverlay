//
//  JRTHelpPopoverBackgroundView.m
//  HLiPad
//
//  Created by Richard Turton on 05/10/13.
//
//

#import "JRTHelpPopoverBackgroundView.h"
#import "MRDrawView.h"

@interface JRTHelpPopoverBackgroundView ()

@property (nonatomic,strong) UIView *arrow;
@property (nonatomic,strong) UIView *background;
@end

@implementation JRTHelpPopoverBackgroundView

{
    CGFloat _arrowOffset;
    UIPopoverArrowDirection _arrowDirection;
}

+(UIEdgeInsets)contentViewInsets
{
    return UIEdgeInsetsZero;
}

+(CGFloat)arrowHeight
{
    return 60.0;
}

+(CGFloat)arrowBase;
{
    return 10.0;
}

-(void)setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

-(CGFloat)arrowOffset
{
    return _arrowOffset;
}

-(void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;

    switch (arrowDirection)
    {
        case UIPopoverArrowDirectionDown:
            self.arrow.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIPopoverArrowDirectionLeft:
            self.arrow.transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIPopoverArrowDirectionRight:
            self.arrow.transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIPopoverArrowDirectionUp:
            break;
        default:
            break;
    }
    [self setNeedsLayout];
}

-(UIPopoverArrowDirection)arrowDirection
{
    return _arrowDirection;
}

-(void)layoutSubviews
{
    CGFloat arrowHeight = [[self class] arrowHeight];

    CGFloat halfFrameWidth = self.frame.size.width * 0.5;
    CGFloat halfFrameHeight = self.frame.size.height * 0.5;
    CGFloat frameAdjustment = arrowHeight - 1.0;

    // The background frame needs to be inset by the arrow, whichever side it is on
    CGRect backgroundFrame = self.bounds;

    switch (self.arrowDirection) {

        case UIPopoverArrowDirectionUp:
            // Frame needs shortening and origin moving down
            backgroundFrame.origin.y = frameAdjustment;
            backgroundFrame.size.height -= frameAdjustment;

            // Arrow needs moving in by half the offset
            self.arrow.center = CGPointMake(halfFrameWidth + self.arrowOffset, arrowHeight * 0.5);
            break;

        case UIPopoverArrowDirectionDown:
            // Frame needs shortening
            backgroundFrame.size.height -= frameAdjustment;

            // Arrow needs moving in and placing at the bottom
            self.arrow.center = CGPointMake(halfFrameWidth + self.arrowOffset, CGRectGetMaxY(backgroundFrame) + arrowHeight * 0.5);
            break;

        case UIPopoverArrowDirectionLeft:
            // Frame needs narrowing and origin moving left
            backgroundFrame.origin.x = frameAdjustment;
            backgroundFrame.size.width -= frameAdjustment;

            // Arrow needs moving down
            self.arrow.center = CGPointMake(arrowHeight * 0.5,halfFrameHeight + self.arrowOffset);
            break;

        case UIPopoverArrowDirectionRight:
            frameAdjustment += 1.0;
            // Frame needs narrowing
            backgroundFrame.size.width -= frameAdjustment;

            // Arrow needs moving down and to the right
            self.arrow.center = CGPointMake(CGRectGetMaxX(backgroundFrame) - 1.0 + arrowHeight * 0.5, halfFrameHeight + self.arrowOffset);
            break;
        default:
            break;
    }

    self.background.frame = CGRectIntegral(backgroundFrame);

    [self bringSubviewToFront:self.arrow];
}

-(UIView*)arrow
{
    if (_arrow) return _arrow;

    MRDrawView *arrow = [[MRDrawView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[self class] arrowBase], [[self class] arrowHeight])];
    arrow.backgroundColor = [UIColor clearColor];
    arrow.drawBlock = ^(UIView* view, CGContextRef context){
        [[UIColor whiteColor] set];
        CGRect lineFrame = CGRectInset(view.bounds, 0.5 * (view.bounds.size.width - 2.0), 0.0);
        [[UIBezierPath bezierPathWithRect:lineFrame] fill];
        CGRect blobFrame = UIEdgeInsetsInsetRect(view.bounds, UIEdgeInsetsMake(view.bounds.size.height - view.bounds.size.width, 0.0, 0.0, 0.0));
        [[UIBezierPath bezierPathWithOvalInRect:blobFrame] fill];
    };
    [self addSubview:arrow];
    _arrow = arrow;
    return _arrow;
}

+(BOOL)wantsDefaultContentAppearance
{
    return NO;
}
@end
