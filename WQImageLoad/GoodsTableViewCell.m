//
//  GoodsTableViewCell.m
//  WQImageLoad
//
//  Created by chenweiqiang on 2018/8/22.
//  Copyright © 2018年 chenweiqiang. All rights reserved.
//

#import "GoodsTableViewCell.h"

@implementation GoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.titleLabel];
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =({
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
            imageV.clipsToBounds = YES;
            imageV;
        });
    }
    return _headImageView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 150, 100)];
            lab.font = [UIFont systemFontOfSize:16];
            lab;
        });
    }
    return _titleLabel;
}

@end
