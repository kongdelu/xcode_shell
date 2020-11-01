### xcode_shell
一键打包shell脚本

使用 xcodebuild -exportArchive -archivePath
xcode8.3版本以前使用的是 PackageApplication

不要勾选 xcode 中的 Automatically manage signing，使用在命令指定签名证书的方式；

### 遇到的问题
如果项目中使用了cocoapods管理三方库，在编译时会遇到如下错误：

``
error: Pods-DuduiOS does not support provisioning profiles. Pods-DuduiOS does not support provisioning profiles, but provisioning profile XX-AdHoc has been manually specified. Set the provisioning profile value to "Automatic" in the build settings editor. (in target 'Pods-DuduiOS' from project 'Pods')
``

The issue is that the newest version of Cocoapods is trying to sign the frameworks.

解决办法：

在podfile中添加一下代码即可：
```
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
end
```

### 参考
https://stackoverflow.com/questions/55419956/how-to-fix-pod-does-not-support-provisioning-profiles-in-azure-devops-build
