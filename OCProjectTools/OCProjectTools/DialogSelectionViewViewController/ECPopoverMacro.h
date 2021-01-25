//
//  ECPopoverMacro.h
//  StandardApplication
//
//  Created by chao on 2017/5/17.
//  Copyright © 2017 CHAO. All rights reserved.
//

#ifndef ECPopoverMacro_h
#define ECPopoverMacro_h

#define ECWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

typedef void(^ECCompleteBlock)(BOOL presented);

typedef NS_ENUM(NSUInteger, ECPopoverType){
    ECPopoverTypeActionSheet = 1,
    ECPopoverTypeAlert = 2
};

#endif /* ECPopoverMacro_h */
