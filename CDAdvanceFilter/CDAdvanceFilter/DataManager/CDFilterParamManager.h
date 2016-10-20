//
//  CDFilterParamManager.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDFilterSection.h"

@interface CDFilterParamManager : NSObject

/**
 *  Params for both slide filter and pull-down filter.
 */
@property (nonatomic, strong) NSMutableDictionary *currentParams;
/**
 *  Data source for complete filter(json), set only once.
 */
@property (nonatomic, strong) NSArray *dataSource;
/**
 *  Data source( of `CDFilterSection`) for slide filter.
 */
@property (nonatomic, strong, readonly) NSArray *slideFilterDataSource;
/**
 *  Whether current params contains any available values.
 */
@property (nonatomic, assign, readonly) BOOL isFiltering;
/**
 *  Selected indexPaths for slide filter.
 */
@property (nonatomic, strong) NSArray *slideFilterSelectedIndexPaths;

/**
 *  Initialize param manager with `CDAdvanceFilter` supported object.
 */
- (instancetype)initWithFilter:(id<CDAdvanceFilter>)filter;

/**
 *  Reset all the current params and pull down params.
 */
- (void)resetFilterParams;

/**
 *  Print important propertyies. Only used to test.
 */
- (void)propertyPreview;

@end
