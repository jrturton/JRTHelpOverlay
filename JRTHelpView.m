//
// Created by Richard Turton on 10/05/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JRTHelpView.h"
#import "JRTHelpObject.h"

static const CGFloat overlayWidth = 180.0;

@implementation JRTHelpView
{

}
- (id)initWithHelpObject:(JRTHelpObject *)helpObject
{
    // Work out the text size
    UIFont *font = [UIFont systemFontOfSize:18.0];
    CGSize textSize = [helpObject.helpText sizeWithFont:font constrainedToSize:CGSizeMake(overlayWidth, HUGE_VALF) lineBreakMode:NSLineBreakByWordWrapping];
    
    // Work out the image size
    UIImage *image = [UIImage imageNamed:helpObject.imageIdentifier];

    static const CGFloat imageVerticalPadding = 10.0;
    
    self = [super initWithFrame:CGRectIntegral(CGRectMake(0.0, 0.0, fmax(image.size.width, textSize.width), textSize.height + image.size.height + 2.0 * imageVerticalPadding))];
    if (self)
    {
        if (image)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            [self addSubview:imageView];
            CGPoint center = imageView.center;
            center.x = 0.5 * self.bounds.size.width;
            center.y += imageVerticalPadding;
            imageView.center = center;
        }
    
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectIntegral((CGRect){.origin.x = 0.0, .origin.y = image.size.height + 2.0 * imageVerticalPadding, .size = textSize})];
        label.font = font;
        label.numberOfLines = 0;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.preferredMaxLayoutWidth = overlayWidth;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.text = helpObject.helpText;
        [self addSubview:label];
        
    }
    return self;
}
@end
