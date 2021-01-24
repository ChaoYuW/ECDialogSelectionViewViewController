//
//  ECSelectionTableViewCell.h
//  StandardApplication
//
//  Created by chao on 2021/1/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ECSelectionTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString *title;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
