//
//  CDFilterCollectionViewHeader.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewHeader.h"

@interface CDFilterCollectionViewHeader()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation CDFilterCollectionViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [UILabel newAutoLayoutView];
        _titleLabel.textColor = [UIColor darkTextColor];
        _titleLabel.font = [UIFont systemFontOfSize:CDFilterCVOptionFont];
        
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, CDFilterCVPaddingLeft, 0, CDFilterCVPaddingRight)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - Public

- (void)configureCVHeaderWithTitle:(NSString *)title
{
    _titleLabel.text = (title && title.length > 0) ? title : @"";
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)configureCVHeaderWithModel:(id)model
{
    if (model) {
        
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
    }
}

@end
