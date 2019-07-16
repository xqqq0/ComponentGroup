//
//  ScoreView.h
//  BxProject
//
//  Created by qinxinghua on 2019/7/16.
//  Copyright © 2019 qinxinghua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface ScoreViewConfig: NSObject
///
@property(nonatomic, assign) int count;
/// 常规素材
@property(nonatomic, strong) UIImage *normalImage;
/// 选中素材
@property(nonatomic, strong) UIImage *selectImage;
/// 两边间距
@property(nonatomic, assign) CGFloat margin;
@end


@interface ScoreView : UIView
@property(nonatomic, nonnull, strong)ScoreViewConfig *config;
@end



NS_ASSUME_NONNULL_END
