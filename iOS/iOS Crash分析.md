# iOS Crash分析

首先来说说容易造成Crash的原因：

1. *unrecognized selector sent to instance*

分析：OC中常见于给对象发送了未定义的消息，如：`performSelector`，那么在使用该方法时，最好先通过`respondsToSelector`来验证是否可接受该消息；

同时，可依据消息转发机制，可对消息转发的三个过程进行MethodSwizzling。下面是我们为NSObject添加分类，并替换掉消息转发的第三步`forwardInvocation`，这样该类型的崩溃，就变成了调用showMessage

```objective-c
-(void)showMessage:(NSString*)message{
    NSLog(@"message = %@",message);
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    if ([super methodSignatureForSelector:aSelector] == nil) {
        NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
        return signature;
    }
    return [super methodSignatureForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL sel = @selector(showMessage:);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    anInvocation = [NSInvocation invocationWithMethodSignature:signature];
    [anInvocation setTarget:self];
    [anInvocation setSelector:sel];
    NSString *message = @"在第三步自己实现的方法，改了参数";
    [anInvocation setArgument:&message atIndex:2];
    if ([self respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:self];
    }else{
        [super forwardInvocation:anInvocation];
    }
}
```

当然，建议只在Release模式这么做，因为Debug模式下不利于定位问题所在。

---

2.NSArray一类的容器越界：

解决办法：通过MethodSwizzling对的NSArray的`objectAtIndexedSubscript`方法进行替换