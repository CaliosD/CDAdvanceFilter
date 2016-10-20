//
//  CDFilterSection.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/29/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFilterSection : NSObject

@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, copy) NSString *sectionField;
@property (nonatomic, copy) NSString *sectionType;
@property (nonatomic, copy) NSArray  *options;


// Private
@property (nonatomic        ) Class     optionClass;
@property (nonatomic        ) Class     cellClass;
@property (nonatomic, assign) NSInteger columnCount;
/**
 *  `CDFilterCVCellTypeInput`: input text;
 *  `CDFilterCVCellTypeSingleOption` or `CDFilterCVCellTypeMultipleOption`: selected indexes(seperated by `,`);
 *  `CDFilterCVCellTypeNormalRange` or `CDFilterCVCellTypeDateRange`: input texts(seperated by `,`);
 *  `CDFilterCVCellTypeSelector`: selected index.
 */
@property (nonatomic, copy)   NSString  *value;

@end
