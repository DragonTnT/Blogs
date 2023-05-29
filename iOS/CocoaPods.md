## CocoaPods

#### 问题解决：

1.Specs satisfying the `Alamofire (= 5.0.0-beta.4)` dependency were found, but they required a higher minimum deployment target.

pod在版本升级时，可能会出现这种错误。第三方库的版本已经找到，不过需要将Podfile里的Platform和程序里的Deployment target升级。这是因为语言升级引起的。上面的例子就是从Swift4迁移到Swift5引起的。



2.Xcode14.3（当前版本）出现的打包问题Command PhaseScriptExecution failed with a nonzero exit code,目前的解决办法是修改pod脚本内容。找到Pods-Targets Support Files-Pods-youchelai-Pods-youchelai-frameworks.sh，将`readlink "${source}"`中的readlink后面加上“- f ”，变成`readlink -f "${source}"`。

记住：每次Pod install后，需要重新设置。当前pod版本为1.11.3，注意后续Pod有最新版本后，是否解决了这个问题。当前记录时间：2023年4月14日