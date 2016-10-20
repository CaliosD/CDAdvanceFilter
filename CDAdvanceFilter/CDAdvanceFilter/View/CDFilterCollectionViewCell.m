//
//  CDFilterCollectionViewCell.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/23/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCollectionViewCell.h"
#import "CDFilterCollectionViewInputCell.h"

@implementation CDFilterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    NSAssert(self, @"`setUp` should be overrided in subclass of `CDFilterCollectionViewCell`.");
}

#pragma mark - CDFilterCollectionCellProtocol

- (NSDictionary *)currentValue
{
    NSAssert(self, @"`currentValue` should be overrided in subclass of `CDFilterCollectionViewCell`.");
    return nil;
}

- (void)configureCellWithOption:(CDFilterOption *)option
{
    NSAssert(self, @"`configureCellWithOption` should be overrided in subclass of `CDFilterCollectionViewCell`.");
}

- (void)clearOption
{
    NSAssert(self, @"`clearOption` should be overrided in subclass of `CDFilterCollectionViewCell`.");
}
@end
