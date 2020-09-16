//
//  ViewController.m
//  RootTabController
//
//  Created by ShenYj on 2020/9/15.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "RootViewController.h"
#import "FirstPresentedController.h"
#import "NavigationController.h"


/**
 
 UIModalPresentationFullScreen = 0,
 UIModalPresentationPageSheet API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(tvos),
 UIModalPresentationFormSheet API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(tvos),
 UIModalPresentationCurrentContext API_AVAILABLE(ios(3.2)),
 UIModalPresentationCustom API_AVAILABLE(ios(7.0)),
 UIModalPresentationOverFullScreen API_AVAILABLE(ios(8.0)),
 UIModalPresentationOverCurrentContext API_AVAILABLE(ios(8.0)),
 UIModalPresentationPopover API_AVAILABLE(ios(8.0)) API_UNAVAILABLE(tvos),
 UIModalPresentationBlurOverFullScreen API_AVAILABLE(tvos(11.0)) API_UNAVAILABLE(ios) API_UNAVAILABLE(watchos),
 UIModalPresentationNone API_AVAILABLE(ios(7.0)) = -1,
 UIModalPresentationAutomatic API_AVAILABLE(ios(13.0)) = -2,
 
 */

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    FirstPresentedController *firstPre = [[FirstPresentedController alloc] init];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:firstPre];
    // MARK: iOS 13默认变成了 UIModalPresentationAutomatic
    // MARK: 指定为 UIModalPresentationOverFullScreen
    /**
     与UIModalPresentationFullScreen的唯一区别在于，UIWindow下除了presented VC，还有其他正常的VC层级关系。也就是说该模式下，UIKit以rootViewController为presentation context，但presentation完成之后不会讲rootViewController移出当前的UI栈。
     
     使用了此类型后, 在dismiss 后, presenting的`viewWillAppear`和`viewWillDisappear`回调不再被触发
     */
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    // MARK: 指定为 UIModalPresentationFullScreen TabBarController会从视图栈移除
    /**
     UIKit默认的presentation style。 使用这种模式时，presented VC的宽高与屏幕相同，并且UIKit会直接使用rootViewController做为presentation context，在此次presentation完成之后，UIKit会将presentation context及其子VC都移出UI栈，这时候观察VC的层级关系，会发现UIWindow下只有presented VC.
     
     使用了此类型后, 在dismiss 后, presenting的`viewWillAppear`和`viewWillDisappear`回调会被触发
     */
//    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:nav animated:YES completion:nil];
}

@end
