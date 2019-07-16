//
//  ScoreView.m
//  BxProject
//
//  Created by qinxinghua on 2019/7/16.
//  Copyright © 2019 qinxinghua. All rights reserved.
//

#import "ScoreView.h"

@interface ScoreViewConfig()
@end
@implementation ScoreViewConfig
@end


@interface ScoreView()
@property(nonatomic, copy) NSMutableArray<UIButton *> *buttonContainer;
@end

@implementation ScoreView

- (NSMutableArray*)buttonContainer
{
    if(!_buttonContainer) {
        _buttonContainer = [NSMutableArray array];
    }
    return _buttonContainer;
}

- (void)setConfig:(nonnull ScoreViewConfig *)config
{
    _config = config;
    [self configMyView];
    
}

- (void)configMyView
{
    for (int i = 0; i < self.config.count; i++) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [self addSubview: button];
        button.tag = (long)i;
        // 目前的设计是每个图标是正方形，宽高相等，高度等于父视图h高度，所以取宽度的时候也是用高度
        CGFloat height = self.frame.size.height;
        CGFloat width = height;
        CGFloat buttonX = self.config.margin + width * i;
        button.frame = CGRectMake(buttonX, 0, width, height);
        button.adjustsImageWhenHighlighted = NO;
        [button setBackgroundImage: self.config.normalImage forState: UIControlStateNormal];
        [button setBackgroundImage: self.config.normalImage forState: UIControlStateSelected];
        [button addTarget: self action:@selector(buttonClick:) forControlEvents: UIControlEventTouchUpInside];
        [self.buttonContainer addObject: button];
    }
}

- (void)buttonClick:(UIButton*)button
{
    for (UIButton *subView in self.buttonContainer) {
            if (subView.tag <= button.tag) {
                [subView setBackgroundImage: self.config.selectImage forState: UIControlStateNormal];
            } else {
                [subView setBackgroundImage: self.config.normalImage forState: UIControlStateNormal];
            }
    }
}
@end
