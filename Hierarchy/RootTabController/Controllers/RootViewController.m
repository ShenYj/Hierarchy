//
//  ViewController.m
//  RootTabController
//
//  Created by ShenYj on 2020/9/15.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "RootViewController.h"
#import "PresentedController.h"
#import "NavigationController.h"
#import "TableViewCell.h"

NSString * const kModalPresentationStyle = @"kModalPresentationStyle";
NSString * const kModalPresentationName = @"kModalPresentationName";
NSString * const kModalPresentationDescription = @"kModalPresentationDescription";


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

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate>

@property (nonatomic, strong) NSArray <NSDictionary *> *dataSources;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // MARK: 如果再次注册, 就会重复注册两个reuseID, 调用时就不会取Storyboard中的Cell了, 结果就是TableView中不显示Storyboard中的Cell
    // [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:kTableViewCellReusedIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%s", __func__);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%s", __func__);
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"%s", __func__);
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"%s", __func__);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.dataSources[indexPath.row];
    NSString *showValue = info[kModalPresentationName];
    UIModalPresentationStyle modalStyle = [info[kModalPresentationStyle] integerValue];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReusedIdentifier forIndexPath:indexPath];
    cell.modalStyleLable.text = showValue;
    cell.style = modalStyle;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    /**
     UIKit搜索presentation context的顺序为：
     1. presenting VC
     2. presenting VC 的父VC
     3. presenting VC 所属的container VC
     4. rootViewController

     还有另外一种特殊情况，当我们在一个presented VC上再present一个VC时，UIKit会直接将这个presented VC做为presentation context。
     */
    NSDictionary *info = self.dataSources[indexPath.row];
    UIModalPresentationStyle modalStyle = [info[kModalPresentationStyle] integerValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (modalStyle == UIModalPresentationNone) {
            return;
        }
        PresentedController *presentedController = [[PresentedController alloc] init];
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:presentedController];
        nav.modalPresentationStyle = modalStyle;
        
        if (modalStyle == UIModalPresentationPopover) {
            UIPopoverPresentationController *popover = nav.popoverPresentationController;
            popover.delegate = self;
            popover.sourceView = [tableView cellForRowAtIndexPath:indexPath];
            popover.sourceRect = [tableView cellForRowAtIndexPath:indexPath].bounds;
        }
        
        [self presentViewController:nav animated:YES completion:^{
            presentedController.title = info[kModalPresentationName];
            presentedController.modalStyleDescription = info[kModalPresentationDescription];
        }];
    });
}

#pragma mark - UIAdaptivePresentationControllerDelegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    // 取消自适应
    return UIModalPresentationNone;
}

#pragma mark - lazy

- (NSArray<NSDictionary *> *)dataSources {
    if (!_dataSources) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone || [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            _dataSources = @[
                @{
                    kModalPresentationStyle: @(UIModalPresentationAutomatic),
                    kModalPresentationName: @"UIModalPresentationAutomatic",
                    kModalPresentationDescription: @"iOS 13+ 默认样式"
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationFullScreen),
                    kModalPresentationName: @"UIModalPresentationFullScreen",
                    kModalPresentationDescription: @"UIKit默认的presentation style。 使用这种模式时，presented VC的宽高与屏幕相同，并且UIKit会直接使用rootViewController做为presentation context，在此次presentation完成之后，UIKit会将presentation context及其子VC都移出UI栈，这时候观察VC的层级关系，会发现UIWindow下只有presented VC.\n使用了此类型后, 在dismiss 后, presenting的`viewWillAppear`和`viewWillDisappear`回调会被触发, 因为指定为 UIModalPresentationFullScreen TabBarController会从视图栈移除, dismiss后重新回到视图栈"
                }
                ,
                @{
                    kModalPresentationStyle: @(UIModalPresentationOverFullScreen),
                    kModalPresentationName: @"UIModalPresentationOverFullScreen",
                    kModalPresentationDescription: @"与UIModalPresentationFullScreen的唯一区别在于，UIWindow下除了presented VC，还有其他正常的VC层级关系。也就是说该模式下，UIKit以rootViewController为presentation context，但presentation完成之后不会讲rootViewController移出当前的UI栈。\n使用了此类型后, 在dismiss 后, presenting的`viewWillAppear`和`viewWillDisappear`回调不再被触发"
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationPageSheet),
                    kModalPresentationName: @"UIModalPresentationPageSheet",
                    kModalPresentationDescription: @""
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationFormSheet),
                    kModalPresentationName: @"UIModalPresentationFormSheet",
                    kModalPresentationDescription: @""
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationPopover),
                    kModalPresentationName: @"UIModalPresentationPopover",
                    kModalPresentationDescription: @""
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationCurrentContext),
                    kModalPresentationName: @"UIModalPresentationCurrentContext",
                    kModalPresentationDescription: @"使用这种方式present VC时，presented VC的宽高取决于presentation context的宽高，并且UIKit会寻找属性definesPresentationContext为YES的VC作为presentation context，具体的寻找方式会在下文中给出 。当此次presentation完成之后，presentation context及其子VC都将被暂时移出当前的UI栈。"
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationOverCurrentContext),
                    kModalPresentationName: @"UIModalPresentationOverCurrentContext",
                    kModalPresentationDescription: @"寻找presentation context的方式与UIModalPresentationCurrentContext相同，所不同的是presentation完成之后，不会将context及其子VC移出当前UI栈。但是，这种方式只适用于transition style为UIModalTransitionStyleCoverVertical的情况(UIKit默认就是这种transition style)。其他transition style下使用这种方式将会触发异常。"
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationCustom),
                    kModalPresentationName: @"*UIModalPresentationCustom",
                    kModalPresentationDescription: @"自定义模式，需要实现UIViewControllerTransitioningDelegate的相关方法，并将presented VC的transitioningDelegate 设置为实现了UIViewControllerTransitioningDelegate协议的对象。"
                },
                @{
                    kModalPresentationStyle: @(UIModalPresentationNone),
                    kModalPresentationName: @"*UIModalPresentationNone",
                    kModalPresentationDescription: @""
                },
            ];
        }
        else {
            _dataSources = @[];
        }
    }
    return _dataSources;
}

@end
