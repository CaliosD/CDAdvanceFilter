//
//  CDAdvanceFilter.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDAdvanceFilter.h"

NSString *const CDFilterSectionTitleKey          = @"sectionTitle";
NSString *const CDFilterSectionFieldKey          = @"sectionField";
NSString *const CDFilterSectionTypeKey           = @"sectionType";
NSString *const CDFilterSectionOptionsKey        = @"options";
NSString *const CDFilterSectionColumnCountKey    = @"columnCount";
NSString *const CDFilterOptionClassKey           = @"optionClass";
NSString *const CDFilterCellClassKey             = @"cellClass";


NSString *const CDFilterCVCellTypeInput          = @"input";
NSString *const CDFilterCVCellTypeSingleOption   = @"singleOption";
NSString *const CDFilterCVCellTypeMultipleOption = @"multipleOption";// TODO: not handled.
NSString *const CDFilterCVCellTypeNormalRange    = @"normalRange";
NSString *const CDFilterCVCellTypeDateRange      = @"dateRange";
NSString *const CDFilterCVCellTypeSelector       = @"selector";// TODO: not handled.


NSString *const CDFilterDateFormat               = @"yyyy-MM-dd";
