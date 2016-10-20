//
//  CDFilterCollectionViewInputCell.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewInputCell.h"

@interface CDFilterCollectionViewInputCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, assign) BOOL        didSetupConstraints;

@end

@implementation CDFilterCollectionViewInputCell

- (void)setUp
{
    _inputTF = [UITextField newAutoLayoutView];
    _inputTF.borderStyle = UITextBorderStyleRoundedRect;
    _inputTF.textColor = [UIColor darkTextColor];
    _inputTF.font = [UIFont systemFontOfSize:CDFilterCVOptionFont];
    _inputTF.returnKeyType = UIReturnKeyDone;
    _inputTF.delegate = self;
    
    [self.contentView addSubview:_inputTF];
    
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:_inputTF action:NSSelectorFromString(@"becomeFirstResponder")]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:_inputTF];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _inputTF.text = @"";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _inputTF.delegate = nil;
}

- (void)textDidChange
{
    [self updateCurrentValue];
}

#pragma mark - Layout

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    if (!self.didSetupConstraints) {

        [_inputTF autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(CDFilterCVPaddingTop, CDFilterCVPaddingLeft, CDFilterCVPaddingBottom, CDFilterCVPaddingRight)];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

#pragma mark - CDFilterCollectionCellProtocol

- (NSDictionary *)currentValue
{
    return @{self.option.sectionField : _inputTF.text};
}

- (void)configureCellWithOption:(CDFilterOption *)option
{
    self.option = option;
    
    if (option.value && !CDFilter_stringIsBlank(option.value)) {
        _inputTF.text = option.value;
    }
    else{
        _inputTF.placeholder = option.sectionTitle;
    }
}

- (void)clearOption
{
    _inputTF.text = nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_inputTF resignFirstResponder];
    return NO;
}

- (void)updateCurrentValue
{
    self.option.value = _inputTF.text;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [_inputTF becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_inputTF resignFirstResponder];
}

@end
