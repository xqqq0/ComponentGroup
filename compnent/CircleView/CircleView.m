//
//  CircleView.m
//  BxProject
//
//  Created by qinxinghua on 2019/7/15.
//  Copyright © 2019 qinxinghua. All rights reserved.
//

#import "CircleView.h"
// 文本显示layer
@interface CircleLayer: CALayer
@property(nonatomic, strong) CATextLayer *textLayer;
@property(nonatomic, assign) double number;
@end

@implementation CircleLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 创建并设置textLayer
        [self addSublayer: self.textLayer];
        self.number = 0;
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer
{
    return [super initWithLayer: layer];
}


- (void)setNumber:(double)number
{
    _number = number;
    self.textLayer.string = [NSString stringWithFormat:@"%f%%", _number * 100];
    // 文本layerh需要重新绘制
    [self.textLayer setNeedsDisplay];
    // 画圆弧，即调用 - (void)drawInContext:(CGContextRef)ctx 故需要调用
    [self setNeedsDisplay];
}

- (CATextLayer *)textLayer
{
    if(!_textLayer) {
        _textLayer = [[CATextLayer alloc] init];
        UIFont *font = [UIFont systemFontOfSize: 12];
        _textLayer.font = (__bridge CFTypeRef _Nullable)([font fontName]);
        _textLayer.foregroundColor = [[UIColor blueColor] CGColor];
        _textLayer.fontSize = font.pointSize;
        _textLayer.alignmentMode = kCAAlignmentCenter;
        _textLayer.contentsScale = UIScreen.mainScreen.scale;
        _textLayer.wrapped = YES;
    }
    return _textLayer;
}


// 重写layer
- (void)layoutSublayers
{
    [super layoutSublayers];
    self.textLayer.frame = CGRectMake(10, 50,100, 20);
}

@end


// 画弧度
@interface OneLayer : CircleLayer
@end
@implementation OneLayer
- (void)drawInContext:(CGContextRef)ctx
{
    //    UIColor *redColor1 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    //    redColor1.CGColor
    
    // 设置画笔颜色
    CGFloat redColor[4] = {0.99, 0.99, 0.99, 1.0}; // 等同于以上两句
    CGContextSetStrokeColor(ctx, redColor);
    
    // 设置画笔宽度
    CGFloat radius = self.frame.size.width * 0.45; // 半径比外边正矩形宽小一点
    CGContextSetLineWidth(ctx, radius * 0.08); // 画笔宽度等于半径的0.08
    
    // 设置断点的样式
    CGContextSetLineCap(ctx, kCGLineCapRound); // 圆形样式
    
    
    // 绘制圆弧
    /**
    x#> 圆心x
    y#> 圆心y
    radius#> 半径
    startAngle#> 开始弧度
    endAngle#> 结尾弧度
    clockwise#> 如果要顺时针绘制圆弧，则'顺时针'为1，否则为0。
     */
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    // 3点钟方向为 0； 6点钟方向为 π / 2； 9点钟方向为 π； 12点钟为 3π / 2(或者是-π / 2)
    // 所以根据需求其实弧度为 12点钟方向 3π / 2(或者是-π / 2)
    // 终止角度通过滑块的百分比算出 2π * 百分比 + 出事弧度（-π / 2）
    CGContextAddArc(ctx, centerX, centerY, radius, -M_PI_2, self.number * 2 * M_PI - M_PI_2, 0);
    // 渲染
    CGContextStrokePath(ctx);
}
@end



// 画填充
@interface TwoLayer : CircleLayer
@end
@implementation TwoLayer
- (void)drawInContext:(CGContextRef)ctx
{
    //    UIColor *redColor1 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    //    redColor1.CGColor
    
    // 设置画笔颜色
    CGFloat redColor[4] = {0.99, 0.99, 0.99, 1.0}; // 等同于以上两句
    CGContextSetFillColor(ctx, redColor);
    
    
    // 设置画笔宽度
    CGFloat radius = self.frame.size.width * 0.45; // 半径比外边正矩形宽小一点
    CGContextSetLineWidth(ctx, radius * 0.08); // 画笔宽度等于半径的0.08
    
    // 设置断点的样式
    CGContextSetLineCap(ctx, kCGLineCapRound); // 圆形样式
    
    
    // 现将画笔移动到圆心
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    CGContextMoveToPoint(ctx, centerX, centerY);
    // 画初始线，即12点钟方向点到圆形的直线，先获取12点钟方向的点
    CGPoint point = CGPointMake(centerX, self.frame.size.height * 0.05); // 正常Y应该是0.这里因为圆形没有紧贴矩形，还是有0.05的间隔
    CGContextAddLineToPoint(ctx, point.x, point.y);
    
    CGContextAddArc(ctx, centerX, centerY, radius, -M_PI_2, self.number * 2 * M_PI - M_PI_2, 0);
    // 画结尾线，只要闭合就可以
    CGContextClosePath(ctx);
    // 渲染
    CGContextFillPath(ctx);
}
@end



