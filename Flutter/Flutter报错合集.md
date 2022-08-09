# Flutter报错合集

这里有个收集了比较多错误的网站：https://www.jianshu.com/p/b7dccb338fa5

---

1.

问题：warning: The iOS Simulator deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 8.0, but the range of supported deployment target versions is 9.0 to 15.0.99.

原因：Pod里版本不适配，

解决：在Podfile里找到`post_install do |installer|`方法，并用如下替换

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 9.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
       end
    end
  end
end
```

---

2.

问题：flutter Warning: Operand of null-aware operation '!' has type 'WidgetsBindin

原因：flutter 升级后，package未更新

解决：

```
flutter pub get  或 flutter pub upgrade
```

