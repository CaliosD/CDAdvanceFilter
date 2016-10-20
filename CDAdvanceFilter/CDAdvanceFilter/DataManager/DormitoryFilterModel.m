//
//  DormitoryFilterModel.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/29/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "DormitoryFilterModel.h"

@implementation DormitoryFilterModel

- (NSArray *)sectionsConfig
{
    return @[
             @{
                 CDFilterSectionFieldKey:@"applyYear",
                 CDFilterSectionColumnCountKey:@"3",
                 },
             @{
                 CDFilterSectionFieldKey:@"political",
                 CDFilterSectionColumnCountKey:@"4",
                 },
             @{
                 CDFilterSectionFieldKey:@"livein",
                 CDFilterSectionColumnCountKey:@"2",
                 }
             ];
}

@end
