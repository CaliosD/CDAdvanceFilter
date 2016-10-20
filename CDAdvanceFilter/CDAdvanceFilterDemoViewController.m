//
//  CDAdvanceFilterDemoViewController.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDAdvanceFilterDemoViewController.h"

#import "CDAdvanceFilter.h"
#import "CDFilterParamManager.h"

#import "DormitoryFilterModel.h"

@interface CDAdvanceFilterDemoViewController ()<CDAdvanceFilterVCDelegate>

@property (nonatomic, strong) CDAdvanceFilterViewController *slideFilter;
@property (nonatomic, strong) CDFilterParamManager          *filterParamManager;
@property (nonatomic, strong) DormitoryFilterModel *filterModel;

@end

@implementation CDAdvanceFilterDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass([self class]);
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    _slideFilter = [[CDAdvanceFilterViewController alloc] init];
    _slideFilter.filterVCDelegate = self;
    
    _filterModel = [[DormitoryFilterModel alloc] init];
    self.filterParamManager = [[CDFilterParamManager alloc] initWithFilter:_filterModel];
    
    // Mock.
    NSString *mockPath = [[NSBundle mainBundle] pathForResource:@"MockData" ofType:@"json"];
    NSError *error;
    self.filterParamManager.dataSource = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:mockPath] options:NSJSONReadingMutableContainers error:&error]];
    
    UIBarButtonItem *slideFilterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"itm_filter"] style:UIBarButtonItemStyleDone target:self action:@selector(slideFilterPressed)];
    self.navigationItem.rightBarButtonItem = slideFilterItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)slideFilterPressed
{
    // Set custom filter model.
    _slideFilter.filterController.filterModel = _filterModel;
    
    // Set slide filter data source (made of sections).
    _slideFilter.sectionArray = self.filterParamManager.slideFilterDataSource;
    
    // Set selected indexPaths and inputted texts.
    [_slideFilter.filterController setCurrentFilterDict:self.filterParamManager.currentParams];
    _slideFilter.selectedIndexPaths = [self.filterParamManager slideFilterSelectedIndexPaths];
    
    // Show filter.
    [_slideFilter showFilter];
}

#pragma mark - CDAdvanceFilterVCDelegate

- (void)cd_confirmWithFilterDict:(NSDictionary *)filterDict
{
    NSLog(@"====>  点击筛选确定 返回 %@", filterDict);
    
    self.filterParamManager.currentParams = [filterDict mutableCopy];
    self.filterParamManager.slideFilterSelectedIndexPaths = [self.slideFilter.selectedIndexPaths mutableCopy];
    
    [self.slideFilter hideFilter];
}

- (void)cd_resetFilter
{
    [self.filterParamManager resetFilterParams];
    
    [self.slideFilter hideFilter];
}

@end
