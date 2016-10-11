#! /bin/bash
rm -rf ~/tmp/
rm -rf /tmp/installer
#-------------------------------------------------------
CFG=./default.cfg
TMP="/tmp/installer"
TMPEI=$TMP"/ei"

install_easyinterface ()
{
    echo "Installing EasyInterface..."
    echo "   Cloning repositories..."
    git clone https://github.com/costa-group/benchmarks.git $EXAMPLES_PATH >& /dev/null \
	&& chmod -R 755 $EXAMPLES_PATH \
	&& git clone https://github.com/abstools/easyinterface.git $EI_PATH >& /dev/null \
	&& chmod -R 755 $EI_PATH \
	&& echo -e "Alias /eiauto \"$EI_PATH\"\n\
\n\
<Directory \"$EI_PATH\">\n\
   Options FollowSymlinks MultiViews Indexes IncludesNoExec\n\
   AllowOverride All\n\
   Require all granted\n\
</Directory>\n\
\n\
Alias /examples \"$EXAMPLES_PATH\"\n\
\n\
<Directory \"$EXAMPLES_PATH\">\n\
   Options FollowSymlinks MultiViews Indexes IncludesNoExec\n\
   AllowOverride All\n\
   Require all granted\n\
</Directory>\n" > $TMP/easyinterface-site.conf || return -1

    echo "   Moving config files..."
    echo -e " <exset id=\"setGithub\">\n\
  <github name=\"github\" owner=\"costa-group\" repo=\"benchmarks\" branch=\"master\" path=\"abs\"/> \n\
 </exset>" >> $TMPEI/config/examples.cfg
    echo "</apps>" >> $TMPEI/config/apps.cfg
    echo "</examples>" >> $TMPEI/config/examples.cfg

    cp ./easyinterface/eiserver.cfg $TMPEI/config/eiserver.cfg || return -1
    cp -RT $TMPEI/ $EI_PATH/server/ || return -1
    chmod +x -R $EI_PATH/server/bin/*
    return 0
}

config_install ()
{
    if [ $TOOL_LOCAL == "yes" ] ; then
	echo "TO-DO: local installation"
	return -1
    else
	mkdir -p $TMP/$tool || return -1
	wget $TOOL_REMOTE -P $TMP/$tool/  >& /dev/null || return -1
	if [ "${TOOL_REMOTE##*.}" == "zip" ] ; then
	    unzip $TMP/$tool/*.zip -d $TMP/ >& /dev/null|| return -1
	    rm -f $TMP/$tool/*.zip || return -1
	fi
	mkdir -p $TOOL_PATH || return -1
	cp -R $TMP/$tool/* $TOOL_PATH || return -1
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

    if [ -e $tool/config ] ; then
	# if config file appear just get the variables and install
	chmod +x $tool/config
	. $tool/config || return -1
	chmod -x $tool/config
    fi
    echo "Installing "$tool"..."
    if [ -e $tool/install.sh ]; then
	# if an script exists then execute it
	chmod +x $tool/install.sh
	$tool/install.sh || return -1
	chmod -x $tool/install.sh
    elif [ -e $tool/config ] ; then
	config_install || return -1
    else
	return -1
    fi
    if [[ $INSTALL_EI == "yes" && -e $tool/ei/ ]] ; then
	echo "  The tool $tool supports EasyInterface"
	cat $tool/ei/app >> $TMPEI/config/apps.cfg
	$tool/ei/common_config.sh $TOOL_PATH >> $TMPEI/bin/misc/common_settings.sh
	cp -R $tool/ei/config/*  $TMPEI/config/
	cp -R $tool/ei/bin/*     $TMPEI/bin/
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
    rm -rf $TMPEI
    mkdir -p $TMPEI
    mkdir $TMPEI/config
    mkdir $TMPEI/bin
    mkdir $TMPEI/bin/misc
    mkdir -p $EI_PATH
    cat ./easyinterface/common_settings.sh > $TMPEI/bin/misc/common_settings.sh
    chmod +x $TMPEI/bin/misc/common_settings.sh
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


done



#----------------------------------------------------
# INSTALL EasyInterface
#----------------------------------------------------

if [ $INSTALL_EI == "yes" ] ; then
    install_easyinterface
    echo -e "Please configure: \n\
   $EI_PATH/server/bin/common_settings.sh "
    echo -e "Please Execute: \n\
   sudo mv $TMP/easyinterface-site.conf /etc/apache2/sites-available/easyinterface-site.conf && sudo a2ensite easyinterface-site && sudo service apache2 reload "
fi


