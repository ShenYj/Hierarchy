//
//  FirstPresentedController.h
//  RootTabController
//
//  Created by ShenYj on 2020/9/15.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PresentedController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, copy) NSString *modalStyleDescription;

@end

NS_ASSUME_NONNULL_END
