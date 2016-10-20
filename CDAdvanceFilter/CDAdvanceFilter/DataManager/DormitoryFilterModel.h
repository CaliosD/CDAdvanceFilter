//
//  DormitoryFilterModel.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/29/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DormitoryFilterModel : NSObject<CDAdvanceFilter>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *clazzname;
@property (nonatomic, copy) NSString *emptybed;
@property (nonatomic, copy) NSString *entrance;
@property (nonatomic, copy) NSString *applyYear;
@property (nonatomic, copy) NSString *political;
@property (nonatomic, copy) NSString *livein;

@end
