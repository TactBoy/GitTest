
projectName="Mingdao"
targetName="Mingdao"
bundleShortVersion="1.2"
bundleVersion="12012"
buildIsSuccess="false"
resultMessage="Error"
buildNumber=""
buildJob=""

dirName="${HOME}/Desktop/buildParams.plist"
cp GitTest2.plist $dirName

#
#buildMessage="projectName=${projectName}\ntargetName=${targetName}\nbundleShortVersion=${bundleShortVersion}\nbundleVersion=${bundleVersion}\nbuildIsSuccess=${buildIsSuccess}\nresultMessage=${resultMessage}\nbuildNumber=${buildNumber}\nbuildJob=${buildJob}\n"
#
#echo $buildMessage >> $dirName

#touch buildParams.plistp

ITC_USER="gavin.sun@mingdao.com"
ITC_PASSWORD="Ssh.0411"

altool="/Applications/ApplicationLoader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"

echo ""
echo "validate archive"
echo ""

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

