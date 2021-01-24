//
//  ECSelectionTableViewCell.m
//  StandardApplication
//
//  Created by chao on 2021/1/22.
//  Copyright © 2021 DTiOS. All rights reserved.
//

#import "ECSelectionTableViewCell.h"


@interface ECSelectionTableViewCell ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *tagImgView;

@end

@implementation ECSelectionTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellId = @"ECSelectionTableViewCell";
    
    ECSelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ECSelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addChildViews];
    }
    return self;
}
- (void)addChildViews
{
    [self.contentView addSubview:self.titleLab];
}
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
    [self.titleLab sizeToFit];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    CGFloat selfHeight = CGRectGetHeight(self.frame);
    CGFloat selfWidth = CGRectGetWidth(self.frame);
    self.titleLab.frame = CGRectMake(20, (selfHeight-20)*0.5, CGRectGetWidth(self.titleLab.frame), 20);
    self.tagImgView.frame = CGRectMake(selfWidth-20-20, (selfHeight-20)*0.5, 20, 20);
}
- (UILabel *)titleLab
{
    if (_titleLab == nil) {
        _titleLab = UILabel.new;
        _titleLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC" size:16];
    }
    return _titleLab;
}
- (UIImageView *)tagImgView
{
    if (_tagImgView == nil) {
        _tagImgView = UIImageView.new;
    }
    return _tagImgView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
