//
//  UIViewController+ECPopover.h
//  StandardApplication
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017 CHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECPopoverMacro.h"
#import "ECPopoverAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ECPopover)

@property(nonatomic,strong)ECPopoverAnimator        *popoverAnimator;

- (void)bottomPresentController:(UIViewController *)vc presentedHeight:(CGFloat)height completeHandle:(ECCompleteBlock)completion;

- (void)centerPresentController:(UIViewController *)vc presentedSize:(CGSize)size completeHandle:(ECCompleteBlock)completion;
@end

NS_ASSUME_NONNULL_END
