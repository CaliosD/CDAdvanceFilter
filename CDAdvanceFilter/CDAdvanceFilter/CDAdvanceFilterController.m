//
//  CDAdvanceFilterController.m
//  CDAdvanceFilter
//
//  Created by Calios on 8/29/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDAdvanceFilterController.h"
#import "CDFilterParamManager.h"
#import "CDFilterSection.h"
#import "CDFilterOption.h"

static UIView *CDAdvanceFilterFirstResponder(UIView *view)
{
    if ([view isFirstResponder])
    {
        return view;
    }
    for (UIView *subview in view.subviews)
    {
        UIView *responder = CDAdvanceFilterFirstResponder(subview);
        if (responder)
        {
            return responder;
        }
    }
    return nil;
}

@interface CDAdvanceFilterController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSDictionary *cellClassesForSectionTypes;
@property (nonatomic, strong) NSMutableDictionary *p_currentFilterDict;

@property (nonatomic, assign) UIEdgeInsets originalTableContentInset;

@end

@implementation CDAdvanceFilterController

- (instancetype)init
{
    if (self = [super init]) {
        _filterSections = [NSArray array];
        _p_currentFilterDict = [NSMutableDictionary dictionary];
        self.selectedParamDict = [NSMutableDictionary dictionary];
        _cellClassesForSectionTypes = @{
                                         CDFilterCVCellTypeInput: [CDFilterCollectionViewInputCell class],
                                         CDFilterCVCellTypeSingleOption:[CDFilterCollectionViewOptionCell class],
                                         CDFilterCVCellTypeMultipleOption:[CDFilterCollectionViewOptionCell class],
                                         CDFilterCVCellTypeNormalRange: [CDFilterCollectionViewNormalRangeCell class],
                                         CDFilterCVCellTypeDateRange:[CDFilterCollectionViewDateRangeCell class]
                                        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setDelegate:(id<CDAdvanceFilterControllerDelegate>)delegate
{
    _delegate = delegate;
    
    self.collectionView.delegate = nil;
    self.collectionView.delegate = self;
}

- (void)setCollectionView:(UICollectionView *)collectionView
{
    _collectionView = collectionView;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    [self.collectionView registerClass:[CDFilterCollectionViewHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CDFilterCollectionViewHeader class]) ];
    [self.collectionView registerClass:[CDFilterCollectionViewInputCell class] forCellWithReuseIdentifier:NSStringFromClass([CDFilterCollectionViewInputCell class])];
    [self.collectionView registerClass:[CDFilterCollectionViewOptionCell class] forCellWithReuseIdentifier:NSStringFromClass([CDFilterCollectionViewOptionCell class])];
    [self.collectionView registerClass:[CDFilterCollectionViewNormalRangeCell class] forCellWithReuseIdentifier:NSStringFromClass([CDFilterCollectionViewNormalRangeCell class])];
    [self.collectionView registerClass:[CDFilterCollectionViewDateRangeCell class] forCellWithReuseIdentifier:NSStringFromClass([CDFilterCollectionViewDateRangeCell class])];

    [self.collectionView reloadData];
}

- (void)setFilterModel:(id<CDAdvanceFilter>)filterModel
{
    _filterModel = filterModel;
}

- (void)setFilterSections:(NSArray *)filterSections
{
    _filterSections = filterSections;
    
    [self.collectionView reloadData];
}

- (void)setSelectedIndexPaths:(NSArray<NSIndexPath *> *)selectedIndexPaths
{
    for (NSIndexPath *indexPath in selectedIndexPaths) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

- (NSArray<NSIndexPath *> *)selectedIndexPaths
{
    return [self.collectionView indexPathsForSelectedItems];
}

- (NSDictionary *)currentFilterDict
{
    [_p_currentFilterDict removeAllObjects];
    
    // Get input or range type current value.
    for (UIView *v in self.collectionView.subviews) {
        if ([v respondsToSelector:@selector(currentValue)]) {
            NSDictionary *dict = [v performSelector:@selector(currentValue)];
            [_p_currentFilterDict addEntriesFromDictionary:dict];
        }
    }
    
    NSLog(@"===>1 dic = %@", _p_currentFilterDict);
    // Get option type current value.
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]) {
        CDFilterSection *section = self.filterSections[indexPath.section];
        id option = section.options[indexPath.item];
        if ([option isKindOfClass:[NSDictionary class]] && [option objectForKey:@"optionId"]) {
            [_p_currentFilterDict addEntriesFromDictionary:@{section.sectionField : option[@"optionId"]}];
        }
    }
    
    NSLog(@"===>2 dic = %@", _p_currentFilterDict);
    
    return [_p_currentFilterDict copy];
}

- (void)setCurrentFilterDict:(NSDictionary *)currentFilterDict
{
    [_p_currentFilterDict removeAllObjects];
    _p_currentFilterDict = [NSMutableDictionary dictionaryWithDictionary:currentFilterDict];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.filterSections];
    for (int i = 0; i < self.filterSections.count; i++) {
        CDFilterSection *section = self.filterSections[i];
        if ([_p_currentFilterDict objectForKey:section.sectionField] && [self isSectionInputCell:section]) {
            section.value = [_p_currentFilterDict objectForKey:section.sectionField];
            [tmp replaceObjectAtIndex:i withObject:section];
        }
    }
    self.filterSections = tmp;
}

