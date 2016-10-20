//
//  CDFilterCollectionCellProtocol.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/23/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDFilterOption.h"

@protocol CDFilterCollectionCellProtocol <NSObject>

- (NSDictionary *)currentValue;
- (void)configureCellWithOption:(CDFilterOption *)option;
- (void)clearOption;

@end
