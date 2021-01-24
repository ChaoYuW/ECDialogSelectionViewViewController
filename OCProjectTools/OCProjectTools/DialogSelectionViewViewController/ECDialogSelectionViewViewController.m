//
//  ECDialogSelectionViewViewController.m
//  StandardApplication
//
//  Created by chao on 2021/1/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ECDialogSelectionViewViewController.h"
#import "ECSelectionTableViewCell.h"

@interface ECDialogSelectionViewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *myTableView;
@property (assign, nonatomic) NSInteger displayNum;
@property (nonatomic, strong) UILabel *titleLabel;
@end

const NSInteger ECDialogSelectionViewControllerSelectedItemIndexNone = -1;
@implementation ECDialogSelectionViewViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self didInitialize];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self didInitialize];
    }
    return self;
}
- (void)didInitialize {
    self.headerViewHeight = 48;
    self.footerViewHeight = 48;
    self.rowHeight = 50;
    self.titleColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    self.titleFont = [UIFont fontWithName:@"PingFangSC" size:16];
    self.headerViewBackgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    self.displayNum = 10;
    self.rowHeight = 44;
    self.selectedItemIndex = ECDialogSelectionViewControllerSelectedItemIndexNone;
    self.selectedItemIndexes = [[NSMutableSet alloc] init];
    
    _contentView = UIView.new;
    
    _titleLabel = UILabel.new;
    _titleLabel.text = _navTitle;
    _titleLabel.font = self.titleFont;
    _titleLabel.textColor = self.titleColor;
    _headerView = UIView.new;
    _headerView.backgroundColor = self.headerViewBackgroundColor;
    
    [_headerView addSubview:_titleLabel];
    
    _footerView = UIView.new;

    [_contentView addSubview:_headerView];
    [_contentView addSubview:_footerView];
    
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.alwaysBounceVertical = NO;
//    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11, *)) {
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 因为要根据 tableView sizeThatFits: 算出 dialog 的高度，所以禁用 estimated 特性，不然算出来结果不准确
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
    [_contentView addSubview:self.myTableView];
    
    [self.view addSubview:_contentView];
    
    [self.myTableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 当前的分组不在可视区域内，则滚动到可视区域（只对单选有效）
    if (self.selectedItemIndex != ECDialogSelectionViewControllerSelectedItemIndexNone && self.selectedItemIndex < self.items.count && ![self ec_cellVisibleAtIndexPath:[NSIndexPath indexPathForRow:self.selectedItemIndex inSection:0]]) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedItemIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
    }
}
- (void)layoutFrame
{
    CGFloat selfWidth = [UIScreen mainScreen].bounds.size.width - 2*40;
    CGFloat selfHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat totalHeight = 0;
    
    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(selfWidth, self.headerViewHeight)];
    self.titleLabel.frame = CGRectMake((selfWidth-size.width)*0.5, (self.headerViewHeight-size.height)*0.5, size.width, size.height);
    self.headerView.frame = CGRectMake(0, 0, selfWidth, self.headerViewHeight);
    
    totalHeight +=self.headerViewHeight;
    NSInteger maxNum = self.items.count;
    if (self.items.count > self.displayNum) {
        maxNum = 10;
    }
    CGFloat cHeight = maxNum * self.rowHeight;
    self.myTableView.frame = CGRectMake(0, self.headerViewHeight, selfWidth, cHeight);
    
    totalHeight +=cHeight;
    self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.myTableView.frame), selfWidth, self.footerViewHeight);
    totalHeight +=self.footerViewHeight;
    self.contentView.frame = CGRectMake(40, (selfHeight-totalHeight)*0.5, selfWidth, totalHeight);
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutFrame];
}
- (void)setItems:(NSArray<NSString *> *)items
{
    _items = [items copy];
    [self.myTableView reloadData];

    [self layoutFrame];
}
- (void)setNavTitle:(NSString *)navTitle
{
    _navTitle = navTitle;
    self.titleLabel.text = navTitle;
    [self layoutFrame];
}
- (void)setRowHeight:(CGFloat)rowHeight
{
    _rowHeight = rowHeight;
    [self.myTableView setNeedsLayout];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECSelectionTableViewCell *cell = [ECSelectionTableViewCell cellWithTableView:tableView];
    cell.title = self.items[indexPath.row];
    if (self.allowsMultipleSelection) {
        // 多选
        if ([self.selectedItemIndexes containsObject:@(indexPath.row)]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        // 单选
        if (self.selectedItemIndex == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForItemBlock) {
        self.rowHeight = self.heightForItemBlock(self,indexPath.row);
    }
    return self.rowHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单选情况下如果重复选中已被选中的cell，则什么都不做
    if (!self.allowsMultipleSelection && self.selectedItemIndex == indexPath.row && !self.allowsTheSameResponse) {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    // 不允许选中当前cell，直接return
    if (self.canSelectItemBlock && !self.canSelectItemBlock(self, indexPath.row)) {
        [self.myTableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (self.allowsMultipleSelection) {
        if ([self.selectedItemIndexes containsObject:@(indexPath.row)]) {
            // 当前的cell已经被选中，则取消选中
            [self.selectedItemIndexes removeObject:@(indexPath.row)];
            if (self.didDeselectItemBlock) {
                self.didDeselectItemBlock(self, indexPath.row);
            }
        } else {
            [self.selectedItemIndexes addObject:@(indexPath.row)];
            if (self.didSelectItemBlock) {
                self.didSelectItemBlock(self, indexPath.row);
            }
        }
        if ([self ec_cellVisibleAtIndexPath:indexPath]) {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        BOOL isSelectedIndexPathBeforeVisible = NO;
        
        // 选中新的cell时，先反选之前被选中的那个cell
        NSIndexPath *selectedIndexPathBefore = nil;
        if (self.selectedItemIndex != ECDialogSelectionViewControllerSelectedItemIndexNone) {
            selectedIndexPathBefore = [NSIndexPath indexPathForRow:self.selectedItemIndex inSection:0];
            if (self.didDeselectItemBlock) {
                self.didDeselectItemBlock(self, selectedIndexPathBefore.row);
            }
            isSelectedIndexPathBeforeVisible = [self ec_cellVisibleAtIndexPath:selectedIndexPathBefore];
        }
        
        self.selectedItemIndex = indexPath.row;
        
        // 如果之前被选中的那个cell也在可视区域里，则也要用动画去刷新它，否则只需要用动画刷新当前已选中的cell即可，之前被选中的那个交给cellForRow去刷新
        if (isSelectedIndexPathBeforeVisible) {
            [tableView reloadRowsAtIndexPaths:@[selectedIndexPathBefore, indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        if (self.didSelectItemBlock) {
            self.didSelectItemBlock(self, indexPath.row);
        }
    }
    
}

- (BOOL)ec_cellVisibleAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<NSIndexPath *> *visibleCellIndexPaths = self.myTableView.indexPathsForVisibleRows;
    for (NSIndexPath *visibleIndexPath in visibleCellIndexPaths) {
        if ([indexPath isEqual:visibleIndexPath]) {
            return YES;
        }
    }
    return NO;
}
- (void)show
{

}
- (void)hide
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
