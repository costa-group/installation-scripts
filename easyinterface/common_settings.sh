
# We rely on the fact that the PHP server calls the applications
# starting in the directory bin, i.e., it first changes directory to
# server/bin and then executes the app. 

# # COFLOCO
# export COFLOCOHOME=${EC_COFLOCOHOME}

# # SMART DEPLOYER
# export SMARTDEPLOYERHOME=${EC_SMARTDEPLOYERHOME}

# # MAIN GENERATOR
# export MAINGENHOME=${EC_MAINGENHOME}


# # HABS
# export HABSHOME=${EC_HABSHOME}


# # add the  absfrontend.jar to the CLASSPATH
# export CLASSPATH=$ABSFRONTEND:${CLASSPATH}

# # PATHs
# if [ -n "${EC_PATH:+x}" ]; then
#     export PATH=${PATH}:${EC_PATH}
# fi

# # LD_LIBRARY_PATHs
# if [ -n "${EC_LD_LIBRARY_PATH:+x}" ]; then
#     export LD_LIBRARY_PATH=${EC_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}
# fi

