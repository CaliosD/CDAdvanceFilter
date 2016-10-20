//
//  CDFilterCollectionViewCell.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/23/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFilterCollectionCellProtocol.h"

@interface CDFilterCollectionViewCell : UICollectionViewCell<CDFilterCollectionCellProtocol>

@property (nonatomic, strong) CDFilterOption *option;

- (void)setUp;

- (NSDictionary *)currentValue;
- (void)configureCellWithOption:(CDFilterOption *)option;
- (void)clearOption;

@end
