#! /bin/bash

#-------------------------------------------------------
CFG=./default.cfg
TMPEI="/tmp/install-ei"
#TO-DO: change path to a Variable
EIPATH="/home/friker/tmp/Systems/easyinterface"


install_easyinterface ()
{
    echo "Installing EasyInterface..."


    echo "Moving config files..."
    cp ./easyinterface/eiserver.cfg $TMPEI/config/eiserver.cfg
    cp -RT $TMPEI/ $EIPATH/server/
    echo "Done!"
}

install_tool ()
{
    if [ $1 ] ; then
	tool=$1
    else
	return -1
    fi
    if [ -e $tool/install.sh ]; then
	# if own script exists then execute it
	chmod +x $tool/install.sh
	$tool/install.sh || return -1
	chmod -x $tool/install.sh
    elif [ -e $tool/config ] ; then
	# if config file appear just get the variables and install
	chmod +x $tool/config
	. $tool/config || return -1
	chmod -x $tool/config
	#TO-DO: use variables of config to install
    else
	return -1
    fi
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
if [ $INSTALL_EI == "yes" ] ; then
    echo "Init EasyInterface files..."
    rm -rf $TMPEI
    mkdir $TMPEI
    mkdir $TMPEI/config
    mkdir $TMPEI/bin
    echo "<apps>" > $TMPEI/config/apps.cfg
    echo "<examples>" > $TMPEI/config/examples.cfg
fi
#----------------------------------------------------
# INSTALL APPS
#----------------------------------------------------

for tool in ${INSTALL_TOOLS[@]} ; do
    install_tool $tool
    if [ $? != 0 ]; then 
	echo "Impossible to install "$tool
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


