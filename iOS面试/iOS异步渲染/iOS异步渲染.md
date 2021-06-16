# iOS异步渲染

概括：为解决列表上的复杂图形渲染，导致滑动卡顿。在子线程里将复杂图形绘制好，再在主线程里显示。

### 一、UIView的绘制渲染原理

![UIView绘制流程](/Users/fengbufang/Desktop/Blogs/iOS面试/iOS异步渲染/UIView绘制流程.webp)

是否使用异步绘制，关键在于UIView是否重写了layer的代理方法

```swift
override func display(_ layer: CALayer) {}
```

1.UIView调用setNeedsDisplay（setNeedsDisplay会调用自动调用drawRect方法）;

2.系统会立刻调用view的layer的同名方法[view.layer setNeedsDisplay],之后相当于在layer上面打上了一个脏标记;

3.然后再当前runloop将要结束的时候,才会调用CALayer的display函数方法，然后才进入到当前视图的真正绘制工作的流程当中

4.runloop即将结束, 开始视图的绘制流程

### 二、系统默认绘制流程

![UIView系统绘制流程](/Users/fengbufang/Desktop/Blogs/iOS面试/iOS异步渲染/UIView系统绘制流程.webp)

1.CALayer内部创建一个backing store(CGContextRef)();

2.判断layer是否有代理（1.有代理:调用delegete的drawLayer:inContext, 然后在合适的 实际回调代理, 在[UIView drawRect]中做一些绘制工作;2. 没有代理:调用layer的drawInContext方法。）

3.layer上传backingStore到GPU, 结束系统的绘制流程

### 三、异步绘制流程

![UIView异步绘制流程](/Users/fengbufang/Desktop/Blogs/iOS面试/iOS异步渲染/UIView异步绘制流程.webp)

1.某个时机调用setNeedsDisplay

2.runloop将要结束的时候调用[CALayer display]

3.如果代理实现了dispalyLayer将会调用此方法, 在子线程中去做异步绘制的工作;

4.子线程中做的工作:创建上下文, 控件的绘制, 生成图片;

5.转到主线程, 设置layer.contents, 将生成的视图展示在layer上面;

```swift
/// 这里实现了异步绘制的label
class MyLabel: UILabel {

    override func display(_ layer: CALayer) {
        let size = bounds.size
        let scale = UIScreen.main.scale
        DispatchQueue.global().async {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            let context = UIGraphicsGetCurrentContext()!
            self.draw(context: context, size: size)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            DispatchQueue.main.async {
                self.layer.contents = image?.cgImage
            }
        }
    }
    
    private func draw(context: CGContext, size: CGSize) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context.textMatrix = .identity
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.setFillColor(backgroundColor!.cgColor)
        context.fill(rect)
        
        let path = CGMutablePath()
        path.addRect(rect)
        
        let text = self.text ?? ""
        let attrStr = NSMutableAttributedString(string: text)
        attrStr.addAttributes([.font: font!,.foregroundColor: textColor!], range: NSMakeRange(0, text.count))
        let frameSetter = CTFramesetterCreateWithAttributedString(attrStr)
        
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, attrStr.length), path, nil)
        CTFrameDraw(frame, context)
    }
}

```

异步绘制的相关视图，建议直接使用YYKit中的组件[YYAsyncLayer](https://github.com/ibireme/YYAsyncLayer)