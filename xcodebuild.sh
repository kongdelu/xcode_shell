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

echo "===选择打包方式(输入序号)==="
echo "	1 Appstore"
echo "	2 Adhoc"
echo "	3 Enterprise"

# 读取用户输入并存到变量里
read parameter
sleep 0.5
method="$parameter"

# 判读用户是否有输入
if [ -n "$method" ]
then

#clean下
xcodebuild clean -xcworkspace ./$Project_Name/$Project_Name.xcworkspace -configuration $Configuration -alltargets

    if [ "$method" = "1" ]
    then

#appstore脚本
xcodebuild -project $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-appstore.xcarchive clean archive build  CODE_SIGN_IDENTITY="${APPSTORECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${APPSTOREROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AppStoreBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-appstore.xcarchive -exportOptionsPlist $AppStoreExportOptionsPlist -exportPath ~/Desktop/$Project_Name-appstore.ipa
    elif [ "$method" = "2" ]
    then
#adhoc脚本
xcodebuild -workspace $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-adhoc.xcarchive clean archive build CODE_SIGN_IDENTITY="${ADHOCCODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ADHOCPROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${AdHocBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-adhoc.xcarchive -exportOptionsPlist $AdhocExportOptionsPlist -exportPath ~/Desktop/$Project_Name-adhoc.ipa
    elif [ "$method" = "3" ]
    then
#企业打包脚本
xcodebuild -project $Project_Name.xcworkspace -scheme $Project_Name -configuration $Configuration -archivePath build/$Project_Name-enterprise.xcarchive clean archive build CODE_SIGN_IDENTITY="${ENTERPRISECODE_SIGN_IDENTITY}" PROVISIONING_PROFILE="${ENTERPRISEROVISIONING_PROFILE_NAME}" PRODUCT_BUNDLE_IDENTIFIER="${EnterpriseBundleID}"
xcodebuild -exportArchive -archivePath build/$Project_Name-enterprise.xcarchive -exportOptionsPlist $EnterpriseExportOptionsPlist -exportPath ~/Desktop/$Project_Name-enterprise.ipa
else
    echo "参数无效...."
    exit 1
    fi
fi
