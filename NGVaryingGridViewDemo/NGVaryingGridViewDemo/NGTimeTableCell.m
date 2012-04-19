//
//  NGTimeTableCell.m
//  NGVaryingGridViewDemo
//
//  Created by Philip Messlehner on 19.04.12.
//  Copyright (c) 2012 NOUS Wissensmanagement GmbH. All rights reserved.
//

#import "NGTimeTableCell.h"

@implementation NGTimeTableCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textAlignment = UITextAlignmentCenter;
        self.backgroundColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:11.f];
        self.numberOfLines = 0;
        self.lineBreakMode = UILineBreakModeWordWrap;
        CALayer *layer = self.layer;
        layer.cornerRadius = 5.f;
        layer.masksToBounds = YES;
        layer.borderWidth = 1.f;
        layer.borderColor = [[UIColor darkGrayColor] CGColor];
        
    }
    return self;
}

@end
