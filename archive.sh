#!/bin/bash -x
projectName="GitTest"

#从jenkins读取
targetName=${target}

#如果是连续构建,读取上一次的构建信息
build_Job=${buildJob}
build_Number=${buildNumber}

PlistBuddy="/usr/libexec/PlistBuddy"

#上次构建的文件地址
dirName="${build_Job}_#${build_Number}"
dirPath="${HOME}/Desktop/${dirName}"

#上次构建相关信息
buildParamsPath="${dirPath}/build.plist"

if test -e $buildParamsPath
then
#读取上次构建的target
lastTargetName=$(${PlistBuddy} -c "Print targetName" ${buildParamsPath})
fi

#根据上次的target决定本次的target
if test -n $lastTargetName
then

if test $lastTargetName = GitTest; then
targetName="GitTest2"
elif test $lastTargetName = GitTest2; then
targetName="GitTest3"
elif test $lastTargetName = GitTest3; then
targetName=""
echo "abort current mingdao session"
exit 0
else
targetName="GitTest"
fi

fi

#设置缺省target
if test -z $targetName; then {
    targetName="GitTest"
}
fi

#最终的命令执行结果
resultMessage=""

#代码签名使用自动签名
codeSign="iPhone Developer"

#本次构建的Jenkins任务名称和序号
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

#构建分支名称
branchName=${GIT_BRANCH}

#本次构建文件地址
dirName="${buildJob}_#${buildNumber}"

dirPath="${HOME}/Desktop/${dirName}"

archivePath="${dirPath}/${targetName}"

infoPlistPath="./${targetName}/Info.plist"

exportOptionsPath="./ExportOptions.plist"

bundleShortVersion=""
bundleVersion=""

buildIsSuccess="true"

IPAPATH="${dirPath}/${targetName}.ipa"


if test ${targetName} = "GitTest"; then

infoPlistPath="./${targetName}/Info.plist"

elif test ${targetName} = "GitTest2"; then

infoPlistPath="./GitTest2.plist"

elif test ${targetName} = "GitTest3"; then

infoPlistPath="./GitTest3.plist"

fi

#保存本次构建信息供下游项目使用
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
