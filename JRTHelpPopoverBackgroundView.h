//
//  JRTHelpPopoverBackgroundView.h
//  HLiPad
//
//  Created by Richard Turton on 05/10/13.
//
//

#import <UIKit/UIPopoverBackgroundView.h>

@interface JRTHelpPopoverBackgroundView : UIPopoverBackgroundView

+(UIEdgeInsets)contentViewInsets;
+(CGFloat)arrowHeight;
+(CGFloat)arrowBase;

@property(nonatomic,readwrite) CGFloat arrowOffset;
@property(nonatomic,readwrite) UIPopoverArrowDirection arrowDirection;

@end
