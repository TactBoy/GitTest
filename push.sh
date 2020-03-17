

build_Job=${buildJob}
build_Number=${buildNumber}

dirName="${build_Job}_#${build_Number}"

dirPath="~/Desktop/${dirName}"
buildParamsPath="${dirPath}/build.plist"

PlistBuddy="/usr/libexec/PlistBuddy"
 
if test -e buildParamsPath; then
projectName=$(${PlistBuddy} -c "Print ${projectName}" ${buildParamsPath})
targetName=$(${PlistBuddy} -c "Print ${targetName}" ${buildParamsPath})
bundleShortVersion=$(${PlistBuddy} -c "Print ${bundleShortVersion}" ${buildParamsPath})
bundleVersion=$(${PlistBuddy} -c "Print ${bundleVersion}" ${buildParamsPath})
buildIsSuccess=$(${PlistBuddy} -c "Print ${buildIsSuccess}" ${buildParamsPath})
resultMessage=$(${PlistBuddy} -c "Print ${resultMessage}" ${buildParamsPath})
branchName=$(${PlistBuddy} -c "Print ${branchName}" ${buildParamsPath})
fi

pushMingdaoMessage(){

checkValue=""

MD_MESSAGE="${dirName} build"
if test buildIsSuccess = "true"; then
MD_MESSAGE="${MD_MESSAGE} success"
checkValue="1"
else
MD_MESSAGE="${MD_MESSAGE} fail"
checkValue=""
fi

MD_MESSAGE=${MD_MESSAGE//\"/\\\"}
MD_MESSAGE=${MD_MESSAGE//\\/\\\\}

resultMessage=${resultMessage//\\/\\\\}
resultMessage=${resultMessage//\"/\\\"}

mdParams="{\"shareId\":\"3d3a101218364178a7ebb65e5f2ae1a6\",\"worksheetId\":\"5e69d42d3d6eba0001aed451\",\"receiveControls\":[{\"controlId\":\"5e69d42d40c94e0001654870\",\"type\":2,\"value\":\"${MD_MESSAGE}\",\"controlName\":\"通知\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c66\",\"type\":16,\"value\":\"\",\"controlName\":\"构建开始时间\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c68\",\"type\":2,\"value\":\"${resultMessage}\",\"controlName\":\"详细报告\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c69\",\"type\":2,\"value\":\"\",\"controlName\":\"构建人\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c6a\",\"type\":2,\"value\":\"${branchName}\",\"controlName\":\"分支\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c6b\",\"type\":2,\"value\":\"${targetName}\",\"controlName\":\"scheme\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c6c\",\"type\":2,\"value\":\"${bundleShortVersion}\",\"controlName\":\"version\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c6d\",\"type\":2,\"value\":\"${bundleVersion}\",\"controlName\":\"build\",\"dot\":0},{\"controlId\":\"5e69d4c47b2b070001ef3c67\",\"type\":16,\"value\":\"\",\"controlName\":\"构建完成时间\",\"dot\":0},{\"controlId\":\"5e69d5bd20c25a00010d36b0\",\"type\":36,\"value\":\"${checkValue}\",\"controlName\":\"构建成功\",\"dot\":0}]}";
    
    echo $mdParams

    curl 'https://www.mingdao.com/api/PublicWorksheet/AddRow' -H 'authority: www.mingdao.com' -H 'content-type: application/json' -H 'accept: application/json, text/javascript, */*; q=0.01' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36' -H 'accept-language: zh-CN,zh;q=0.9' --data-binary "${mdParams}" --compressed
}

pushMingdaoMessage


