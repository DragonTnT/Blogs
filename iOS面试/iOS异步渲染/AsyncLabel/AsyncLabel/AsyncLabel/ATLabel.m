//
//  ATLabel.m
//  AsyncLabel
//
//  Created by 张伟 on 2019/10/9.
//  Copyright © 2019 张伟. All rights reserved.
//

#import "ATLabel.h"
#import "YYTransaction.h"
#import "YYAsyncLayer.h"
#import <CoreText/CoreText.h>

@interface ATLabel ()
{
    NSString *_text;
    UIFont *_font;
    UIColor *_textColor;
}
@end

@implementation ATLabel


- (void)setText:(NSString *)text {
    _text = text;
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)contentsNeedUpdated {
    // do update
    [self.layer setNeedsDisplay];
}

#pragma mark - YYAsyncLayer

+ (Class)layerClass {
    return YYAsyncLayer.class;
}

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    // capture current state to display task
    NSString *text = _text;
    UIFont *font = _font;
    UIColor *textColor = _textColor;
    
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        //...
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        if (isCancelled()) {
            NSLog(@"取消了");
            return;
        }
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);

        CGContextTranslateCTM(context, 0, size.height);

        CGContextScaleCTM(context, 1, -1);

        // 绘制区域
        CGMutablePathRef path = CGPathCreateMutable();

        CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));

        // 绘制的内容属性字符串
        NSDictionary *attributes = @{NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: textColor
                                     };

        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];

        // 使用NSMutableAttributedString创建CTFrame
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrStr);

        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrStr.length), path, NULL);
        if (isCancelled()) {
            NSLog(@"取消了");
            return;
        }
        // 使用CTFrame在CGContextRef上下文上绘制
        CTFrameDraw(frame, context);

    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            // finished
        } else {
            // cancelled
        }
    };
    
    return task;
}


@end
