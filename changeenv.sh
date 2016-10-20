#!/bin/bash
#Author: lihao01@renrendai.com
#this shell script is used to change android heika/build.gradle env defination


#############history##################
#2016-06-28
# sync configuration with dev's

#2016-05-30
# modify env configuration 

#2016-05-26
# change all huanxinid to -100 (based email of zhangmin)

#2016-05-16
#1. add imKey vars

#2016-05-12
#1. change 38 env 's  o2o address

#2016-04-20
#1. change def var names. ( As android dev changed the build.gradle )

#2016-04-05
#1.build.gradle 改动后所以这里进行修改
#2.buildType local var in heika/build.gradle is not used anymore

######################################


#get this shell location
location="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#echo "location:"$location

#define the array , used to delete these lines in orig configuration
replace_string=(
"buildType"
"hostHeika"
"hostO2O"
"secretaryImId"
"imAppKey"
"imObtainSocketAddressUrl"
"imFileServerUrl"
)

#define the 38 configuration
function def38()
{
echo $1
preparegradle
cat >> ${location}/build.gradle.new << ending
def buildType = "38";
def hostHeika = "\"http://172.16.2.38\"";
//如果使用https需要修改 restClient中的证书
def hostO2O = "\"http://172.16.1.4/api\"";
//如果使用https需要修改 restClient中的证书
def secretaryImId = "-100";
def imAppKey  = "\"heika\"";
def imObtainSocketAddressUrl = "\"http://172.16.2.122:8080/address/socketAddress\"";
def imFileServerUrl = "\"http://172.16.2.39\"";
ending
readygradle
}

#define the 113 configuration
function def113()
{
echo $1
preparegradle
cat >> ${location}/build.gradle.new << ending
def buildType = "113";
def hostHeika = "\"http://172.16.2.113\"";
//如果使用https需要修改 restClient中的证书
def hostO2O = "\"http://172.16.1.48/api\"";
//如果使用https需要修改 restClient中的证书 //44
def secretaryImId = "-100";
def imAppKey  = "\"heika\"";
def imObtainSocketAddressUrl = "\"http://172.16.2.124:8080/address/socketAddress\"";
def imFileServerUrl = "\"http://172.16.2.39\"";
ending
readygradle
}
#define the ucloud configuration
function defucloud()
{
echo $1
preparegradle
cat >> ${location}/build.gradle.new << ending
def buildType = "ucloud";
def hostHeika = "\"http://123.59.70.2\"";
//如果使用https需要修改 restClient中的证书
def hostO2O = "\"https://123.59.69.254:443/api\"";
//如果使用https需要修改 restClient中的证书
def secretaryImId = "-100";
def imAppKey  = "\"heika\"";
def imObtainSocketAddressUrl = "\"http://172.16.2.122:8080/address/socketAddress\"";
def imFileServerUrl = "\"http://172.16.2.39\"";
ending
readygradle
}
#define the backup server configuration
function defbackup()
{
echo $1
preparegradle
cat >> ${location}/build.gradle.new << ending
def buildType = "backup";
def hostHeika= "\"http://116.213.205.149:80\"";
//如果使用https需要修改 restClient中的证书
def hostO2O= "\"http://116.213.205.154/api\"";;
//如果使用https需要修改 restClient中的证书  /api/
def secretaryImId = "-100";
def imAppKey  = "\"heika\"";
def imObtainSocketAddressUrl = "\"http://iplist.heika.com/address/socketAddress\"";
def imFileServerUrl = "\"http://fs.heika.com\"";
ending
readygradle
}
#define the release server configuration
function defrelease()
{
echo $1
preparegradle
cat >> ${location}/build.gradle.new << ending
def buildType = "release";
def hostHeika= "\"https://api.m.heika.com\"";
//如果使用https需要修改 restClient中的证书
def hostO2O= "\"https://zs.heika.com/api\"";
//如果使用https需要修改 restClient中的证书  /api/
def secretaryImId = "-100";
def imAppKey  = "\"heika\"";
def imObtainSocketAddressUrl = "\"http://iplist.heika.com/address/socketAddress\"";
def imFileServerUrl = "\"http://fs.heika.com\"";
ending
readygradle
}

function defsecretary()
{
echo $1
preparegradle
cat >> ${location}/build.gradle.new << ending
def buildType = "secretary-train";
def hostHeika= "\"http://172.16.2.131\"";    
//如果使用https需要修改 restClient中的证书
def hostO2O= "\"http://172.16.1.47/api\"";     
//如果使用https需要修改 restClient中的证书
def secretaryImId = "-100";
def imAppKey  = "\"heika\"";
def imObtainSocketAddressUrl = "\"http://172.16.2.132:9728/address/socketAddress\"";
def imFileServerUrl = "\"http://172.16.2.39\"";
ending
readygradle
}



#delete the original configuration in build.
#10 lines based on original build.gradle. 
function preparegradle()
{
#echo $location
cp -f ../workspace/heika/build.gradle ${location}/  #cp a new build.gradle to modify
cp -f ../workspace/heika/build.gradle ${location}/build.gradle.backup #backup
len=${#replace_string[@]}
for ((i=0;i<len;i++))
do
#       echo def ${replace_string[i]}
#       echo def ${replace_string[i]}=${def113[i]}
        #sed -i -c "s/^def ${replace_string}[i].*//" ../workspace/heika/build.gradle
        #sed -i -c 's/^def ${replace_string[i]}.*/def ${replace_string[i]}=${def113[i]}/' ${location}/build.gradle
        sed -i -c "s/.*def ${replace_string[i]}.*$//" ${location}/build.gradle
done
head -n 10 ${location}/build.gradle > ${location}/build.gradle.new
#grep -v "^\s*$" ${location}/build.gradle.new > ${location}/build.gradle.new
#insert the def
#override the original build.gradle
}

#
function readygradle()
{
tail -n +10 ${location}/build.gradle >> ${location}/build.gradle.new
#echo ""
}

env=$1
if [ a$env == a'' ] ; then
        echo "arguments error!"
        exit 1
fi
case "${env}" in
        38)
                def38
            ;;
        113)
                def113
            ;;
        ucloud)
                defucloud
            ;;
        backup)
                defbackup
            ;;
        release)
                defrelease
            ;;
        train)
                defsecretary
            ;;
        *)
            echo "arguments error!"
            exit 1
esac

