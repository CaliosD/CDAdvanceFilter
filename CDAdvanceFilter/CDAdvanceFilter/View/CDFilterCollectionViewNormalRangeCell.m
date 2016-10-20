//
//  CDFilterCollectionViewNormalRangeCell.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewNormalRangeCell.h"

@interface CDFilterCollectionViewNormalRangeCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel     *seperatorLabel;

@property (nonatomic, assign) BOOL        didSetupConstraints;

@end

@implementation CDFilterCollectionViewNormalRangeCell

- (void)setUp
{
    _startTF = [UITextField newAutoLayoutView];
    _startTF.borderStyle = UITextBorderStyleRoundedRect;
    _startTF.textColor = [UIColor darkTextColor];
    _startTF.font = [UIFont systemFontOfSize:CDFilterCVOptionFont];
    _startTF.delegate = self;
    
    _endTF = [UITextField newAutoLayoutView];
    _endTF.borderStyle = UITextBorderStyleRoundedRect;
    _endTF.textColor = [UIColor darkTextColor];
    _endTF.font = [UIFont systemFontOfSize:CDFilterCVOptionFont];
    _endTF.delegate = self;
    
    _seperatorLabel = [UILabel newAutoLayoutView];
    _seperatorLabel.textAlignment = NSTextAlignmentCenter;
    _seperatorLabel.textColor = [UIColor lightGrayColor];
    _seperatorLabel.text = @"—";
    
    [self.contentView addSubview:_startTF];
    [self.contentView addSubview:_endTF];
    [self.contentView addSubview:_seperatorLabel];
    
    _startTF.keyboardType = UIKeyboardTypeNumberPad;
    _endTF.keyboardType   = UIKeyboardTypeNumberPad;
    _startTF.placeholder  = @"查询下限";
    _endTF.placeholder    = @"查询上限";
    
    // ❓
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:_startTF];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:_endTF];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _startTF.delegate = nil;
    _endTF.delegate = nil;
}

//- (void)textDidChange
//{
//    [self updateCurrentValue];
//}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _startTF.text = @"";
    _endTF.text = @"";
}

#pragma mark - Layout

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {
        
        [_startTF autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CDFilterCVPaddingTop, CDFilterCVPaddingLeft, CDFilterCVPaddingBottom, 0) excludingEdge:ALEdgeTrailing];
        [_endTF autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CDFilterCVPaddingTop, 0, CDFilterCVPaddingBottom, CDFilterCVPaddingRight * 6) excludingEdge:ALEdgeLeading];
        [_seperatorLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:CDFilterCVPaddingTop];
        [_seperatorLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:CDFilterCVPaddingBottom];
        [_seperatorLabel autoSetDimension:ALDimensionWidth toSize:30];
        [_seperatorLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:_startTF withOffset:CDFilterCVPaddingLeft];
        [_endTF autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:_seperatorLabel withOffset:CDFilterCVPaddingRight];
        [@[_startTF, _endTF] autoMatchViewsDimension:ALDimensionWidth];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - CDFilterCollectionCellProtocol

- (NSDictionary *)currentValue
{
    NSMutableString *result = [NSMutableString string];
    if (!CDFilter_stringIsBlank(_startTF.text)) {
        [result appendString:_startTF.text];
    }
    if (!CDFilter_stringIsBlank(_endTF.text)) {
        [result appendString:@","];
        [result appendString:_endTF.text];
    }
    else {
        if (!CDFilter_stringIsBlank(_startTF.text)) {
            [result appendString:@","];
        }
    }
    
    return @{self.option.sectionField : result};
}

- (void)configureCellWithOption:(CDFilterOption *)option
{
    self.option = option;
    
    if (option.value && !CDFilter_stringIsBlank(option.value)) {
        NSString *tmp = option.value;
        
        if ([tmp containsString:@","]) {
            NSArray *tmpArray = [tmp componentsSeparatedByString:@","];
            if (tmpArray.count == 2) {
                _startTF.text = [tmpArray firstObject];
                _endTF.text = [tmpArray lastObject];
            }
        }
    }
    else{
        _startTF.text = nil;
        _endTF.text = nil;
    }
}

- (void)clearOption
{
    _startTF.text = nil;
    _endTF.text = nil;
}

@end
