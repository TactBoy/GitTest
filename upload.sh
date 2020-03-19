#!/bin/bash -x

build_Job=${sourceBuildJob}
build_Number=${sourceBuildNumber}

PlistBuddy="/usr/libexec/PlistBuddy"

dirName="${build_Job}_#${build_Number}"

dirPath="${HOME}/Desktop/${dirName}"
buildParamsPath="${dirPath}/build.plist"

targetName=$(${PlistBuddy} -c "Print targetName" ${buildParamsPath})

buildIsSuccess="true"

IPAPATH="${dirPath}/${targetName}.ipa"

ITC_USER="gavin.sun@mingdao.com"
ITC_PASSWORD="Ssh.0411"

altool="/Applications/ApplicationLoader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"

echo ""
echo "validate archive"
echo ""

saveData() {
cd $dirPath
plistPath="upload.plist"
cp $buildParamsPath $plistPath
$PlistBuddy -c "Set buildIsSuccess ${buildIsSuccess}" ${plistPath}
$PlistBuddy -c "Set resultMessage ${resultMessage}" ${plistPath}

}

resultMessage=$(${altool} -v -f "${IPAPATH}" -u $ITC_USER -p $ITC_PASSWORD 2>&1)

if [ $? -ne 0 ]
then
    buildIsSuccess="false"
    saveData
    exit -1
fi

echo ""
echo "upload archive"
echo ""

resultMessage=$(${altool} --upload-app -f "${IPAPATH}" -u $ITC_USER -p $ITC_PASSWORD 2>&1)

if [ $? -ne 0 ]
then
    buildIsSuccess="false"
    saveData
    exit -1
fi

buildIsSuccess="true"
saveData


