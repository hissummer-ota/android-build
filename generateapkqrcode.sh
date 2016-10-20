#!/bin/bash

archiveDir=${WORKSPACE}/../builds/${BUILD_NUMBER}/archive
outputhtml=qrcode.html
datestamp=$(date +"%Y-%m-%d_%T")
#list all the apk builded



#generate the apk qrcode html which will be emebeded in the build page
# add some annotation and js code snippet
cat >> ${archiveDir}/${outputhtml} <<MYEOF
<script>
function bright(a)
{
a.style.border ="1px solid blue";
}

function dark(a)
{
a.style.border ="0px";
}
</script>
<!-- apk list  &  qrcode image  -->
<!-- here will embeded the dynamic content files , which is generated at build step. -->

MYEOF


#echo "=============env in genearte.sh==========="
#env

#apksname=$(find ../builds/55/  -iname "*.apk"|sed 's#.*apk/##') // this will not work!! not a array after sed returned 
apkswithpath=$(find ./  -iname "*.apk" | grep -v "unaligned")

#generate qrcode pic for each apk

i=0
for apk in $apkswithpath; do
    echo $apk  
    #apkname=$(echo $apk | sed 's#.*apk/##')
    renamename=$(echo $apk | sed "s#\.apk#_${datestamp}.apk#")
    apkname=$(echo $renamename | sed 's#.*apk/##')
    mv $apk $renamename
    echo $renamename
    echo $apkname
    #need update the qrencode arguments
    mkdir -p ${archiveDir}/qrcodes
    echo /usr/local/bin/qrencode -s 8 -l M -v 3 -o ${archiveDir}/heika/build/outputs/apk/${apkname}.png  "${BUILD_URL}artifact/heika/build/outputs/apk/${apkname}"
    /usr/local/bin/qrencode -s 8 -l M -v 3  -o ${archiveDir}/heika/build/outputs/apk/${apkname}.png  "${BUILD_URL}artifact/heika/build/outputs/apk/${apkname}"
    echo ${BUILD_URL}artifact/heika/build/outputs/apk/${apkname}
    /usr/bin/composite -gravity center ${WORKSPACE}/../shell/logo.png ${archiveDir}/heika/build/outputs/apk/${apkname}.png ${archiveDir}/heika/build/outputs/apk/${apkname}.png
    #output the html ,will publish after build.
cat >> ${archiveDir}/${outputhtml} <<EOF
<div style="display:inline-block;" onmouseover="bright(this);" onmouseout="dark(this);">
<span style="margin:10px;font-size:1.3em;background-color:rgba(255,255,255,0.5);font-weight:bold;font-color:blue;"> ${apkname} </span>
<br/>
<img src="${BUILD_URL}artifact/heika/build/outputs/apk/${apkname}.png"></img>
</div>
<br/>

EOF
    let i=i+1
done



#generate the apk qrcode html which will be emebeded in the build page


# output for rich text message pblushier . (thru the env var inject)
output=$(cat ${archiveDir}/${outputhtml} | tr '\n' ' ')

echo ceshiceshi=$output > ${WORKSPACE}/../shell/test.properties
