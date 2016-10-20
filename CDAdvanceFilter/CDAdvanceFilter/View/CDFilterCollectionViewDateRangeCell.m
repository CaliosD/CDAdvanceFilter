//
//  CDFilterCollectionViewDateRangeCell.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/31/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewDateRangeCell.h"
#import "XYDateUtils.h"

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
    }
    else if ([picker isEqual:_endPicker]){
        self.endTF.text = [XYDateUtils stringFromDate:_endPicker.date withFormat:CDFilterDateFormat];
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

@end
