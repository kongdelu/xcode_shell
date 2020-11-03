#注意：脚本目录和xxxx.xcworkspace要在同一个目录，如果放到其他目录，请自行修改脚本。
#工程名字(Target名字)
Project_Name="xxx"
#配置环境，Release或者Debug
Configuration="Release"

#AdHoc版本的Bundle ID
AdHocBundleID="com.xxx"

#AppStore版本的Bundle ID
AppStoreBundleID="com.xxxxx"

#enterprise的Bundle ID
EnterpriseBundleID="com.xxxxx"

# ADHOC
#证书名#描述文件
ADHOCCODE_SIGN_IDENTITY="iPhone Distribution: xxx (xxx)"
ADHOCPROVISIONING_PROFILE_NAME="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#AppStore证书名#描述文件
APPSTORECODE_SIGN_IDENTITY="iPhone Distribution: xxx (xxx)"
APPSTOREROVISIONING_PROFILE_NAME="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#企业(enterprise)证书名#描述文件
ENTERPRISECODE_SIGN_IDENTITY="iPhone Distribution: xxx (xxx)"
ENTERPRISEROVISIONING_PROFILE_NAME="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

#加载各个版本的plist文件
AdhocExportOptionsPlist=./adhoc_export_option.plist
AppStoreExportOptionsPlist=./appstore_export_option.plist
EnterpriseExportOptionsPlist=./enterprise_export_option.plist

AdhocExportOptionsPlist=${AdhocExportOptionsPlist}
AppStoreExportOptionsPlist=${AppStoreExportOptionsPlist}
EnterpriseExportOptionsPlist=${EnterpriseExportOptionsPlist}

echo "====================="
echo "    1 Appstore"
echo "    2 Adhoc"
echo "    3 Enterprise"
echo "====================="
## 读取用户输入并存到变量里
read -p "选择打包方式(输入序号):" num
sleep 0.5
method=$num
# 判读用户是否有输入
if [ ! -n "$method" ];then
    echo "exit"
    exit
fi

if [ $method == 1 ]
then
   echo "Clean..."
   rm -rf ~/Desktop/$Project_Name-adhoc.ipa
   rm -rf build/
   xcodebuild -quiet clean -workspace ./$Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration
   echo "===================== Appstore 打包 ====================="
   xcodebuild -quiet -project $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-appstore.xcarchive clean archive build  CODE_SIGN_IDENTITY="${APPSTORECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${APPSTOREROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AppStoreBundleID}"
   xcodebuild -quiet -exportArchive -archivePath build/$Project_Name-appstore.xcarchive -exportOptionsPlist $AppStoreExportOptionsPlist -exportPath ~/Desktop/$Project_Name-appstore.ipa

elif [ $method == 2 ]
then
   echo "Clean..."
   rm -rf ~/Desktop/$Project_Name-adhoc.ipa
   rm -rf build/
   xcodebuild -quiet clean -workspace ./$Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration
   echo "===================== Adhoc 打包 ====================="
   xcodebuild -quiet -workspace $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-adhoc.xcarchive clean archive build CODE_SIGN_IDENTITY="${ADHOCCODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ADHOCPROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AdHocBundleID}"
   xcodebuild -quiet -exportArchive -archivePath build/$Project_Name-adhoc.xcarchive -exportOptionsPlist $AdhocExportOptionsPlist -exportPath ~/Desktop/$Project_Name-adhoc.ipa

elif [ $method == 3 ]
then
    echo "Clean..."
    rm -rf ~/Desktop/$Project_Name-adhoc.ipa
    rm -rf build/
    xcodebuild -quiet clean -workspace ./$Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration
    echo "===================== Enterprise 打包 ====================="
    xcodebuild -quiet -project $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-enterprise.xcarchive clean archive build CODE_SIGN_IDENTITY="${ENTERPRISECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ENTERPRISEROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${EnterpriseBundleID}"
    xcodebuild -quiet -exportArchive -archivePath build/$Project_Name-enterprise.xcarchive -exportOptionsPlist $EnterpriseExportOptionsPlist -exportPath ~/Desktop/$Project_Name-enterprise.ipa

else
   echo "无效序号..."
   exit 1
fi
