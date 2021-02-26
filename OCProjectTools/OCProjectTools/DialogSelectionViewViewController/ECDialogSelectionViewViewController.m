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

@property(nonatomic,copy) void (^cancelButtonBlock)(ECDialogSelectionViewViewController *dialogViewController);
@property(nonatomic,copy) void (^submitButtonBlock)(ECDialogSelectionViewViewController *dialogViewController);
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
    self.footerViewBackgroundColor = UIColor.whiteColor;
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
    _footerView.backgroundColor = self.footerViewBackgroundColor;
    _footerView.hidden = YES;

    _contentView.backgroundColor = UIColor.whiteColor;
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
    
    BOOL isFooterViewShowing = self.footerView && !self.footerView.hidden;
    
    if(isFooterViewShowing){
        self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.myTableView.frame), selfWidth, self.footerViewHeight);
        totalHeight +=self.footerViewHeight;
        
        NSUInteger buttonCount = self.footerView.subviews.count;
        if (buttonCount == 1) {
            UIButton *button = self.cancelButton ? : self.submitButton;
            button.frame = self.footerView.bounds;
            
//            self.buttonSeparatorLayer.hidden = YES;
        } else {
            CGFloat buttonWidth = ceil(CGRectGetWidth(self.footerView.bounds) / buttonCount);
            self.cancelButton.frame = CGRectMake(0, 0, buttonWidth, CGRectGetHeight(self.footerView.bounds));
            self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), 0, CGRectGetWidth(self.footerView.bounds) - CGRectGetMaxX(self.cancelButton.frame), CGRectGetHeight(self.footerView.bounds));
//            self.buttonSeparatorLayer.hidden = NO;
//            self.buttonSeparatorLayer.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), 0, PixelOne, CGRectGetHeight(self.footerView.bounds));
        }
    }else
    {
        totalHeight += 20;
    }
    
    
    self.contentView.frame = CGRectMake(40, (selfHeight-totalHeight)*0.5, selfWidth, totalHeight);
    
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = YES;
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
            if (self.didDismissBlock) {
                self.didDismissBlock();
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
        if (self.didDismissBlock) {
            self.didDismissBlock();
        }
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches  anyObject] locationInView:self.view];
    point = [self.contentView.layer convertPoint:point fromLayer:self.view.layer];
    if (![self.contentView.layer containsPoint:point]) {
        [self hide];
        if (self.didDismissBlock) {
            self.didDismissBlock();
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
- (void)addCancelButtonWithText:(NSString *)buttonText block:(void (^ _Nullable)(__kindof ECDialogSelectionViewViewController *aDialogViewController))block
{
    [self removeCancelButton];
    _cancelButton = [self generateButtonWithText:buttonText];
    [self.cancelButton addTarget:self action:@selector(handleCancelButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.footerView.hidden = NO;
    [self.footerView addSubview:self.cancelButton];
    
    self.cancelButtonBlock = block;
}
- (void)removeCancelButton
{
    [_cancelButton removeFromSuperview];
    self.cancelButtonBlock = nil;
    _cancelButton = nil;
    if (!self.cancelButton && !self.submitButton) {
        self.footerView.hidden = YES;
    }
}
- (void)addSubmitButtonWithText:(NSString *)buttonText block:(void (^ _Nullable)(__kindof ECDialogSelectionViewViewController *aDialogViewController))block
{
    [self removeSubmitButton];
    _submitButton = [self generateButtonWithText:buttonText];
    [self.submitButton addTarget:self action:@selector(handleSubmitButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.footerView.hidden = NO;
    [self.footerView addSubview:self.submitButton];
    
    self.submitButtonBlock = block;
}
- (void)removeSubmitButton
{
    [_submitButton removeFromSuperview];
    self.submitButtonBlock = nil;
    _submitButton = nil;
    if (!self.cancelButton && !self.submitButton) {
        self.footerView.hidden = YES;
    }
}
- (void)show
{

}
- (void)hide
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)handleCancelButtonEvent:(UIButton *)cancelButton {
    [self hide];
    if (self.didDismissBlock) {
        self.didDismissBlock();
    }
    if (self.cancelButtonBlock) {
        self.cancelButtonBlock(self);
    }
}
- (void)handleSubmitButtonEvent:(UIButton *)submitButton {
    if (self.submitButtonBlock) {
        // 把自己传过去，通过参数来引用 self，避免在 block 里直接引用 dialog 导致内存泄漏
        self.submitButtonBlock(self);
    }
}

#pragma Private Methods
- (UIButton *)generateButtonWithText:(NSString *)buttonText {
    UIButton *button = UIButton.new;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:buttonText forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0 green:67/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
    return button;
}

@end
