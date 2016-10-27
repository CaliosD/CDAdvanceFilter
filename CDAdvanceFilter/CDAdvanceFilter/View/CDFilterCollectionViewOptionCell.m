//
//  CDFilterCollectionViewOptionCell.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewOptionCell.h"
#import "EdgeInsetsLabel.h"

@interface CDFilterCollectionViewOptionCell()

@property (nonatomic, strong) UILabel  *optionLabel;
@property (nonatomic, assign) BOOL     didSetupConstraints;

@end

@implementation CDFilterCollectionViewOptionCell

- (void)setUp
{
    _optionLabel = [EdgeInsetsLabel newAutoLayoutView];
    
    _optionLabel.backgroundColor = [UIColor whiteColor];
    _optionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _optionLabel.textColor = CDFilterThemeColor;
    _optionLabel.numberOfLines = 1;
    _optionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _optionLabel.textAlignment = NSTextAlignmentCenter;
    _optionLabel.font = [UIFont systemFontOfSize:CDFilterCVOptionFont];
    _optionLabel.layer.borderColor = CDFilterThemeColor.CGColor;
    _optionLabel.layer.borderWidth = 1.f;
    _optionLabel.layer.cornerRadius = 3.f;
    _optionLabel.clipsToBounds = YES;
    
    [self.contentView addSubview:_optionLabel];
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [_optionLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CDFilterCVPaddingTop, CDFilterCVPaddingLeft, CDFilterCVPaddingBottom, CDFilterCVPaddingRight)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - CDFilterCollectionCellProtocol

- (void)configureCellWithOption:(CDFilterOption *)option
{
    self.option = option;

    _optionLabel.text = [self displayTextWithOption:option];
}

- (NSDictionary *)paramWithOption:(CDFilterOption *)option
{
    if (option.optionClass && option.option) {
        if ([option.option isKindOfClass:[NSString class]]) {
            return @{option.sectionField : option.option};
        }
        else if([option.option isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)option.option;
            for (NSString *key in [dict allKeys]) {
                if ([key hasSuffix:@"Id"]) {
                    return @{option.sectionField : dict[key]};
                }
            }
        }
    }
    return nil;
}

- (void)clearOption
{
    [self setSelected:NO];
}

#pragma mark - Public

- (void)setSelected:(BOOL)selected
{
    self.option.value = (self.isSelected) ? self.option.option :nil;

    _optionLabel.backgroundColor = selected ? CDFilterThemeColor : [UIColor whiteColor];
    _optionLabel.layer.borderWidth = 1.f;
    _optionLabel.layer.borderColor = CDFilterThemeColor.CGColor;
    _optionLabel.textColor = selected ? [UIColor whiteColor] : CDFilterThemeColor;
}

#pragma mark - Private

- (NSString *)displayTextWithOption:(CDFilterOption *)option
{
    if (option.optionClass && option.option) {
        if ([option.option isKindOfClass:[NSString class]]) {
            return option.option;
        }
        else if([option.option isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary *)option.option;
            for (NSString *key in [dict allKeys]) {
                if ([key hasSuffix:@"Title"] || [key hasSuffix:@"Value"]) {
                    return dict[key];
                }
            }
        }
    }
    return nil;
}

@end
