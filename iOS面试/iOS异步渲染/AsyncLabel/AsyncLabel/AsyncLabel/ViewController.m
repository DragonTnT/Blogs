//
//  ViewController.m
//  AsyncLabel
//
//  Created by 张伟 on 2019/10/9.
//  Copyright © 2019 张伟. All rights reserved.
//

#import "ViewController.h"
#import "ATTableViewCell.h"
#import "YYFPSLabel.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) YYFPSLabel *fpsLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。View其实就是Layer的代理，Layer是View的底层实现，View是Layer的管理类。绘图和坐标等操作都是在Layer中实现的，View只是访问Layer中的相关方法。",@"%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫%d Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫 Async Display Test ✺◟(∗❛ัᴗ❛ั∗)◞✺ ✺◟(∗❛ัᴗ❛ั∗)◞✺ 😀😖😐😣😡🚖🚌🚋🎊💖💗💛💙🏨🏦🏫",@"YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...YYAsyncLayer— iOS 异步绘制与显示的工具。 YYCategories— 功能丰富的 Category 类型工具库。 YYModel的学习 iOS开发总会用到各种JSON模型转换库,本人最常用的MJEx...", nil];
    
    self.datas = [NSMutableArray array];
    for (int i = 0; i < 300; i ++) {
        [self.datas addObjectsFromArray:arr];
    }
    

    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    _fpsLabel = [YYFPSLabel new];
    _fpsLabel.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 100, 50, 50);
    [self.view addSubview:_fpsLabel];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    ATTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ATTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.title = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 320;
}
@end
