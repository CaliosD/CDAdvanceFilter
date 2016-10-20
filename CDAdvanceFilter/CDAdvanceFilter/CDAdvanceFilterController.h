//
//  CDAdvanceFilterController.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/29/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CDAdvanceFilterControllerDelegate <UICollectionViewDelegate>

@end

@protocol CDAdvanceFilter <NSObject>

@required
- (NSArray *)sectionsConfig;

@optional
- (NSArray *)pullDownKeys;

@end

@interface CDAdvanceFilterController : NSObject

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak)   id<CDAdvanceFilter> filterModel;
@property (nonatomic, weak)   id<CDAdvanceFilterControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *filterSections;

@property (nonatomic, strong) NSDictionary *currentFilterDict;
@property (nonatomic, strong) NSMutableDictionary *selectedParamDict;
@property (nonatomic, strong) NSArray<NSIndexPath *> *selectedIndexPaths;

- (void)clearFilter;

@end
