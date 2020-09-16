//
//  FirstPresentedController.m
//  RootTabController
//
//  Created by ShenYj on 2020/9/15.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "PresentedController.h"
#import "SceneDelegate.h"

@interface PresentedController ()

@end

@implementation PresentedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor systemOrangeColor];
    self.descriptionTextView.backgroundColor = self.view.backgroundColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemClose target:self action:@selector(targetForDismiss:)];
}

- (void)targetForDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setModalStyleDescription:(NSString *)modalStyleDescription {
    _modalStyleDescription = modalStyleDescription;
    NSArray <UIScene *> *allScenes = [[[UIApplication sharedApplication] connectedScenes] allObjects];
    UIScene *defaultScene = allScenes.firstObject;
#pragma clang push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    id response = [[(SceneDelegate *)defaultScene.delegate window] performSelector:@selector(recursiveDescription)];
#pragma clang pop
    self.descriptionTextView.text = [NSString stringWithFormat:@"%@ \n 当前视图栈:\n %@", modalStyleDescription, response];
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
