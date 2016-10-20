//
//  CDFilterCollectionViewNormalRangeCell.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewCell.h"

@interface CDFilterCollectionViewNormalRangeCell : CDFilterCollectionViewCell

@property (nonatomic, strong) UITextField *startTF;
@property (nonatomic, strong) UITextField *endTF;

- (NSDictionary *)currentValue;
- (void)configureCellWithOption:(CDFilterOption *)option;
- (void)clearOption;

@end
