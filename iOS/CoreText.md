# CoreText

#### 使用CoreText的理由：

可以对富文本进行复杂的排版，相对于WebView的渲染方式，它的内存占用更少，渲染速度更快，交互效果更佳细腻。

#### 文本排版

通过重写UIView的drawRect方法，使用CoreText渲染内容。这里放一个最简单的demo

```swift
class CTDisplayView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.textMatrix = CGAffineTransform.identity
        context.translateBy(x: 0, y: bounds.size.height)
        context.scaleBy(x: 1, y: -1)
        
        let path = CGPath(rect: bounds, transform: nil)
        let attrStr = NSAttributedString(string: "Hello World")

        let frameSetter = CTFramesetterCreateWithAttributedString(attrStr)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attrStr.length), path, nil)
        
        CTFrameDraw(frame, context)
    }

}
```

我们所要做的就是：传入渲染的文本，生成frameSetter，再生成frame，完成绘制。

对于文本的样式，是由NSAttributeString来实现，由请求到的Json文件里，解析出多个段落对应的字典，每个字典生成一个NSAttributeString，最后将这些NSAttributeString拼接在一起，就拿到了全部的文本内容。绘制时，假设排版方向为纵轴，在已知文本宽度的情况下，高度则由`CTFramesetterSuggestFrameSizeWithConstraints`计算得出。

####图文混排

在需要显示图片的地方用特殊的空白字符代替，再通过设置字体的CTRunDelegate的宽度和高度，就可以将图片需要显示的位置预留出来。因为CTDisplayView的绘制是在drawRect里完成，所以我们可以把需要绘制的图片，用CGContextDrawImage绘制出来。

//TODO

#### 点击事件

//TODO

参考文章：唐巧-CoreText  https://github.com/tangqiaoboy/iOS-Pro

