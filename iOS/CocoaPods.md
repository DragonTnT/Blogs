## CocoaPods

#### 问题解决：

1.Specs satisfying the `Alamofire (= 5.0.0-beta.4)` dependency were found, but they required a higher minimum deployment target.

pod在版本升级时，可能会出现这种错误。第三方库的版本已经找到，不过需要将Podfile里的Platform和程序里的Deployment target升级。这是因为语言升级引起的。上面的例子就是从Swift4迁移到Swift5引起的。