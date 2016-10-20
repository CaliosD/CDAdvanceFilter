//
//  CDFilterParamManager.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterParamManager.h"
#import "NSDictionary+Merge.h"

@interface CDFilterParamManager ()

@property (nonatomic, strong) id<CDAdvanceFilter> filter;
@property (nonatomic, strong) NSArray *p_paramKeys;
@property (nonatomic, strong) NSArray *p_oriDataSource;
@property (nonatomic, strong) NSArray *p_oriSlideSections;
@property (nonatomic, strong) NSMutableSet *p_slideFilterSelectedIndexPaths;

@end

@implementation CDFilterParamManager

- (instancetype)initWithFilter:(id<CDAdvanceFilter>)filter
{
    if (self = [super init]) {
        self.filter = filter;
    }
    return self;
}

- (void)propertyPreview
{
    NSLog(@"------------------------------------------------");
    NSLog(@"currentParams: %@\n slideFilterSelectedIndexPaths: %@\n ",self.currentParams,self.slideFilterSelectedIndexPaths);
    NSLog(@"------------------------------------------------");
}

#pragma mark - Public

- (void)setDataSource:(NSArray *)dataSource
{
    self.p_oriDataSource = [dataSource copy];
    
    [self setupAllSections];
    [self resetCurrentParams];
}

- (NSArray *)slideFilterDataSource
{
    NSAssert(self.p_oriDataSource, @"`dataSource` of CDFilterParamManager should not be nil.");
    
    return self.p_oriSlideSections;
}

- (NSArray *)slideFilterSelectedIndexPaths
{
    NSMutableArray *tmp = [NSMutableArray array];
   
    if (_p_slideFilterSelectedIndexPaths.count <= 0) {
        NSLog(@"slideFilterSelectedIndexPaths: %@",tmp);
        return tmp;
    }
    else{
        return [_p_slideFilterSelectedIndexPaths allObjects];
    }
}

- (void)setSlideFilterSelectedIndexPaths:(NSArray *)slideFilterSelectedIndexPaths
{
    _p_slideFilterSelectedIndexPaths = [NSMutableSet setWithArray:slideFilterSelectedIndexPaths];
}

- (void)resetFilterParams
{
    [self resetCurrentParams];
    
    [_p_slideFilterSelectedIndexPaths removeAllObjects];
    //    [self propertyPreview];
}

#pragma mark - Private

- (void)setupAllSections
{
    NSAssert(self.p_oriDataSource, @"`dataSource` of CDFilterParamManager should not be nil.");
    NSMutableArray *sectionsConfigs = [[self.filter sectionsConfig] mutableCopy];
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *paramKeys = [NSMutableArray array];
    
    for (NSDictionary *dict1 in self.p_oriDataSource) {
        
        NSString *key = dict1[CDFilterSectionFieldKey];
        [paramKeys addObject:key];
        BOOL hasConfig = NO;
        
        for (NSDictionary *dict2 in sectionsConfigs) {
            NSString *configKey = dict2[CDFilterSectionFieldKey];
            if ([configKey isEqualToString:key]) {
                
                // Combine custom configures with original data source(which is from json).
                hasConfig = YES;
                NSDictionary *tmp = [NSDictionary dictionaryByMerging:dict1 with:dict2];
                [sections addObject:tmp];
                
                break;
            }
        }
        
        if (!hasConfig) {
            [sections addObject:dict1];
        }
    }
    
    NSArray *sectionModels = [CDFilterSection mj_objectArrayWithKeyValuesArray:sections];
    
    self.p_paramKeys = paramKeys;
    self.p_oriSlideSections = sectionModels;
}

- (void)resetCurrentParams
{
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    for (NSString *key in self.p_paramKeys) {
        [tmp setObject:@"" forKey:key];
    }
    self.currentParams = tmp;
}

@end
