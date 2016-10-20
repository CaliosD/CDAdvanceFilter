//
//  CDAdvanceFilter.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//


/**
 ToDoList:

 1.Syn with finished project code.
 2.Support iPad.
 3.Support multiple option && selector.
 4.Support custom UI configurations.
 5. ...
 
 
 */


#import <Foundation/Foundation.h>

// Controllers
#import "CDAdvanceFilterController.h"
#import "CDAdvanceFilterViewController.h"


// Cells
#import "CDFilterCollectionViewHeader.h"
#import "CDFilterCollectionViewInputCell.h"
#import "CDFilterCollectionViewOptionCell.h"
#import "CDFilterCollectionViewDateRangeCell.h"


// Colors
#define CDFilterThemeColor               [UIColor colorWithRed: 0.396 green: 0.604 blue: 0.871 alpha: 1]
#define CDAdvanceFilterViewLeftPadding   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 50 : 100


// Utility
#define CDFilter_isiPhone                ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define CDFilter_kScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define CDFilter_kScreenHeight           [[UIScreen mainScreen] bounds].size.height
#define CDFilter_kNavigationBarHeight    44
#define CDFilter_kStatusBarHeight        20
#define CDFilter_kTabBarHeight           49
#define CDFilter_stringIsBlank(string)   (!string || [string length] == 0 || [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0)


// Size
#define CDFilterCVCellOptionHeight  CDFilter_isiPhone ? 45 : 50
#define CDFilterCVHeaderFont        CDFilter_isiPhone ? 15 : 20
#define CDFilterCVOptionFont        CDFilter_isiPhone ? 12 : 15
#define CDFilterCVPaddingLeft       CDFilter_isiPhone ? 8 : 12
#define CDFilterCVPaddingRight      CDFilter_isiPhone ? 8 : 12
#define CDFilterCVPaddingTop        CDFilter_isiPhone ? 8 : 12
#define CDFilterCVPaddingBottom     CDFilter_isiPhone ? 8 : 12


// Section Keys
extern NSString *const CDFilterSectionFieldKey;
extern NSString *const CDFilterSectionTitleKey;
extern NSString *const CDFilterSectionTypeKey;
extern NSString *const CDFilterSectionOptionsKey;
extern NSString *const CDFilterSectionColumnCountKey;
extern NSString *const CDFilterOptionClassKey;
extern NSString *const CDFilterCellClassKey;


// Cell Types
extern NSString *const CDFilterCVCellTypeInput;
extern NSString *const CDFilterCVCellTypeSingleOption;
extern NSString *const CDFilterCVCellTypeMultipleOption;
extern NSString *const CDFilterCVCellTypeNormalRange;
extern NSString *const CDFilterCVCellTypeDateRange;
extern NSString *const CDFilterCVCellTypeSelector;


// Global Configurations
extern NSString *const CDFilterDateFormat;

