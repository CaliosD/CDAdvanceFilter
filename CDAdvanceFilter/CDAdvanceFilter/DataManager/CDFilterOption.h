//
//  CDFilterOption.h
//  CDAdvanceFilter
//
//  Created by Calios on 8/29/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFilterOption : NSObject

@property (nonatomic, copy  ) NSString *sectionTitle;
@property (nonatomic, copy  ) NSString *sectionField;
@property (nonatomic, copy  ) NSString *sectionType;
@property (nonatomic        ) Class    optionClass;
@property (nonatomic, strong) id       option;
@property (nonatomic, strong) id       value;

@end
