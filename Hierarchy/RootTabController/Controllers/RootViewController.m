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

@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

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
        [self presentViewController:nav animated:YES completion:^{
            presentedController.title = info[kModalPresentationName];
            presentedController.modalStyleDescription = info[kModalPresentationDescription];
        }];
    });
}

#pragma mark - lazy

- (NSArray<NSDictionary *> *)dataSources {
    if (!_dataSources) {
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
                kModalPresentationDescription: @""
            },
            @{
                kModalPresentationStyle: @(UIModalPresentationOverCurrentContext),
                kModalPresentationName: @"UIModalPresentationOverCurrentContext",
                kModalPresentationDescription: @""
            },
            @{
                kModalPresentationStyle: @(UIModalPresentationCustom),
                kModalPresentationName: @"*UIModalPresentationCustom",
                kModalPresentationDescription: @""
            },
            @{
                kModalPresentationStyle: @(UIModalPresentationNone),
                kModalPresentationName: @"*UIModalPresentationNone",
                kModalPresentationDescription: @""
            },
        ];
    }
    return _dataSources;
}

@end
