#!/bin/bash

projectName="GitTest"

targetName="GitTest"
 
codeSign="iPhone Developer"

infoPlistPath="./${projectName}/Info.plist"

bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${infoPlistPath}")

bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${infoPlistPath}")

DATE="$(date +%Y%m%d%H%M%S)"

IPANAME="${targetName}_V${bundleShortVersion}_${DATE}.ipa"

xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -configuration 'Release' clean

xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -sdk iphoneos -configuration 'Release' CODE_SIGN_IDENTITY="${codeSign}" SYMROOT='$(PWD)'

if [ $? -eq 0 ]
then
    dirName="${targetName}_V${bundleShortVersion}_${DATE}"
    mkdir "${dirName}"

    IPA_PATH="${PWD}/${dirName}/${IPANAME}"

    #xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${targetName}.app" -o ~/"${IPANAME}"
    xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${targetName}.app" -o "${IPA_PATH}"

    #移动dsym文件到dir下
    mv -i "./Release-iphoneos/${targetName}.app.dSYM" "${dirName}"
    mv -i "./${dirName}" ~/Desktop
    rm -r ./Release-iphoneos

    echo "ipa path: ~/Desktop/${dirName}"

    #xcodebuild -exportArchive "./Release-iphoneos/${targetName}.app" -o ~/app.ipa
    else
    echo "文件不存在"
fi


 
