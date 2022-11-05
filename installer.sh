#!/bin/bash
########## INFO ##########
# RECOMENDED start command:
# ./installer.sh java -Xmx%maxram%M -Xms%minram%M -jar %binary% -h %ip% -p %port% -s %slots% --log-append false --log-limit 50000
# ???????
# ./installer.sh -Xmx4096M -Xms512M -h 5.9.55.61 -p 25565 -s 12 --log-append false --log-limit 50000
# java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.18.2-40.1.80/unix_args.txt "$@"


# TODO: parse args "java -Xmx%maxram%M -Xms%minram%M -jar %binary% -h %ip% -p %port% -s %slots% --log-append false --log-limit 50000"
# str="$*"
# INIT CONFIG read cfg and set versions to var
{ read line1 ; read line2 ; read line3 ; read line4 ;} <installer.cfg
v_minecraft="${line1#* }"
v_forge="${line2#* }"
modpack_url="${line3#* }"
installed="${line4#* }"
# remove quote (") from variable
v_minecraft=${v_minecraft%\"}
v_forge=${v_forge%\"}
v_minecraft=${v_minecraft#\"}
v_forge=${v_forge#\"}
installed=${installed%\"}
installed=${installed#\"}
modpack_url=${modpack_url%\"}
modpack_url="${modpack_url:2}"








starter () {
	echo [INFO] Starting Forge Server ${v_minecraft}-${v_forge}
	# echo [DEBUG] Start args: $str
	java @user_jvm_args.txt @libraries/net/minecraftforge/forge/${v_minecraft}-${v_forge}/unix_args.txt "$@"

}

installer () {
# test for old instalation and delete it
rm -rf .mixin.out 2> /dev/null
rm -rf crash-reports 2> /dev/null
rm -rf local 2> /dev/null
rm -rf world 2> /dev/null
rm -rf patchouli_books 2> /dev/null
rm -rf mods 2> /dev/null
rm -rf logs 2> /dev/null
rm -rf libraries 2> /dev/null
rm -rf kubejs 2> /dev/null
rm -rf defaultconfigs 2> /dev/null
rm -rf config 2> /dev/null
rm startserver.sh 2> /dev/null
rm startserver.bat 2> /dev/null
rm rhino.local.properties 2> /dev/null



###### DOWNLOAD AND INSTALL ########
echo "##########################################"
echo [INFO] Minecraft: $v_minecraft
echo [INFO] Forge: $v_forge
# echo [DEBUG] $PWD #show current location
echo "##########################################"

# download selected forge version
forge_url=https://maven.minecraftforge.net/net/minecraftforge/forge/${v_minecraft}-${v_forge}/forge-${v_minecraft}-${v_forge}-installer.jar

# validate URL exists


# download if exists else error
if validate_url $forge_url; then
    # Do something when exists
	echo [INFO] Downloading Forge ...
	wget -O $PWD/forge.jar $forge_url -q
  else
    # Return or print some error
	echo [ERROR] Forge File does not exist in web.
	echo [ERROR URL] $forge_url
	exit
fi

# installing forge
echo [INFO] Installing Forge Server...
java -jar forge.jar --installServer &>/dev/null
rm run.sh 2> /dev/null
rm run.bat 2> /dev/null
rm forge.jar.log 2> /dev/null
rm forge.jar 2> /dev/null


# downloading modpack from URL
if [ ! -z "${modpack_url}" ]; then
	if validate_url $modpack_url; then
		# Do something when exists
		echo [INFO] Downloading Mod Pack ...
		wget -O $PWD/modpack.zip $modpack_url -q
		# unzip modpack
		echo [INFO] Installing Mod Pack ...
		unzip -o -q modpack.zip
		rm modpack.zip 2> /dev/null
	else
		# Return or print some error
		echo [ERROR] Mod Pack File does not exist in web.
		echo [ERROR] Check Mod Pack URL in installer.cfg 
		echo [ERROR URL] $modpack_url
		exit
	fi
else
	echo [INFO] No mod pack installed.
fi







# writing to installer.cfg line3 value 1
echo [INFO] Set installed flag in installer.cfg
sed -i '4s/.*/already_installed "1"/' installer.cfg
echo [INFO] If you wish to install a fresh version set already_installed 0 to 1 in installer.cfg
echo [INFO] DONE

}




# TODO: is already installed ? -> run
# not installed ? -> is config file valid? -> install

function validate_url(){
  if [[ `wget -S --spider $1  2>&1 | grep 'HTTP/1.1 200 OK'` ]]; then
    return 0
  else
    return 1
  fi
}



if [ $installed = 0 ]; then
	# do stuff if not installed
	installer
fi

if [ $installed = 1 ]; then
	# do stuff if allready installed
    echo "[DEBUG] Already installed, starting ...";
	starter
    
fi