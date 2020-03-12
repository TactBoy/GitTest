##!/bin/bash
#
#projectName="GitTest"
#
#targetName="GitTest"
#
#codeSign="iPhone Developer"
#
#macPassword="1202"
#
#infoPlistPath="./${targetName}/Info.plist"
#
#exportOptionsPath="./ExportOptions.plist"
#
#if test ${targetName} = "GitTest"; then
#
#infoPlistPath="./${targetName}/Info.plist"
#
#elif test ${targetName} = "GitTest2"; then
#
#infoPlistPath="./GitTest2.plist"
#
#elif test ${targetName} = "GitTest3"; then
#
#infoPlistPath="./GitTest3.plist"
#
#fi
#
#bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${infoPlistPath}")
#
#bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${infoPlistPath}")
#
#if test ${bundleShortVersion} = "\$(MARKETING_VERSION)" ; then
#  bundleShortVersion=$(xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION =')
#fi
#
#if test ${bundleVersion} = "\$(CURRENT_PROJECT_VERSION)" ; then
#  bundleVersion=$(xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -showBuildSettings | grep CURRENT_PROJECT_VERSION | tr -d 'CURRENT_PROJECT_VERSION =')
#fi
#
#DATE="$(date +%Y_%m_%d_%H_%M_%S)"
#
#echo ""
#echo "start build project: ${projectName}, scheme: ${targetName}, version: ${bundleShortVersion}, build: ${bundleVersion}"
#echo ""
#
#IPANAME="${targetName}_V${bundleShortVersion}(${bundleVersion}).ipa"
#
#xcodebuild clean -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -configuration 'Release'  -quiet
#
##xcodebuild build -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -sdk iphoneos -configuration 'Release' CODE_SIGN_IDENTITY="${codeSign}" SYMROOT='$(PWD)' method="app-store" -quiet
#
#dirName="${targetName}_V${bundleShortVersion}_${DATE}"
#
#dirPath="~/Desktop/${dirName}"
#
#archivePath="${dirPath}/${targetName}"
#
#security unlock-keychain -p "${macPassword}" $keychainPath
#
#echo ""
#echo "archive to path ${dirPath}/${targetName}.xcarchive"
#echo ""
#
#xcodebuild archive -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -configuration 'Release' -archivePath "${archivePath}" -quiet
#
#if [ $? -eq 0 ]
#then
#
#echo ""
#echo "exportArchive to path ${dirPath}/${targetName}.ipa"
#echo ""
#
#xcodebuild -exportArchive -archivePath "${archivePath}.xcarchive" -exportPath "${dirPath}"  PROVISIONING_PROFILE_SPECIFIER ${codeSign} AppStore -exportOptionsPlist "${exportOptionsPath}" -quiet
#
#fi
#
#IC_USER="gavin.sun@mingdao.com"
#IC_PASSWORD="Ssh.0411"
#
#altool="/Applications/ApplicationLoader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
#
#IPAPATH="${dirPath}/${targetName}.ipa"
#
#echo ""
#echo "validate archive"
#echo ""
#
#${altool} -v -f "${IPAPATH}" -u $IC_USER -p $IC_PASSWORD
#
#if [ $? -eq 0 ]
#then
#
#echo ""
#echo "upload archive"
#echo ""
#${altool} --upload-app -f "${IPAPATH}" -u $IC_USER -p $IC_PASSWORD
#
#fi
#


