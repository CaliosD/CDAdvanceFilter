//
//  CDFilterCollectionViewOptionCell.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewCell.h"

@interface CDFilterCollectionViewOptionCell : CDFilterCollectionViewCell

- (void)configureCellWithOption:(CDFilterOption *)option;
- (NSDictionary *)paramWithOption:(CDFilterOption *)option;
- (void)clearOption;

@end
