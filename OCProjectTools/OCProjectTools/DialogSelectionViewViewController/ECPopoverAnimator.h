//
//  ECPopoverAnimator.h
//  StandardApplication
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017 CHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECPopoverMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECPopoverAnimator : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>

@property(nonatomic,assign)CGRect       presentedFrame;
+ (instancetype)popoverAnimatorWithStyle:(ECPopoverType)popoverType completeHandle:(ECCompleteBlock)completeBlock;

- (void)setCenterViewSize:(CGSize)size;
- (void)setBottomViewHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
