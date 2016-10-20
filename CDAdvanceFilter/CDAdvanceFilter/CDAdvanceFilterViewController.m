//
//  CDAdvanceFilterViewController.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/24/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDAdvanceFilterViewController.h"
#import "CDAdvanceFilterController.h"
#import "DormitoryFilterModel.h"

#define CDAdvanceFilterViewWidth   (CDFilter_kScreenWidth - (CDAdvanceFilterViewLeftPadding))

@interface UIView (CDUtility)

- (void)cd_setX:(CGFloat)x;

@end

@implementation UIView (CDUtility)

- (void)cd_setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

@end

@interface CDAdvanceFilterViewController ()

@property (nonatomic, strong) UIView          *bgView;
@property (nonatomic, strong) UINavigationBar *topBar;
@property (nonatomic, strong) UIView          *actionView;
@property (nonatomic, strong) NSArray<NSIndexPath*>     *p_selectedIndexPaths;

- (void)confirmButtonPressed;
- (void)resetButtonPressed;

@end

@implementation CDAdvanceFilterViewController

- (void)dealloc
{
    _filterController.delegate = nil;
}

- (CDAdvanceFilterController *)filterController
{
    if (!_filterController) {
        _filterController = [[CDAdvanceFilterController alloc] init];
//        _filterController.delegate = self;    // ❓Delete or not?
    }
    return _filterController;
}

- (void)setSectionArray:(NSArray *)sectionArray
{
    _filterController.filterSections = sectionArray;
}

- (void)setSelectedIndexPaths:(NSArray<NSIndexPath *> *)selectedIndexPaths
{
    _p_selectedIndexPaths = selectedIndexPaths;
    if (selectedIndexPaths.count > 0) {
        [_filterController setSelectedIndexPaths:selectedIndexPaths];
    }
}

- (NSArray<NSIndexPath *> *)selectedIndexPaths
{
    return _filterController.selectedIndexPaths;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBgView];
    [self setupNavigationBar];
    [self setupCollectionView];
    [self setupActionView];
    [self changeXOfSubviewsWhenHide];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_filterController setSelectedIndexPaths:_p_selectedIndexPaths];
}

#pragma mark - Public

- (void)showFilter
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.view];
    
    self.bgView.alpha = 0.f;
    [UIView animateWithDuration:0.35 animations:^{
        [self changeXOfSubviewsWhenShow];
        self.bgView.alpha = 0.45f;
    }];
}

- (void)hideFilter
{
    [UIView animateWithDuration:0.35 animations:^{
        [self changeXOfSubviewsWhenHide];
        self.bgView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)confirmButtonPressed
{
    if ([self.filterVCDelegate respondsToSelector:@selector(cd_confirmWithFilterDict:)]) {
        [self.filterVCDelegate cd_confirmWithFilterDict:self.filterController.currentFilterDict];
    }
}

- (void)resetButtonPressed
{
    if ([self.filterVCDelegate respondsToSelector:@selector(cd_resetFilter)]) {
        [self.filterVCDelegate cd_resetFilter];
        
        [self.filterController clearFilter];
        [self.collectionView reloadData];
    }
}

#pragma mark - Private

- (void)setupBgView
{
    self.bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.bgView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFilter)];
    [self.bgView addGestureRecognizer:tap];
    [self.view addSubview:self.bgView];
}

- (void)setupNavigationBar
{
    _topBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(CDAdvanceFilterViewLeftPadding, 0, CDAdvanceFilterViewWidth, (CDFilter_kNavigationBarHeight + CDFilter_kStatusBarHeight))];
    _topBar.backgroundColor = [UIColor whiteColor];
    _topBar.tintColor = [UIColor blackColor];
    UINavigationItem *titleItem = [[UINavigationItem alloc] init];
    titleItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:nil];
    _topBar.items = @[titleItem];
    [self.view addSubview:_topBar];
}

- (void)setupCollectionView
{
    if (!self.collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(200, 200);
        layout.minimumLineSpacing = 1.f;
        layout.minimumInteritemSpacing = 1.f;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CDAdvanceFilterViewLeftPadding, CDFilter_kNavigationBarHeight + CDFilter_kStatusBarHeight, CDAdvanceFilterViewWidth, CDFilter_kScreenHeight - CDFilter_kNavigationBarHeight - CDFilter_kStatusBarHeight - CDFilter_kTabBarHeight) collectionViewLayout:layout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.collectionView];
}

- (void)setupActionView
{
    self.actionView = [[UIView alloc] initWithFrame:CGRectMake(CDAdvanceFilterViewLeftPadding, CDFilter_kScreenHeight - CDFilter_kTabBarHeight, CDAdvanceFilterViewWidth, CDFilter_kTabBarHeight)];
    self.actionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.actionView];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(CDAdvanceFilterViewWidth/2.f, 0, CDAdvanceFilterViewWidth/2.f, CDFilter_kTabBarHeight)];
    confirmBtn.backgroundColor = CDFilterThemeColor;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:confirmBtn];
    
    UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CDAdvanceFilterViewWidth/2.f, CDFilter_kTabBarHeight)];
    resetBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    [resetBtn setTitleColor:CDFilterThemeColor forState:UIControlStateNormal];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.actionView addSubview:resetBtn];
}

- (void)changeXOfSubviewsWhenShow
{
    [self.collectionView cd_setX:CDAdvanceFilterViewLeftPadding];
    [self.topBar cd_setX:CDAdvanceFilterViewLeftPadding];
    [self.actionView cd_setX:CDAdvanceFilterViewLeftPadding];
}

- (void)changeXOfSubviewsWhenHide
{
    [self.collectionView cd_setX:CDFilter_kScreenWidth];
    [self.topBar cd_setX:CDFilter_kScreenWidth];
    [self.actionView cd_setX:CDFilter_kScreenWidth];
}

#pragma mark - Setter & Getter

- (void)setCollectionView:(UICollectionView *)collectionView
{
    self.filterController.collectionView = collectionView;
    if (![self isViewLoaded]) {
        self.view = self.collectionView;
    }
}

- (UICollectionView *)collectionView
{
    return self.filterController.collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
