//
// Created by Richard Turton on 03/05/2013.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "JRTHelpObject.h"

@implementation JRTHelpObject
- (id)initWithView:(UIView *)view identifier:(NSString *)identifier helpText:(NSString *)helpText
{
    self = [super init];
    if (self)
    {
        self.view = view;
        self.identifier=identifier;
        self.helpText=helpText;
    }

    return self;
}

+ (id)helpObjectWithView:(UIView *)view identifier:(NSString *)identifier helpText:(NSString *)helpText
{
    return [[self alloc] initWithView:view identifier:identifier helpText:helpText];
}

@end

