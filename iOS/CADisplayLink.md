# CADisplayLink

CADisplayLink 是一个用于显示的定时器，  它可以让用户程序的显示与屏幕的硬件刷新保持同步，iOS系统中正常的屏幕刷新率为60Hz（60次每秒）。
 CADisplayLink可以以屏幕刷新的频率调用指定selector，也就是说每次屏幕刷新的时候就调用selector，那么只要在selector方法里面统计每秒这个方法执行的次数，通过次数/时间就可以得出当前屏幕的刷新率了。

实际使用：通过检测FPS，对屏幕卡顿进行优化。

参考项目中`YYFPSLabel`的使用

```swift
- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    /// count为方法调用计数
    _count++;
    /// delta为两次调用之间的时间间隔
    NSTimeInterval delta = link.timestamp - _lastTime;
    /// 统计每秒的帧数，因此小于1时return
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
 
    self.text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
}
```

