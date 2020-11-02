### xcode_shell
一键打包shell脚本

使用 xcodebuild -exportArchive -archivePath
xcode8.3版本以前使用的是 PackageApplication

不要勾选 xcode 中的 Automatically manage signing，使用在命令指定签名证书的方式；

### 遇到的问题
- 如果项目中使用了cocoapods管理三方库，在编译时会遇到如下错误：

``
error: Pods-DuduiOS does not support provisioning profiles. Pods-DuduiOS does not support provisioning profiles, but provisioning profile XX-AdHoc has been manually specified. Set the provisioning profile value to "Automatic" in the build settings editor. (in target 'Pods-DuduiOS' from project 'Pods')
``

The issue is that the newest version of Cocoapods is trying to sign the frameworks.

- 打包成功，但是导出失败

```
error: exportArchive: AFNetworking.framework does not support provisioning profiles.

Error Domain=IDEProvisioningErrorDomain Code=10 "AFNetworking.framework does not support provisioning profiles." UserInfo={IDEDistributionIssueSeverity=3, NSLocalizedDescription=AFNetworking.framework does not support provisioning profiles., NSLocalizedRecoverySuggestion=AFNetworking.framework does not support provisioning profiles, but provisioning profile ZG-AdHoc has been manually specified. Remove this item from the "provisioningProfiles" dictionary in your Export Options property list.}
```

这是 Podfile 文件中使用了 use_frameworks!造成的坑，这是因为使用了 use_frameworks! 后,CocoaPods 要对每一个 Framework 进行证书签名,而每个 Framework 的 bundleID 都是不一样的;

解决办法：

- 去掉 use_frameworks! 或使用 use_modular_headers! 代替;
如果pod中引用了swift写的三方库，仅仅去掉 use_framworks!，执行pod install时会报错：
```
[!] The following Swift pods cannot yet be integrated as static libraries:

The Swift pod `DKPhotoGallery` depends upon `SDWebImage`, which does not define modules. To opt into those targets generating module maps (which is necessary to import them from Swift when building as static libraries), you may set `use_modular_headers!` globally in your Podfile, or specify `:modular_headers => true` for particular dependencies.
```
必须使用加 use_modular_headers!


### 参考
https://stackoverflow.com/questions/55419956/how-to-fix-pod-does-not-support-provisioning-profiles-in-azure-devops-build

https://stackoverflow.com/questions/39954673/manual-signing-fails-for-xcode-test-with-embedded-library-can-it-be-decomposed

http://ddrv.cn/a/315218
