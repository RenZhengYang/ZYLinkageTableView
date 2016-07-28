//
//  ViewController.m
//  ZYLinkageTableView
//
//  Created by mac on 16/7/27.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"

#define ZYScreenHeight [UIScreen mainScreen].bounds.size.height
#define ZYScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

/**左边tableView*/
@property(strong,nonatomic) UITableView *leftTableView;
/**右边tableView*/
@property(strong,nonatomic) UITableView *rightTableView;
/**数据源*/
@property(strong,nonatomic) NSMutableArray *muArrDatas;

@end

@implementation ViewController

#pragma mark- 数据源-懒加载
-(NSMutableArray *)muArrDatas
{
    if (!_muArrDatas) {
        
           _muArrDatas = [NSMutableArray array];
        for (NSInteger i = 1; i <=15; i++) {
            [_muArrDatas addObject:[NSString stringWithFormat:@"第%zd组",i]];
        }
          }
    
    return _muArrDatas;

}

#pragma mark- 控制器加载View
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self layoutLinkageTableView];
    
    NSLog(@"%@",self.muArrDatas);
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 默认选择左边tableView的第一行
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];



}

/**布局联动的tableView*/
- (void)layoutLinkageTableView
{
   //  左边tableView
    _leftTableView = [[UITableView alloc]initWithFrame:(CGRect){0,60,ZYScreenWidth * 0.25f,ZYScreenHeight-80 }];
    _leftTableView.backgroundColor = [UIColor whiteColor];
     [self.view addSubview:_leftTableView];

     // 右边tableView
    _rightTableView = [[UITableView alloc]initWithFrame:(CGRect){ZYScreenWidth * 0.25f,60,ZYScreenWidth * 0.75f,ZYScreenHeight}];
    [self.view addSubview:_rightTableView];
    
    // 设置代理与数据源
    _rightTableView.delegate = _leftTableView.delegate = self;
    _rightTableView.dataSource = _leftTableView.dataSource = self;

}




- (void)selectLeftTableViewWithScrollView:(UIScrollView *)scrollView
{
   // 如果现在滑动的是左边的tableView，不做任何处理
    if ((UITableView *)scrollView == _leftTableView) return ;
  
    // 滚动右边tableView，设置选中左边的tableView某一行。indexPathsForVisibleRows属性返回屏幕上可见的cell的indexPath数组，利用这个属性就可以找到目前所在的分区
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_rightTableView.indexPathsForVisibleRows.firstObject.section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
   
    
}
#pragma mark- 数据源方法
/**返回组*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _leftTableView) return 1;
     return _muArrDatas.count;
}

/**返回行*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _leftTableView) return _muArrDatas.count;
    return 20;
}

/**设置组头*/
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _leftTableView) return nil;
    return _muArrDatas[section];

}

//*cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      static NSString *ID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];

    if (tableView == _leftTableView) cell.textLabel.text = _muArrDatas[indexPath.row];
    else cell.textLabel.text = [NSString stringWithFormat:@"第%@_***_%zd行",self.muArrDatas[indexPath.section],indexPath.row + 1];
    
   
        return cell;
}

#pragma mark- 代理方法


/**选中左边某一行，右边滚动*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果点击的是右边的tableView，不做任何处理
    if(tableView == _rightTableView) return;
     // 点击左边的tableView，设置选中右边的tableView某一行。左边的tableView的每一行对应右边tableView的每个分区
    [_rightTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] animated:NO scrollPosition:UITableViewScrollPositionTop];


}

/**行高*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTableView) return 70;
    return 45;
    
}

/**组头高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == _leftTableView) return 0;
    return 30;

}
#pragma mark - UIScrollViewDelegate
//*监听右边的滚动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{ // 监听tableView滑动

    [self selectLeftTableViewWithScrollView:scrollView];

}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self selectLeftTableViewWithScrollView:scrollView];
//}
//
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    // 推拽将要结束的时候手动调一下这个方法
//    [self scrollViewDidEndDecelerating:scrollView];
//}

@end
