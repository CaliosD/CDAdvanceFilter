//
//  CDFilterCollectionViewDateRangeCell.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/31/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewDateRangeCell.h"
#import "XYDateUtils.h"

#import <DateTools/NSDate+DateTools.h>


@interface CDFilterCollectionViewDateRangeCell()

@property (nonatomic, strong) UIDatePicker *startPicker;
@property (nonatomic, strong) UIDatePicker *endPicker;

@end

@implementation CDFilterCollectionViewDateRangeCell

- (void)setUp
{
    [super setUp];

    _startPicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _startPicker.datePickerMode = UIDatePickerModeDate;
    [_startPicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.startTF.inputView = _startPicker;
    
    _endPicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    _endPicker.datePickerMode = UIDatePickerModeDate;
    [_endPicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    self.endTF.inputView = _endPicker;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.startTF.text = @"";
    self.endTF.text = @"";
}

- (void)valueChanged:(UIDatePicker *)picker
{
    if ([picker isEqual:_startPicker]) {
        
        self.startTF.text = [XYDateUtils stringFromDate:_startPicker.date withFormat:CDFilterDateFormat];
        
        if (![self isValidStartDateTF:self.startTF  endDateTf:self.endTF]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始时间不能晚于结束时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.startTF.text = nil;
        }
    }
    else if ([picker isEqual:_endPicker]){
        
        self.endTF.text = [XYDateUtils stringFromDate:_endPicker.date withFormat:CDFilterDateFormat];
        
        if (![self isValidStartDateTF:self.startTF  endDateTf:self.endTF]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间不能早于开始时间" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            self.endTF.text = nil;
        }
    }
    self.option.value = @[self.startTF.text,self.endTF.text];
}

#pragma mark - CDFilterCollectionCellProtocol

- (NSDictionary *)currentValue
{
    NSMutableString *result = [NSMutableString string];
    if (!CDFilter_stringIsBlank(self.startTF.text)) {
        [result appendString:[XYDateUtils stringFromDate:_startPicker.date withFormat:CDFilterDateFormat]];
    }
    if (!CDFilter_stringIsBlank(self.endTF.text)) {
        [result appendString:@","];
        [result appendString:[XYDateUtils stringFromDate:_endPicker.date withFormat:CDFilterDateFormat]];
    }
    else {
        if (!CDFilter_stringIsBlank(self.startTF.text)) {
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
                NSString *s = [tmpArray firstObject];
                NSString *e = [tmpArray lastObject];
                self.startTF.text = s;
                self.endTF.text = e;
                if (s.length > 0) {
                    [_startPicker setDate:[XYDateUtils dateFromString:s withFormat:CDFilterDateFormat]];
                }
                if (e.length > 0) {
                    [_endPicker setDate:[XYDateUtils dateFromString:e withFormat:CDFilterDateFormat]];
                }
            }
        }
    }
    else{
        if ([option.sectionTitle hasSuffix:@"时间"]){
            self.startTF.placeholder = @"开始时间";
            self.endTF.placeholder   = @"结束时间";
        }
        else if ([option.sectionTitle hasSuffix:@"日期"]) {
            self.startTF.placeholder = @"开始日期";
            self.endTF.placeholder   = @"结束日期";
        }
        
        self.startTF.text = nil;
        self.endTF.text = nil;
    }
}

- (void)clearOption
{
    self.startTF.text = nil;
    self.endTF.text = nil;
    [_startPicker setDate:[NSDate date]];
    [_endPicker setDate:[NSDate date]];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!CDFilter_stringIsBlank(self.startTF.text)) {
        [_startPicker setDate:[XYDateUtils dateFromString:self.startTF.text withFormat:CDFilterDateFormat]];
    }
    else
    {
        [_startPicker setDate:[NSDate date]];
    }
    
    if (!CDFilter_stringIsBlank(self.endTF.text)) {
        [_endPicker setDate:[XYDateUtils dateFromString:self.endTF.text withFormat:CDFilterDateFormat]];
    }
    else
    {
        [_endPicker setDate:[NSDate date]];
    }
    
    if ([self.option.sectionField isEqualToString:@"punishDate"]) {
        if ([textField isEqual:self.startTF]) {
            if (CDFilter_stringIsBlank(self.startTF.text) && !CDFilter_stringIsBlank(self.endTF.text)) {
                
                NSDate * date = [XYDateUtils dateFromString:self.endTF.text withFormat:CDFilterDateFormat];
                NSDate *nowDate = [date dateByAddingTimeInterval:-24*60*60];
                [_startPicker setDate:nowDate];
            }
        }
        if ([textField isEqual:self.endTF]) {
            if (CDFilter_stringIsBlank(self.endTF.text) && !CDFilter_stringIsBlank(self.startTF.text)) {
                
                NSDate * date = [XYDateUtils dateFromString:self.startTF.text withFormat:CDFilterDateFormat];
                NSDate *nowDate = [date dateByAddingTimeInterval:24*60*60];
                [_endPicker setDate:nowDate];
                
            }
        }
    }
    else
    {
        if ([textField isEqual:self.startTF]) {
            if (CDFilter_stringIsBlank(self.startTF.text) && !CDFilter_stringIsBlank(self.endTF.text)) {
                
                NSDate * date = [XYDateUtils dateFromString:self.endTF.text withFormat:CDFilterDateFormat];
                NSDate *nowDate = [date dateByAddingTimeInterval:-24*60*60];
                [_startPicker setDate:nowDate];
            }
        }
        if ([textField isEqual:self.endTF]) {
            if (CDFilter_stringIsBlank(self.endTF.text) && !CDFilter_stringIsBlank(self.startTF.text)) {
                
                NSDate * date = [XYDateUtils dateFromString:self.startTF.text withFormat:CDFilterDateFormat];
                NSDate *nowDate = [date dateByAddingTimeInterval:24*60*60];
                [_endPicker setDate:nowDate];
            }
        }
    }
    return YES;
}

- (BOOL)isValidStartDateTF:(UITextField *)startDateTF endDateTf:(UITextField *)endDateTF
{
    if (!CDFilter_stringIsBlank(self.startTF.text)  && !CDFilter_stringIsBlank(self.endTF.text)) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *startDate = [formatter dateFromString:startDateTF.text];
        NSDate *endDate   = [formatter dateFromString:endDateTF.text];
        
        if ([startDate isLaterThan:endDate]) {
            return NO;
        }
    }
    return YES;
}

@end
