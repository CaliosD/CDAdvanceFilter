//
//  CDFilterCollectionViewInputCell.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewCell.h"

@interface CDFilterCollectionViewInputCell : CDFilterCollectionViewCell

- (NSDictionary *)currentValue;
- (void)configureCellWithOption:(CDFilterOption *)option;
- (void)clearOption;

@end
