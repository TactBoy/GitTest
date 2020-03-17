##!/bin/bash

projectName="GitTest"

targetName=${target}

if test -z $targetName; then {
    targetName="GitTest"
}
fi

resultMessage=""

codeSign="iPhone Developer"

macPassword="1202"

buildNumber=${BUILD_NUMBER}

buildJob=${JOB_NAME}

if test -z $buildNumber; then {
    buildNumber="101"
}
fi

if test -z $buildJob; then {
    buildJob="GitTest"
}
fi

branchName=${GIT_BRANCH}

dirName="${buildJob}_#${buildNumber}"

dirPath="${HOME}/Desktop/${dirName}"

archivePath="${dirPath}/${targetName}"

keychainPath="${HOME}/Library/Keychains/login.keychain-db"

infoPlistPath="./${targetName}/Info.plist"

exportOptionsPath="./ExportOptions.plist"

bundleShortVersion=""
bundleVersion=""

DATE="$(date +%Y_%m_%d_%H_%M_%S)"

buildIsSuccess="true"

IPAPATH="${dirPath}/${targetName}.ipa"

#

if test ${targetName} = "GitTest"; then

infoPlistPath="./${targetName}/Info.plist"

elif test ${targetName} = "GitTest2"; then

infoPlistPath="./GitTest2.plist"

elif test ${targetName} = "GitTest3"; then

infoPlistPath="./GitTest3.plist"

fi

saveData(){

echo "saveData"

plistPath="${dirPath}/build.plist"
PlistBuddy="/usr/libexec/PlistBuddy"

currentPath=${PWD}

if test -e ${dirPath}; then
echo ""
else
cd ~/Desktop
mkdir ${dirName}
cd $currentPath
fi

cp ${infoPlistPath} ${plistPath}

$PlistBuddy -c "Clear Dict" ${plistPath}
$PlistBuddy -c "Add projectName string ${projectName}" ${plistPath}
$PlistBuddy -c "Add targetName string ${targetName}" ${plistPath}
$PlistBuddy -c "Add bundleShortVersion string ${bundleShortVersion}" ${plistPath}
$PlistBuddy -c "Add bundleVersion string ${bundleVersion}" ${plistPath}
$PlistBuddy -c "Add buildIsSuccess string ${buildIsSuccess}" ${plistPath}
$PlistBuddy -c "Add resultMessage string ${resultMessage}" ${plistPath}
$PlistBuddy -c "Add buildNumber string ${buildNumber}" ${plistPath}
$PlistBuddy -c "Add buildJob string ${buildJob}" ${plistPath}
$PlistBuddy -c "Add branchName string ${branchName}" ${plistPath}

}

bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${infoPlistPath}")

bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${infoPlistPath}")

if test ${bundleShortVersion} = "\$(MARKETING_VERSION)" ; then
  bundleShortVersion=$(xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -showBuildSettings | grep MARKETING_VERSION | tr -d 'MARKETING_VERSION =')
fi

if test ${bundleVersion} = "\$(CURRENT_PROJECT_VERSION)" ; then
  bundleVersion=$(xcodebuild -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -showBuildSettings | grep CURRENT_PROJECT_VERSION | tr -d 'CURRENT_PROJECT_VERSION =')
fi

echo ""
echo "start build project: ${projectName}, scheme: ${targetName}, version: ${bundleShortVersion}, build: ${bundleVersion}"
echo ""

#security unlock-keychain -p "${macPassword}" $keychainPath

xcodebuild clean -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -configuration 'Release'  -quiet

echo ""
echo "archive to path ${dirPath}/${targetName}.xcarchive"
echo ""

resultMessage=$(xcodebuild archive -workspace "${projectName}.xcworkspace" -scheme "${targetName}" -configuration 'Release' -archivePath "${archivePath}" -quiet 2>&1)

if [ $? -ne 0 ]
then
    buildIsSuccess="false"
    saveData
    exit -1
fi

echo ""
echo "exportArchive to path ${IPAPATH}"
echo ""

resultMessage=$(xcodebuild -exportArchive -archivePath "${archivePath}.xcarchive" -exportPath "${dirPath}"   -exportOptionsPlist "${exportOptionsPath}" -quiet 2>&1)

if [ $? -ne 0 ]
then
    buildIsSuccess="false"
    saveData
    exit -1
fi


buildIsSuccess="true"
saveData
