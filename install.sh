#! /bin/bash
rm -rf ~/tmp/
#-------------------------------------------------------
CFG=./default.cfg
TMP="/tmp/installer"
TMPEI=$TMP"/ei"

install_easyinterface ()
{
    echo "Installing EasyInterface..."


    echo "Moving config files..."
    cp ./easyinterface/eiserver.cfg $TMPEI/config/eiserver.cfg || return -1
    cp -RT $TMPEI/ $EIPATH/server/ || return -1
    return 0
}

config_install ()
{

    if [ $TOOL_LOCAL == "yes" ] ; then
	echo "TO-DO: local installation"
	return -1
    else
	mkdir -p $TMP/$tool || return -1
	wget $TOOL_REMOTE -P $TMP/$tool/ || return -1
	if [ "${TOOL_REMOTE##*.}" == "zip"] ; then 
	    unzip $TMP/$tool/*.zip  $TMP/$tool/|| return -1
	    rm -f $TMP/$tool/*.zip || return -1
	fi
	mkdir -p $TOOL_STATIC_PATH || return -1
	cp -R $TMP/$tool/* $TOOL_STATIC_PATH/ || return -1
    fi
    return 0
}

install_tool ()
{
    if [ $1 ] ; then
	tool=$1
    else
	return -1
    fi
    if [ -e $tool/install.sh ]; then
	# if an script exists then execute it
	chmod +x $tool/install.sh
	$tool/install.sh || return -1
	chmod -x $tool/install.sh
    elif [ -e $tool/config ] ; then
	# if config file appear just get the variables and install
	chmod +x $tool/config
	. $tool/config || return -1
	chmod -x $tool/config
	#TO-DO: use variables of config to install
	config_install || return -1
    else
	return -1
    fi
    return 0
}
#-------------------------------------------------------

#TO-DO: allow --help -h parameters to show help

#TO-DO: change $1 to --config=path or something like that
if [ -n "$1" ] ; then
  cfg=$1
else  
  cfg=$CFG
fi

if [ -e $cfg ] ; then
    echo "Loading "$cfg" config file..."
    chmod +x $cfg
    . $cfg || exit -1 
    chmod -x $cfg
else
    echo "Error: Config file ("$cfg") NOT found" >&2
    exit -1
fi

#----------------------------------------------------
mkdir -p $TMP
if [ $INSTALL_EI == "yes" ] ; then
    echo "Init EasyInterface files..."
    rm -rf $TMPEI

    mkdir -p $TMPEI
    mkdir $TMPEI/config
    mkdir $TMPEI/bin
    mkdir -p $EIPATH
    echo "<apps>" > $TMPEI/config/apps.cfg
    echo "<examples>" > $TMPEI/config/examples.cfg
fi
#----------------------------------------------------
# INSTALL APPS
#----------------------------------------------------

for tool in ${INSTALL_TOOLS[@]} ; do
    install_tool $tool
    if [ $? != 0 ]; then
	echo "Error: Impossible to install "$tool >&2
	continue
    fi

    if [[ $INSTALL_EI == "yes" && -e $tool/ei/ ]] ; then
	echo "This tool ("$tool") supports EasyInterface"
	cat $tool/ei/app >> $TMPEI/config/apps.cfg
	cp $tool/ei/*.cfg >> $TMPEI/config
    fi
done



#----------------------------------------------------
if [ $INSTALL_EI == "yes" ] ; then
    echo "</apps>" >> $TMPEI/config/apps.cfg
    echo "</examples>" >> $TMPEI/config/examples.cfg
    install_easyinterface
fi


echo "END"


