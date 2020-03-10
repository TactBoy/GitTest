#!/bin/bash

projectName="GitTest"

targetName="GitTest"
 
codeSign="iPhone Developer"

infoPlistPath="./${projectName}/Info.plist"

bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")

bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")

DATE="$(date +%Y%m%d)"

IPANAME="${targetName}_V${bundleShortVersion}_${DATE}.ipa"

IPA_PATH="$HOME/Desktop/${IPANAME}"

echo ${IPA_PATH}

xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -configuration 'Release' clean

xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -sdk iphoneos -configuration 'Release' CODE_SIGN_IDENTITY="${codeSign}" SYMROOT='$(PWD)'

#xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${targetName}.app" -o ~/"${IPANAME}"
xcrun -sdk iphoneos PackageApplication "./Release-iphoneos/${targetName}.app" -o "${IPA_PATH}"
#xcodebuild -exportArchive "./Release-iphoneos/${targetName}.app" -o ~/app.ipa
 