- (void)clearFilter
{
    [_p_currentFilterDict removeAllObjects];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:self.filterSections];
    for (int i = 0; i < self.filterSections.count; i++) {
        CDFilterSection *section = self.filterSections[i];
        if ([self isSectionInputCell:section]) {
            section.value = nil;
            [tmp replaceObjectAtIndex:i withObject:section];
        }
    }
    self.filterSections = tmp;
    
    for (UIView *v in self.collectionView.subviews) {
        if ([v respondsToSelector:@selector(clearOption)]) {
            [v performSelector:@selector(clearOption)];
        }
    }
}

#pragma mark - Private

- (NSUInteger)numberOfSections
{
    return [self.filterSections count];
}

- (CDFilterSection *)sectionAtIndex:(NSUInteger)index
{
    return self.filterSections[index];
}

- (NSUInteger)numberOfItemsInSection:(NSUInteger)index
{
    //    NSLog(@"====> fitersections => %@", self.filterSections);
    CDFilterSection *section = self.filterSections[index];
    if ([self isSectionInputCell:section]) {
        return 1;
    }
    return  section.options.count;
}

- (BOOL)isSectionInputCell:(CDFilterSection *)section
{
    return (![section.sectionType isEqualToString:CDFilterCVCellTypeSingleOption] && ![section.sectionType isEqualToString:CDFilterCVCellTypeMultipleOption]);
}

- (CDFilterOption *)optionForIndex:(NSIndexPath *)indexPath
{
    CDFilterSection *section = [self sectionAtIndex:indexPath.section];
    CDFilterOption *option = [[CDFilterOption alloc] init];
    option.sectionTitle = section.sectionTitle;
    option.sectionType = section.sectionType;
    option.sectionField = section.sectionField;
    option.optionClass = (section.optionClass) ? section.optionClass : [NSString class];
    if ([self isSectionInputCell:section] && section.value) {
        option.value = section.value;
    }
    if (![self isSectionInputCell:section] && section.options && section.options.count > 0) {
        id o = section.options[indexPath.item];
        option.option = o;
    }
    return option;
}

#pragma mark - Keyboard events

- (UICollectionViewCell *)cellContainingView:(UIView *)view
{
    if (view == nil || [view isKindOfClass:[UICollectionViewCell class]])
    {
        return (UICollectionViewCell *)view;
    }
    return [self cellContainingView:view.superview];
}

