//
//  DetailseViewController.m
//  jdmobile
//
//  Created by 丁博洋 on 15/6/22.
//  Copyright (c) 2015年 SYETC02. All rights reserved.
//

#import "DetailsViewController.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "CellConfig.h"
#import "JLTabMainController.h"
//#import "CartViewController.h"
#import "CommodityInfoCell.h"
#import "CommoditySelectCell.h"
#import "LoginViewController.h"
#import "QSCNavigationController.h"
#import "DetailsMode.h"
#import "ShopingCartController.h"
@class QSCHttpTool;
@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate,SDCycleScrollViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    NSMutableArray *_images;
    UILabel *_indexPage;
}
@property (nonatomic, strong) UITableView *tableView;
/// cellConfig数据源
@property (nonatomic, strong) NSMutableArray *dataArray;
/// 数据模型
@property (nonatomic, strong) DetailsMode *modelToShow;

@property (nonatomic, strong) NSDictionary *dataDic;
@end

@implementation DetailsViewController


//- (DetailsMode *)modelToShow
//{
//    if (!_modelToShow) {
//        _modelToShow = [[DetailsMode alloc] initWithDictionary:self.dataDic];
//        NSLog(@"modelToShow%@",_modelToShow);
//    }
//    return _modelToShow;
//}
/**
 *  改变不同类型cell的顺序、增删时，只需在此修改即可，
 *  无需在多个tableView代理方法中逐个修改
 *
 *  @return <#return value description#>
 */
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        
        // 二维数组作为tableView的结构数据源
        _dataArray = [NSMutableArray array];

        // 购买信息
        CellConfig *comInfo = [CellConfig cellConfigWithClassName:NSStringFromClass([CommodityInfoCell class]) title:@"购买信息" showInfoMethod:@selector(showInfo:) heightOfCell:_modelToShow.cellHeight cellType:NO];
        
//        CellConfig *comSelect = [CellConfig cellConfigWithClassName:@"CommoditySelectCell" title:@"已选" showInfoMethod:@selector(showInfo:) heightOfCell:80.0f cellType:YES];
//        
//        CellConfig *comAddress = [CellConfig cellConfigWithClassName:@"CommodityAddressCell" title:@"地址" showInfoMethod:@selector(showInfo:) heightOfCell:180.0f cellType:YES];
        
//        CellConfig *comPack = [CellConfig cellConfigWithClassName:@"CommodityPackCell" title:@"包装" showInfoMethod:@selector(showInfo:) heightOfCell:50.0f cellType:YES];
//        
//        CellConfig *comPraise = [CellConfig cellConfigWithClassName:@"CommodityPraiseCell" title:@"评价" showInfoMethod:@selector(showInfo:) heightOfCell:80.0f cellType:YES];
//        
//        CellConfig *comSection = [CellConfig cellConfigWithClassName:@"CommoditySectionCell" title:@"专区" showInfoMethod:@selector(showInfo:) heightOfCell:110.0f cellType:YES];
//        
//        CellConfig *comComponent = [CellConfig cellConfigWithClassName:@"CommodityComponentCell" title:@"配件" showInfoMethod:@selector(showInfo:) heightOfCell:50.0f cellType:YES];
        
        [_dataArray addObject:@[comInfo]];//,comSelect,comAddress,comPack,comPraise,comSection,comComponent]];
        // 注意，是self.dataArray二维数组，所以这里要套一层数组
        
    }
     return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getSourceData:self.productIDStr];
    
    //设置导航栏
    [self setupNavigationItem];
    
}


- (void)getSourceData:(NSString *)productIDStr
{
        NSDictionary *dic = @{@"sellType":@"normal",@"id":productIDStr,@"userId":@""};
        NSLog(@" ------ %@ ------",dic);
        [QSCHttpTool get:@"https://123.56.192.182:8443/app/product/goodsDetail?" parameters:dic isShowHUD:YES httpToolSuccess:^(id json) {
            NSLog(@"正确返回%@",json);
//            self.dataDic = [NSDictionary dictionaryWithDictionary:json];
//            NSLog(@"dataDic%@",json);
//            NSString *path = @"/Users/mymac/Desktop/";
//            NSString *fileName = [path stringByAppendingPathComponent:@"Product.plist"];
//            NSFileManager *fm = [NSFileManager defaultManager];
//            [fm createFileAtPath:fileName contents:nil attributes:nil];
//            [json writeToFile:fileName atomically:YES];
            _modelToShow = [[DetailsMode alloc] initWithDictionary:json];
            //初始化视图
            [self initView];

            } failure:^(NSError *error) {
            NSLog(@"错误返回%@",error);
        }];
}

- (void)setupNavigationItem {
    self.navigationItem.title=@"商品详情";
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.rightBarButtonItems =@[[UIBarButtonItem BarButtonItemWithBackgroudImageName:@"ware_more" highBackgroudImageName:nil target:self action:@selector(wareMoreClick)], [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"ware_histroy" highBackgroudImageName:nil target:self action:@selector(wareMoreClick)]];

}

