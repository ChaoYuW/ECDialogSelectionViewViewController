//
//  ECPresentationController.h
//  StandardApplication
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017 CHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECPopoverMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ECPresentationController : UIPresentationController

@property(nonatomic,assign)CGSize           presentedSize;
@property(nonatomic,assign)CGFloat          presentedHeight;

@property(nonatomic,strong)UIView           *coverView;
@property(nonatomic,assign)ECPopoverType    popoverType;
@end

NS_ASSUME_NONNULL_END
