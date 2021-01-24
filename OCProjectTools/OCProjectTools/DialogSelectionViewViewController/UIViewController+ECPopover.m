//
//  UIViewController+ECPopover.m
//  StandardApplication
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017 CHAO. All rights reserved.
//

#import "UIViewController+ECPopover.h"
#import <objc/runtime.h>

@implementation UIViewController (ECPopover)

static const char popoverAnimatorKey;
- (ECPopoverAnimator *)popoverAnimator{
    return objc_getAssociatedObject(self, &popoverAnimatorKey);
}
- (void)setPopoverAnimator:(ECPopoverAnimator *)popoverAnimator{
    objc_setAssociatedObject(self, &popoverAnimatorKey, popoverAnimator, OBJC_ASSOCIATION_RETAIN);
}
- (void)bottomPresentController:(UIViewController *)vc presentedHeight:(CGFloat)height completeHandle:(ECCompleteBlock)completion
{
    self.popoverAnimator = [ECPopoverAnimator popoverAnimatorWithStyle:ECPopoverTypeActionSheet completeHandle:completion];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.popoverAnimator;
    [self.popoverAnimator setBottomViewHeight:height];

    [self presentViewController:vc animated:YES completion:nil];
}

- (void)centerPresentController:(UIViewController *)vc presentedSize:(CGSize)size completeHandle:(ECCompleteBlock)completion
{
    self.popoverAnimator = [ECPopoverAnimator popoverAnimatorWithStyle:ECPopoverTypeAlert completeHandle:completion];
    [self.popoverAnimator setCenterViewSize:size];

    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.popoverAnimator;
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
