#注意：脚本目录和xxxx.xcworkspace要在同一个目录，如果放到其他目录，请自行修改脚本。
#工程名字(Target名字)
Project_Name="xxxx"
#配置环境，Release或者Debug
Configuration="Release"
#AdHoc版本的Bundle ID
AdHocBundleID="com.xx.xx"

# ADHOC
#证书名#描述文件
ADHOCCODE_SIGN_IDENTITY="iPhone Distribution: xx xx (xxxx)"
ADHOCPROVISIONING_PROFILE_NAME="xxxx-xxx-xxx-xxx-xxxx"

#加载各个版本的plist文件
AdhocExportOptionsPlist=./adhoc_export_option.plist

AdhocExportOptionsPlist=${AdhocExportOptionsPlist}

echo "Clean..."
rm -rf ipa_archive
rm -rf build/
xcodebuild -quiet clean -workspace ./$Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration

echo "Adhoc 打包..."
xcodebuild -quiet -workspace $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-adhoc.xcarchive clean archive build CODE_SIGN_IDENTITY="${ADHOCCODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ADHOCPROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AdHocBundleID}"
if [ $? -eq 0 ]; then
    xcodebuild -quiet -exportArchive -archivePath build/$Project_Name-adhoc.xcarchive -exportOptionsPlist $AdhocExportOptionsPlist -exportPath ipa_archive
    if [ $? -eq 0 ]; then
        echo "上传蒲公英..."
        curl -F 'file=@ipa_archive/Runner.ipa' -F '_api_key=xxxx' https://www.pgyer.com/apiv2/app/upload
        if [ $? -eq 0 ]; then
            echo -e "\n\n\033[5;32m 上传成功！\033[0m\n"
            sleep 0.5
            rm -rf ipa_archive
            rm -rf build/
        else
            echo -e "\n\033[31m 上传失败！\033[0m\n"
        fi
	 
    else
        echo -e "\n\033[31m 导出失败！ \033[0m\n"
    fi
else
    echo -e "\n\033[31m 打包失败！ \033[0m\n"
fi
