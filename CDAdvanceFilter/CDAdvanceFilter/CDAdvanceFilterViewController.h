//
//  CDAdvanceFilterViewController.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CDAdvanceFilterVCDelegate <NSObject>

- (void)cd_confirmWithFilterDict:(NSDictionary *)filterDict;
- (void)cd_resetFilter;

@end

@interface CDAdvanceFilterViewController : UIViewController<CDAdvanceFilterControllerDelegate>

@property (nonatomic, strong) id<CDAdvanceFilterVCDelegate> filterVCDelegate;
@property (nonatomic, strong) NSArray                       *sectionArray;
@property (nonatomic, strong) NSArray<NSIndexPath*>         *selectedIndexPaths;

/**
 ❓Is it necessary to reveal them to users?
 */
@property (nonatomic, strong) CDAdvanceFilterController *filterController;
@property (nonatomic, strong) UICollectionView          *collectionView;



- (void)showFilter;
- (void)hideFilter;

@end
