//
//  CDFilterCollectionViewDateRangeCell.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/31/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewNormalRangeCell.h"

@interface CDFilterCollectionViewDateRangeCell : CDFilterCollectionViewNormalRangeCell

- (NSDictionary *)currentValue;
- (void)configureCellWithOption:(CDFilterOption *)option;
- (void)clearOption;

@end