- (void)initView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-100) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView =[self addHeaderView];
    
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-60, self.view.width, 60)];
    view.backgroundColor=RGBA(0, 0, 0, 0.8);
    [self.view addSubview:view];
    
    UIButton * addCart =[UIButton createButtonWithFrame:CGRectMake(view.size.width-160, 0, 160, view.size.height) Title:@"加入购物车" Target:self Selector:@selector(addCartClick)];
    [addCart.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [addCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [addCart setBackgroundColor:RGB(255, 100, 98)];

    [view addSubview:addCart];
    UIView * view1=[[UIView alloc]initWithFrame:CGRectMake(0, 0, view.size.width-addCart.size.width, view.size.height)];
    [view addSubview:view1];
    UIButton * focus =[UIButton createButtonWithImage:@"wareb_focus" Title:@"关注" Target:self Selector:@selector(addCartClick)];
    [focus setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    focus.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 20, 0);
    focus.titleEdgeInsets = UIEdgeInsetsMake(40,-35, 0, 0);
    [view1 addSubview:focus];
    
    UIButton * cart =[UIButton createButtonWithImage:@"btn_ware_buy_h" Title:@"购物车" Target:self Selector:@selector(cartClick)];
    [cart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cart.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 20, 0);
    cart.titleEdgeInsets = UIEdgeInsetsMake(40,-35, 0, 0);
    [view1 addSubview:cart];
    [MasonyUtil equalSpacingView:@[focus,cart]
                       viewWidth:view1.size.width/2
                      viewHeight:view1.size.height
                  superViewWidth:view1.size.width];
}

- (UIView*)addHeaderView{

//    _images = @[[UIImage imageNamed:@"h1.jpg"],
//                [UIImage imageNamed:@"h2.jpg"],
//                [UIImage imageNamed:@"h3.jpg"],
//                [UIImage imageNamed:@"h4.jpg"]
//                 ];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width)];
    view.backgroundColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        _images = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < _modelToShow.previewImgs.count; i++) {
            [_images addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_modelToShow.previewImgs[i][@"path"]]]]];
        }
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, view.size.width, view.size.height) imageNamesGroup:_images];

        cycleScrollView.autoScroll = NO;
        cycleScrollView.infiniteLoop = NO;
        cycleScrollView.delegate = self;
        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
       dispatch_async(dispatch_get_main_queue(), ^{
            [view addSubview:cycleScrollView];
            UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"circleBackground"]];
            imageView.frame=CGRectMake(cycleScrollView.size.width-70, cycleScrollView.size.height-70, 50, 50);
            [cycleScrollView addSubview:imageView];
            _indexPage=[[UILabel alloc]initWithFrame:CGRectMake(0,0, imageView.size.width, imageView.size.height)];
            _indexPage.textAlignment = NSTextAlignmentCenter;
            _indexPage.font=[UIFont systemFontOfSize:24];
            _indexPage.textColor=[UIColor whiteColor];
            _indexPage.text=[NSString stringWithFormat:@"%i/%i",cycleScrollView.indexPage+1,(int)_images.count];
            [imageView addSubview:_indexPage];
           });
    });
    return view;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {


    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   return [self.dataArray[section] count];
}

#pragma mark 设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 拿到cellConfig
    CellConfig *cellConfig = self.dataArray[indexPath.section][indexPath.row];
    // 拿到对应cell并根据模型显示
    UITableViewCell *cell = [cellConfig cellOfCellConfigWithTableView:tableView dataModel:self.modelToShow cellForRowAtIndexPath:indexPath];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CellConfig *cellConfig = self.dataArray[indexPath.section][indexPath.row];

    return _modelToShow.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}
#pragma mark - TableView Delegate
#pragma mark 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==5) {
        return 15;
    }
    return 0.001;
}



- (void)wareMoreClick{
    
}
-(void)showLoginView{

    QSCNavigationController *loginView = [[QSCNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    
    [self presentViewController:loginView animated:YES completion:nil];
}
- (void)addCartClick{
    
    
//    if ([UserDefaultsUtils getOwnID] == 0) {
//        [self showLoginView];
//        return;
//    }
    [FYTXHub toast:@"请先登录"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FYTXHub dismiss];
    });
    
}

- (void)cartClick{
//    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//    [self.navigationController.view addSubview:HUD];
//    
//    HUD.mode = MBProgressHUDModeCustomView;
//    
//    HUD.delegate = self;
//    HUD.labelText = @"请先登录";
//    
//    [HUD show:YES];
//    [HUD hide:YES afterDelay:2];
//    CartViewController * cartVC=[[CartViewController alloc]init];
//    [self.navigationController pushViewController:cartVC animated:YES];
    
    [FYTXHub toast:@"请先登录"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [FYTXHub dismiss];
    });
    return;
    
    //TODO:要做登录判断
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [JLTabMainController shareJLTabVC];
    [JLTabMainController shareJLTabVC].selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    _indexPage.text=[NSString stringWithFormat:@"%i/%i",(int)index+1,(int)_images.count];
}
@end
