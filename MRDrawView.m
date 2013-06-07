//
//  MRDrawView.m
//  HLiPad
//
//  Created by Brett Meader on 17/12/2012.
//
//

#import "MRDrawView.h"

@implementation MRDrawView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.drawBlock)
        self.drawBlock(self,context);
}
@end
