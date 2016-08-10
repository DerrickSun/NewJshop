//
//  CommodityTableViewController.m
//  jdmobile
//
//  Created by SYETC02 on 15/6/19.
//  Copyright (c) 2015年 SYETC02. All rights reserved.
//

#import "CommodityTableViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "NSString+FontAwesome.h"
#import "SearchBarView.h"
//#import "JDNavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "CommodityModel.h"
#import "CommodityTableViewCell.h"
//#import "DetailsViewController.h"
#import "ShopNextController.h"
#import "JLFlowLayout.h"
#import "JLCommdoityCollectionCell.h"
#import "UIScrollView+MJRefresh.h"
#import "DetailsViewController.h"
#import <UIImageView+WebCache.h>

@interface CommodityTableViewController ()<SearchBarViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UITableView *_tableView;
    JLFlowLayout * _layout;
    UICollectionView * _collectionView;
    NSMutableArray *_commodity;
}
@end

@implementation CommodityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化数据
    [self initData:self.secondMenuIDStr];
    //设置导航栏
    [self setupNavigationItem];
    //初始化视图
    [self initView];
    
    
}

-(void)refresh
{
    NSLog(@"上啦刷新");
    [_tableView.mj_header endRefreshing];
}

-(void)loadMore
{
    NSLog(@"下啦刷新");
    [_tableView.mj_footer endRefreshing];
}
#pragma mark 加载数据
-(void)initData:(NSString *)menuID{

    _commodity=[[NSMutableArray alloc]init];
    
    NSString *parameterStr = [NSString stringWithFormat:@"{\"name\":\"\",\"goodsType\":\"2\",\"id\":\"%@\",\"pageno\":\"0\",\"pagesize\":\"0\",\"orderType\":\"\",\"orderDes\":\"\"}",menuID];
    NSDictionary *dic = @{@"arg0":parameterStr};

    NSLog(@" ------ %@ ------",dic[@"arg0"]);
    [QSCHttpTool get:@"https://123.56.192.182:8443/app/product/listGoods?" parameters:dic isShowHUD:YES httpToolSuccess:^(id json) {
        
//        NSArray *array=[NSArray arrayWithArray:json];
//        
//        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [_commodity addObject:[CommodityModel commodityWithDictionary:obj]];
//        }];
        NSLog(@"json---%@",json);
        [_commodity setArray:json];
            if (!_tableView) {
                //创建一个分组样式的UITableView
                _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64-40) style:UITableViewStylePlain];
                //设置数据源，注意必须实现对应的UITableViewDataSource协议
                _tableView.dataSource=self;
                //设置代理
                _tableView.delegate=self;
                _tableView.rowHeight = 90;
                _tableView.backgroundColor=RGB(240, 243, 245);
                [self.view addSubview:_tableView];
                
                [_tableView registerNib:[UINib nibWithNibName:@"CommodityTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
                _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
                
                _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
            }
        
        } failure:^(NSError *error) {
        NSLog(@"-----%@",error);
    }];
//    NSString *path=[[NSBundle mainBundle] pathForResource:@"Commodity" ofType:@"plist"];
}
- (void)setupNavigationItem {
 
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"back_bt_7" highBackgroudImageName:nil target:self action:@selector(backClick)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"main_bottom_tab_cart_focus" highBackgroudImageName:nil target:self action:@selector(changeClick:)];
    //将搜索条放在一个UIView上
    SearchBarView *searchView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 0, 240 , 30)];
    searchView.delegate=self;
    self.navigationItem.titleView = searchView;
    self.navigationController.navigationBar.shadowImage=[[UIImage alloc]init];
}

- (void)initView{
    PPiFlatSegmentedControl *segmented=[[PPiFlatSegmentedControl alloc]
                                        initWithFrame:CGRectMake(0, 0, self.view.width, 40)
                                        items:
                                        @[
                                          @{@"text":@"销量"},
                                          @{@"text":@"价格",@"icon":@"icon-sort"},
                                          ]
                                        iconPosition:IconPositionRight
                                        andSelectionBlock:^(NSUInteger segmentIndex) {
                                            
                                             MYLog(@"第几个%ld",segmentIndex);
                                            switch (segmentIndex) {
                                                    
    
                                                case 0:
                                                    
                                                    break;
                                                case 1:
                                                    
                                                    break;
                                                case 2:
                                                    
                                                    break;
                                                case 3:
//                                                    [self.navigationController showRightMenu];
                                                    
                                                   
                                                    break;
                                                    
                                                default:
                                                    break;
                                            }
                                                                         }];
    
//    segmented.color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background"]];
    segmented.borderColor=[UIColor darkGrayColor];
    //segmented.selectedColor=[UIColor colorWithRed:0.0f/255.0 green:141.0f/255.0 blue:176.0f/255.0 alpha:1];
    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                NSForegroundColorAttributeName:RGB(135, 127, 141)};
    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                        NSForegroundColorAttributeName:RGB(243, 106, 107)};
    
    [self.view addSubview:segmented];
    
}


- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeClick:(UIButton*)rightButton{
//    if (rightButton.selected) {
    rightButton.selected = !rightButton.selected;
//    _tableView.hidden = rightButton.selected;//列表模式显示
//    _collectionView.hidden = !rightButton.selected;//放歌模式显示
//    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource数据源方法
//#pragma mark 返回分组数
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

#pragma mark 返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_commodity.count == 0) {
        _tableView.hidden = YES;
    }
    return _commodity.count;
}

#pragma mark返回每行的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier=@"Cell";
     CommodityTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(cell==nil){
////           cell=[[NSBundle mainBundle] loadNibNamed:@"CommodityTableViewCell" owner:self options:nil][0];
//    }

    CommodityModel *commodity = [[CommodityModel alloc] initWithDictionary:_commodity[indexPath.row]];
    
    [cell.commodityImg sd_setImageWithURL:[NSURL URLWithString:commodity.commodityImageUrl]];
    cell.commodityName.text=commodity.commodityName;
    cell.commodityPrice.text=[NSString stringWithFormat:@"￥%@",commodity.commodityPrice];
//    cell.commodityZX.image=[UIImage imageNamed:commodity.commodityZX];
//    cell.commodityPraise.text=commodity.praise;
    
    return cell;
}

#pragma mark - UITableViewDelegate代理方法

#pragma mark 每行点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %i", (int)indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    DetailsViewController * detailsTVC = [[DetailsViewController alloc]init];
//    [self.navigationController pushViewController:detailsTVC animated:YES];
    CommodityModel *commodity = [[CommodityModel alloc] initWithDictionary:_commodity[indexPath.row]];
    DetailsViewController *next = [[DetailsViewController alloc] init];
    next.productIDStr = [NSString stringWithFormat:@"%lld",commodity.Id];
    [self.navigationController pushViewController:next animated:YES];
}


#pragma mark 滑动事件
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view did begin dragging");
    
}

#pragma mark 写入plist文件

- (void)writeToLocalPlist:(id)json{
    NSString *path = @"/Users/mymac/Desktop/";
    NSString *fileName = [path stringByAppendingPathComponent:@"secondProduct.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:fileName contents:nil attributes:nil];
    [json writeToFile:fileName atomically:YES];
}

@end