- (void)keyboardDidShow:(NSNotification *)notification
{
    UICollectionViewCell *cell = [self cellContainingView:CDAdvanceFilterFirstResponder(self.collectionView)];
    if (cell && ![self.delegate isKindOfClass:[UITableViewController class]])
    {
        // calculate the size of the keyboard and how much is and isn't covering the tableview
        NSDictionary *keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        keyboardFrame = [self.collectionView.window convertRect:keyboardFrame toView:self.collectionView.superview];
        CGFloat heightOfTableViewThatIsCoveredByKeyboard = self.collectionView.frame.origin.y + self.collectionView.frame.size.height - keyboardFrame.origin.y;
        CGFloat heightOfTableViewThatIsNotCoveredByKeyboard = self.collectionView.frame.size.height - heightOfTableViewThatIsCoveredByKeyboard;
        
        UIEdgeInsets tableContentInset = self.collectionView.contentInset;
        self.originalTableContentInset = tableContentInset;
        tableContentInset.bottom = heightOfTableViewThatIsCoveredByKeyboard;
        
        UIEdgeInsets tableScrollIndicatorInsets = self.collectionView.scrollIndicatorInsets;
        tableScrollIndicatorInsets.bottom += heightOfTableViewThatIsCoveredByKeyboard;
        
        [UIView beginAnimations:nil context:nil];
        
        // adjust the tableview insets by however much the keyboard is overlapping the tableview
        self.collectionView.contentInset = tableContentInset;
        self.collectionView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        
        UIView *firstResponder = CDAdvanceFilterFirstResponder(self.collectionView);
        if ([firstResponder isKindOfClass:[UITextView class]])
        {
            UITextView *textView = (UITextView *)firstResponder;
            
            // calculate the position of the cursor in the textView
            NSRange range = textView.selectedRange;
            UITextPosition *beginning = textView.beginningOfDocument;
            UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
            UITextPosition *end = [textView positionFromPosition:start offset:range.length];
            CGRect caretFrame = [textView caretRectForPosition:end];
            
            // convert the cursor to the same coordinate system as the tableview
            CGRect caretViewFrame = [textView convertRect:caretFrame toView:self.collectionView.superview];
            
            // padding makes sure that the cursor isn't sitting just above the
            // keyboard and will adjust to 3 lines of text worth above keyboard
            CGFloat padding = textView.font.lineHeight * 3;
            CGFloat keyboardToCursorDifference = (caretViewFrame.origin.y + caretViewFrame.size.height) - heightOfTableViewThatIsNotCoveredByKeyboard + padding;
            
            // if there is a difference then we want to adjust the keyboard, otherwise
            // the cursor is fine to stay where it is and the keyboard doesn't need to move
            if (keyboardToCursorDifference > 0)
            {
                // adjust offset by this difference
                CGPoint contentOffset = self.collectionView.contentOffset;
                contentOffset.y += keyboardToCursorDifference;
                [self.collectionView setContentOffset:contentOffset animated:YES];
            }
        }
        
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    UICollectionViewCell *cell = [self cellContainingView:CDAdvanceFilterFirstResponder(self.collectionView)];
    if (cell && ![self.delegate isKindOfClass:[UITableViewController class]])
    {
        NSDictionary *keyboardInfo = [note userInfo];
        UIEdgeInsets tableScrollIndicatorInsets = self.collectionView.scrollIndicatorInsets;
        tableScrollIndicatorInsets.bottom = 0;
        
        //restore insets
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:(UIViewAnimationCurve)keyboardInfo[UIKeyboardAnimationCurveUserInfoKey]];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        self.collectionView.contentInset = UIEdgeInsetsZero; //self.originalTableContentInset;
        self.collectionView.scrollIndicatorInsets = tableScrollIndicatorInsets;
        self.originalTableContentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];
    }
}

#pragma mark - UICollectionViewDelegate & DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDFilterSection *section = [self sectionAtIndex:indexPath.section];
    CDFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(_cellClassesForSectionTypes[section.sectionType]) forIndexPath:indexPath];
    CDFilterOption *option = [self optionForIndex:indexPath];
    [cell configureCellWithOption:option];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDFilterSection *section = [self sectionAtIndex:indexPath.section];
    if (section.columnCount && section.columnCount > 0) {
        return CGSizeMake(CGRectGetWidth(collectionView.frame)/section.columnCount - 2, CDFilterCVCellOptionHeight);
    }
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CDFilterCVCellOptionHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CDFilterSection *s = [self sectionAtIndex:section];
    if (![s.sectionType isEqualToString:CDFilterCVCellTypeInput]) {
        return CGSizeMake([collectionView bounds].size.width, CDFilterCVCellOptionHeight);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CDFilterSection *section = [self sectionAtIndex:indexPath.section];
    
    UICollectionReusableView *reusableView = nil;
    if (![section.sectionType isEqualToString:CDFilterCVCellTypeInput]) {
        if (kind == UICollectionElementKindSectionHeader) {
            CDFilterCollectionViewHeader *header = (CDFilterCollectionViewHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([CDFilterCollectionViewHeader class]) forIndexPath:indexPath];
            [header configureCVHeaderWithTitle:section.sectionTitle];
            reusableView = header;
        }
    }
    return reusableView;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray<NSIndexPath *> *selectedIndexes = collectionView.indexPathsForSelectedItems;
    if ([selectedIndexes containsObject:indexPath]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        CDFilterSection *section = [self sectionAtIndex:indexPath.section];
        [self.selectedParamDict setObject:[NSNumber numberWithInteger:-1] forKey:section.sectionField];

        return NO;
    }
    else{
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CDFilterSection *section = [self sectionAtIndex:indexPath.section];
    
    NSLog(@"==== > 点击 %ld 分区   %ld 项", (long)indexPath.section, (long)indexPath.item);
    
    NSArray<NSIndexPath *> *selectedIndexes = collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *currentIndex in selectedIndexes) {
        if (currentIndex.section == indexPath.section) {
            
            if (currentIndex.item != indexPath.item) {
                [collectionView deselectItemAtIndexPath:currentIndex animated:YES];
            }
            else{
                [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            }
            [self.selectedParamDict setObject:[NSNumber numberWithInteger:indexPath.item] forKey:section.sectionField];
        }
    }
    
    NSLog(@"did Select: %@",self.selectedParamDict);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //dismiss keyboard
    [CDAdvanceFilterFirstResponder(self.collectionView) resignFirstResponder];
    
    //forward to delegate
    if ([self.delegate respondsToSelector:_cmd])
    {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
}

@end