// 画弧度
@interface FourLayer : CircleLayer
@end
@implementation FourLayer
- (void)drawInContext:(CGContextRef)ctx
{
    
    // 画圆弧前先画背景圆圈
    CGFloat color0[4] = {0.1, 0.99, 0.99, 1.0};
    CGContextSetStrokeColor(ctx, color0);
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, self.frame.size.width * 0.45 * 0.07); // 画笔宽度等于半径的0.07
    // 矩形内部画圆，只要给出矩形的frame就可以了，我们四周都减去 0.05个百分比
    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width * 0.05, self.frame.size.height * 0.05, self.frame.size.width * 0.9, self.frame.size.height * 0.9));
    CGContextStrokePath(ctx);
    
    //    UIColor *redColor1 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    //    redColor1.CGColor
    // 设置画笔颜色
    CGFloat color1[4] = {0.99, 0.99, 0.99, 1.0}; // 等同于以上两句
    CGContextSetStrokeColor(ctx, color1);
    
    // 设置画笔宽度
    CGFloat radius = self.frame.size.width * 0.45; // 半径比外边正矩形宽小一点
    CGContextSetLineWidth(ctx, radius * 0.08); // 画笔宽度等于半径的0.08
    // 绘制圆弧
    /**
     x#> 圆心x
     y#> 圆心y
     radius#> 半径
     startAngle#> 开始弧度
     endAngle#> 结尾弧度
     clockwise#> 如果要顺时针绘制圆弧，则'顺时针'为1，否则为0。
     */
    
    // 设置端点的样式
    CGContextSetLineCap(ctx, kCGLineCapRound); // 圆形样式
    // 圆心
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    // 3点钟方向为 0； 6点钟方向为 π / 2； 9点钟方向为 π； 12点钟为 3π / 2(或者是-π / 2)
    // 所以根据需求其实弧度为 12点钟方向 3π / 2(或者是-π / 2)
    // 终止角度通过滑块的百分比算出 2π * 百分比 + 出事弧度（-π / 2）
    CGContextAddArc(ctx, centerX, centerY, radius, -M_PI_2, self.number * 2 * M_PI - M_PI_2, 0);
    // 渲染
    CGContextStrokePath(ctx);
}
@end



// 水平面填充
@interface ThreeLayer : CircleLayer
@end
@implementation ThreeLayer
- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat color0[4] = {0.1, 0.99, 0.99, 1.0};
    CGContextSetStrokeColor(ctx, color0);
    // 设置画笔宽度
    CGContextSetLineWidth(ctx, self.frame.size.width * 0.45 * 0.07); // 画笔宽度等于半径的0.07
    // 矩形内部画圆，只要给出矩形的frame就可以了，我们四周都减去 0.05个百分比
    CGContextAddEllipseInRect(ctx, CGRectMake(self.frame.size.width * 0.05, self.frame.size.height * 0.05, self.frame.size.width * 0.9, self.frame.size.height * 0.9));
    CGContextStrokePath(ctx);
    
    //    UIColor *redColor1 = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    //    redColor1.CGColor
    
    // 设置画笔颜色
    CGFloat redColor[4] = {0.99, 0.99, 0.99, 1.0}; // 等同于以上两句
    CGContextSetFillColor(ctx, redColor);
    
    
    // 设置画笔宽度
    CGFloat radius = self.frame.size.width * 0.45; // 半径比外边正矩形宽小一点
    CGContextSetLineWidth(ctx, radius * 0.08); // 画笔宽度等于半径的0.08
    
    // 设置断点的样式
    CGContextSetLineCap(ctx, kCGLineCapRound); // 圆形样式
    
    
    // 现将画笔移动到圆心
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height * 0.5;
    CGFloat startAngle = M_PI_2 - self.number * M_PI;
    CGFloat endAgle = M_PI_2 + self.number * M_PI;;
    
    CGContextAddArc(ctx, centerX, centerY, radius, startAngle, endAgle, 0);
    // 画结尾线，只要闭合就可以
    CGContextClosePath(ctx);
    // 渲染
    CGContextFillPath(ctx);
}
@end


























