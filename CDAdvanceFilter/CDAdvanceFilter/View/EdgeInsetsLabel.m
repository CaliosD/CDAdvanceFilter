//
//  EdgeInsetsLabel.m
//  Stuaffairs
//
//  Created by Calios on 25/10/2016.
//  Copyright © 2016 SHTD. All rights reserved.
//

#import "EdgeInsetsLabel.h"

@implementation EdgeInsetsLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 8, 0, 8};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
