//
//  TableViewCell.h
//  RootTabController
//
//  Created by ShenYj on 2020/9/15.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN NSString * const kTableViewCellReusedIdentifier;

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *modalStyleLable;
@property (nonatomic, assign) UIModalPresentationStyle style;

@end

NS_ASSUME_NONNULL_END