@interface CircleView()
@property(nonatomic, strong) OneLayer *cicleLayer1;
@property(nonatomic, strong) TwoLayer *cicleLayer2;
@property(nonatomic, strong) ThreeLayer *cicleLayer3;
@property(nonatomic, strong) FourLayer *cicleLayer4;
@property(nonatomic, strong) UISlider *slideer;
@end

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer: self.cicleLayer1];
        [self.layer addSublayer: self.cicleLayer2];
        [self.layer addSublayer: self.cicleLayer3];
        [self.layer addSublayer: self.cicleLayer4];
        [self addSubview: self.slideer];
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}


- (CircleLayer *)cicleLayer1
{
    if(!_cicleLayer1) {
        _cicleLayer1 = [[OneLayer alloc] init];
        _cicleLayer1.frame = CGRectMake(10, 10, (self.frame.size.width - 10 * 3) * 0.5, (self.frame.size.width - 10 * 3) * 0.5);
        UIColor *color = [UIColor colorWithRed: (arc4random() % 256)/255.0 green: (arc4random() % 256)/255.0 blue: (arc4random() % 256)/255.0 alpha:1];
        _cicleLayer1.backgroundColor = [color CGColor];
    }
    return _cicleLayer1;
}



- (CircleLayer *)cicleLayer2
{
    if(!_cicleLayer2) {
        _cicleLayer2 = [[TwoLayer alloc] init];
        _cicleLayer2.frame = CGRectMake((self.frame.size.width - 10 * 3) * 0.5 + 2 * 10, 10, (self.frame.size.width - 10 * 3) * 0.5, (self.frame.size.width - 10 * 3) * 0.5);
        UIColor *color = [UIColor colorWithRed: (arc4random() % 256)/255.0 green: (arc4random() % 256)/255.0 blue: (arc4random() % 256)/255.0 alpha:1];
        _cicleLayer2.backgroundColor = [color CGColor];
    }
    return _cicleLayer2;
}



- (CircleLayer *)cicleLayer3
{
    if(!_cicleLayer3) {
        _cicleLayer3 = [[ThreeLayer alloc] init];
        _cicleLayer3.frame = CGRectMake(10, (self.frame.size.height - 10 * 3) * 0.5 + 2 * 10, (self.frame.size.width - 10 * 3) * 0.5, (self.frame.size.height - 10 * 3) * 0.5);
        UIColor *color = [UIColor colorWithRed: (arc4random() % 256)/255.0 green: (arc4random() % 256)/255.0 blue: (arc4random() % 256)/255.0 alpha:1];
        _cicleLayer3.backgroundColor = [color CGColor];
    }
    return _cicleLayer3;
}


- (CircleLayer *)cicleLayer4
{
    if(!_cicleLayer4) {
        _cicleLayer4 = [[FourLayer alloc] init];
        _cicleLayer4.frame = CGRectMake((self.frame.size.width - 10 * 3) * 0.5 + 2 * 10, (self.frame.size.height - 10 * 3) * 0.5 + 2 * 10, (self.frame.size.width - 10 * 3) * 0.5, (self.frame.size.width - 10 * 3) * 0.5);
        UIColor *color = [UIColor colorWithRed: (arc4random() % 256)/255.0 green: (arc4random() % 256)/255.0 blue: (arc4random() % 256)/255.0 alpha:1];
        _cicleLayer4.backgroundColor = [color CGColor];
    }
    return _cicleLayer4;
}





- (CircleLayer*)setLayer:(CircleLayer*)layer frame:(CGRect)frame
{
    if(!layer) {
        layer = [[CircleLayer alloc] init];
        layer.frame = frame;
        UIColor *color = [UIColor colorWithRed: (arc4random() % 256)/255.0 green: (arc4random() % 256)/255.0 blue: (arc4random() % 256)/255.0 alpha:1];
        layer.backgroundColor = [color CGColor];
    }
    return layer;
}


- (UISlider *)slideer
{
    if(!_slideer) {
        _slideer = [[UISlider alloc] initWithFrame: CGRectMake(20, 5, self.frame.size.width - 2 * 20, 20)];
        [_slideer addTarget: self action: @selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slideer;
}


- (void)valueChange:(UISlider*)slieder
{
    self.cicleLayer1.number = self.slideer.value;
    self.cicleLayer2.number = self.slideer.value;
    self.cicleLayer3.number = self.slideer.value;
    self.cicleLayer4.number = self.slideer.value;
}
@end



