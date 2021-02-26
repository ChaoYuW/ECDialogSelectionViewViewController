//
//  ECDialogSelectionViewViewController.h
//  StandardApplication
//
//  Created by chao on 2021/1/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ECPopover.h"

NS_ASSUME_NONNULL_BEGIN



@interface ECDialogSelectionViewViewController : UIViewController



@property(nonatomic, assign) CGFloat        headerViewHeight;
@property(nonatomic, assign) CGFloat        footerViewHeight;

@property(nullable, nonatomic, strong, readonly) UIView *headerView;
@property(nullable, nonatomic, strong) UIColor        *headerViewBackgroundColor UI_APPEARANCE_SELECTOR;
@property(nullable, nonatomic, strong) UIColor        *footerViewBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, copy) NSString *navTitle;
@property(nullable, nonatomic, strong) UIColor        *titleColor;
@property(nullable, nonatomic, strong) UIFont         *titleFont;
@property(nullable, nonatomic, copy) NSArray <NSString *> *items;
@property(nullable, nonatomic, copy) CGFloat (^heightForItemBlock)(__kindof ECDialogSelectionViewViewController *aDialogViewController, NSUInteger itemIndex);
@property(nullable, nonatomic, copy) void (^didSelectItemBlock)(__kindof ECDialogSelectionViewViewController *aDialogViewController, NSUInteger itemIndex);
@property(nullable, nonatomic, copy) BOOL (^canSelectItemBlock)(__kindof ECDialogSelectionViewViewController *aDialogViewController, NSUInteger itemIndex);
@property(nullable, nonatomic, copy) void (^didDeselectItemBlock)(__kindof ECDialogSelectionViewViewController *aDialogViewController, NSUInteger itemIndex);
@property (nullable, nonatomic, copy) void (^didDismissBlock)(void);

/// 控制是否允许多选，默认为NO。
@property(nonatomic, assign) BOOL allowsMultipleSelection;
/// 单选时点击同一个是否响应
@property(nonatomic, assign) BOOL allowsTheSameResponse;
@property(nonatomic, assign) NSInteger selectedItemIndex;
/// 表示多选模式下已选中的item序号，默认为nil。此属性与 `selectedItemIndex` 互斥。
@property(nullable, nonatomic, strong) NSMutableSet <NSNumber *> *selectedItemIndexes;

/// 每一行的高度，如果使用了 heightForItemBlock 则该属性不生效，默认值为配置表里的 TableViewCellNormalHeight
@property(nonatomic, assign) CGFloat rowHeight UI_APPEARANCE_SELECTOR;
/// dialog的主体内容部分，默认是一个空的白色UIView，建议设置为自己的UIView
/// dialog会通过询问contentView的sizeThatFits得到当前内容的大小
@property(nullable, nonatomic, strong) UIView *contentView;
@property(nullable, nonatomic, strong, readonly) UIView *footerView;

@property(nullable, nonatomic, strong, readonly) UIButton *cancelButton;
@property(nullable, nonatomic, strong, readonly) UIButton *submitButton;

/**
 添加位于左下角的取消按钮，取消按钮点击时默认会自动 hide 弹窗，无需自己在 block 里调用 hide。
 
 同一时间只能存在一个取消按钮，所以每次添加都会移除上一个取消按钮。

 @param buttonText 按钮文字
 @param block 按钮点击后的事件。取消按钮会自动 hide 弹窗，无需在 block 里调用 hide
 */
- (void)addCancelButtonWithText:(NSString *)buttonText block:(void (^ _Nullable)(__kindof ECDialogSelectionViewViewController *aDialogViewController))block;

/**
 移除当前的取消按钮
 */
- (void)removeCancelButton;
/**
 添加位于右下角的提交按钮
 
 同一时间只能存在一个提交按钮，所以每次添加都会移除上一个提交按钮

 @param buttonText 按钮文字
 @param block 按钮点击后的事件，如果需要在点击后关闭浮层，需要在 block 里自行调用 hide
 */
- (void)addSubmitButtonWithText:(NSString *)buttonText block:(void (^ _Nullable)(__kindof ECDialogSelectionViewViewController *aDialogViewController))block;

/**
 移除提交按钮
 */
- (void)removeSubmitButton;



- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
