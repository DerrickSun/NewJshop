//
//  CategoryViewController.m
//  jdmobile
//
//  Created by SYETC02 on 15/6/12.
//  Copyright (c) 2015年 SYETC02. All rights reserved.
//

#import "CategoryViewController.h"
#import "SearchBarView.h"
#import "CategoryMeunModel.h"
#import "MultilevelMenu.h"
#import "AppDelegate.h"
#import "CommodityTableViewController.h"
#import "REFrostedViewController.h"
//#import "RightMenuTableViewController.h"
//#import "JDNavigationController.h"
#import "QSCHttpTool.h"
#import "AFNetworking.h"

@interface CategoryViewController ()<SearchBarViewDelegate>
{
    NSMutableArray * _list;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavigationItem];
    //初始化数据
    [self initData];
    //初始化分类菜单
    [self initCategoryMenu];
    
}
- (void)viewWillAppear:(BOOL)animated;
{
//     (( AppDelegate *) [UIApplication sharedApplication].delegate).avatar.hidden=YES;
}

- (void)setupNavigationItem {
    
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem BarButtonItemWithBackgroudImageName:@"ico_camera_7_gray" highBackgroudImageName:nil target:self action:@selector(cameraClick)];
    //将搜索条放在一个UIView上
    SearchBarView *searchView = [[SearchBarView alloc]initWithFrame:CGRectMake(0, 7, self.view.frame.size.width-60 , 30)];
    searchView.delegate=self;
    self.navigationItem.titleView = searchView;
}

- (void)cameraClick{
    
}

#pragma mark - 🔌 SearchBarViewDelegate Method
- (void)searchBarSearchButtonClicked:(SearchBarView *)searchBarView {
    MYLog(@"搜索");
}

- (void)searchBarAudioButtonClicked:(SearchBarView *)searchBarView {
  
}


- (void)initData{

     _list=[NSMutableArray arrayWithCapacity:0];
    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"NewCategory" ofType:@"plist"];
    NSArray *array=[NSArray arrayWithContentsOfFile:path];
    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
   
    for (int i=0; i<[array count]; i++) {
      
        CategoryMeunModel * meun=[[CategoryMeunModel alloc] init];
        meun.menuName=[array objectAtIndex:i][@"menuName"];
        meun.nextArray=[array objectAtIndex:i][@"TypeMenu"];
//        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        
//        for ( int j=0; j <[meun.nextArray count]; j++) {
//            
//            CategoryMeunModel * meun1=[[CategoryMeunModel alloc] init];
//            meun1.menuName=[meun.nextArray objectAtIndex:j][@"topName"];
//            meun1.nextArray=[meun.nextArray objectAtIndex:j][@"TypeMenu"];
        
        
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            for ( int k=0; k <[meun.nextArray count]; k++) {
                CategoryMeunModel * meun2=[[CategoryMeunModel alloc] init];
                meun2.menuName=[meun.nextArray objectAtIndex:k][@"typeName"];
                meun2.urlName=[meun.nextArray objectAtIndex:k][@"typeImg"];
                [zList addObject:meun2];
            }
            
            
            meun.nextArray=zList;
//            [sub addObject:meun];
//        }
        
        
//        _list=zList;
        [_list addObject:meun];
    }
}


- (void)initCategoryMenu{
    
    
      MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-49 - 64) WithData:_list withSelectIndex:^(NSInteger left, NSInteger right,CategoryMeunModel * info) {
        
        NSLog(@"点击的 菜单%@",info.menuName);
//         JDNavigationController *navigationController = [[JDNavigationController alloc] initWithRootViewController:[[CommodityTableViewController alloc] init]];
//        
//        JDNavigationController *menuController = [[JDNavigationController alloc]  initWithRootViewController:[[RightMenuTableViewController alloc] init]];
//        REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:menuController];
//        frostedViewController.direction = REFrostedViewControllerDirectionRight;
//        frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
//           [frostedViewController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//        [self presentViewController:frostedViewController animated:YES completion:nil];
//        
         //[self.navigationController pushViewController:frostedViewController animated:YES];
          
          CommodityTableViewController *commod = [[CommodityTableViewController alloc] init];
          [self.navigationController pushViewController:commod animated:YES];
    }];
    
    view.needToScorllerIndex=0; //默认是 选中第一行
    view.leftSelectColor=[UIColor redColor];
    view.leftSelectBgColor=[UIColor whiteColor];//选中背景颜色
    view.isRecordLastScroll=NO;//是否记住当前位置
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
