///Users/calios/Documents/MyEden/Draft/Animation.md
//  SimpleStringSpec.m
//  CDAdvanceFilter
//
//  Created by Calios on 19/10/2016.
//  Copyright 2016 Calios. All rights reserved.
//

#import <Kiwi/Kiwi.h>

SPEC_BEGIN(SimpleStringSpec)

describe(@"SimpleString", ^{
    context(@"when assigned to 'Hello world'", ^{
        NSString *greeting = @"Hello world";
        it(@"should exist", ^{
            [[greeting shouldNot] beNil];
        });
        
        it(@"should equal to 'Hello world'", ^{
            [[greeting should] equal:@"Hello world"];
        });
    });
});

SPEC_END
