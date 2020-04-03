//
//  KMViewController.m
//  KMOnlineWeb
//
//  Created by zhenlove on 03/19/2020.
//  Copyright (c) 2020 zhenlove. All rights reserved.
//

#import "KMViewController.h"
//#import "KMOnlineManager.h"
//#import <KMOnlineWeb/KMOnlineManager.h>
@import KMNetwork;
@import KMOnlineWeb;
@interface KMViewController ()

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [KMServiceModel  setupParameterWithAppid:@"KMZSYY"
                                   appsecret:@"KMZSYY#2016@20161010$$!##"
                                      appkey:@"KMZSYY2016"
                                       orgid:@"B1F0AF7AB9624847A3DDAFD573E2ECF0"
                                 environment:EnvironmentRelease1];
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary * dic = @{@"Number":@"wangge",
                           @"Name":@"",
                           @"Mobile":@"",
                           @"IdNumber":@"",
                           @"HeadUrl":@"",
                           @"OrgID":@"B1F0AF7AB9624847A3DDAFD573E2ECF0"};
//    [[KMOnlineManager sharedInstance] reloadWebViewWithUrl:@"https://pruser.kmwlyy.com/h5/"
//                                                   withDic:dic
//                                        showViewController:self];
    
    [[OnlineWebManager sharedInstance] reloadWebViewWithUrl:@"https://pruser.kmwlyy.com/h5/"
                                                userInfoDic:dic
                                         showViewController:self];
    
}

@end
