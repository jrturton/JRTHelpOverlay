//
//  MRDrawView.h
//  HLiPad
//
//  Created by Brett Meader on 17/12/2012.
//
//

#import <UIKit/UIKit.h>

typedef void(^DrawBlock)(UIView* v,CGContextRef context);

@interface MRDrawView : UIView
@property (nonatomic, copy) DrawBlock drawBlock;
@end
