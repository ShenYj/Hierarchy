//
//  NavigationController.m
//  RootTabController
//
//  Created by ShenYj on 2020/9/15.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(targetForLeftBarButtonItem:)];
}

- (void)targetForLeftBarButtonItem:(id)sender
{
    if (self.presentingViewController) {
        [self presentDismiss];
        return;
    }
    [self navigationPop];
}

- (void)navigationPop
{
    [self popViewControllerAnimated:YES];
}

- (void)presentDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
