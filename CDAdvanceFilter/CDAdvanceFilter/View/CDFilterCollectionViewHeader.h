//
//  CDFilterCollectionViewHeader.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDFilterCollectionViewHeader : UICollectionReusableView

- (void)configureCVHeaderWithTitle:(NSString *)title;
- (void)configureCVHeaderWithModel:(id)model;

@end
