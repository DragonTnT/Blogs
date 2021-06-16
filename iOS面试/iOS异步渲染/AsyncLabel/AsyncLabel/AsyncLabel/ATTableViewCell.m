//
//  ATTableViewCell.m
//  AsyncLabel
//
//  Created by 张伟 on 2019/10/9.
//  Copyright © 2019 张伟. All rights reserved.
//

#import "ATTableViewCell.h"
#import "ATLabel.h"

@interface ATTableViewCell ()
@property (nonatomic, weak) ATLabel *titleLabel;
@end

@implementation ATTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setupUI {
    ATLabel *titleLabel = [[ATLabel alloc] initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 10 * 2, 300)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
}
@end
