#!/bin/bash
TOOL_PATH=$1
echo -e "\n\
# Path to abs tools --- where you have checkedout \n\
# \n\
#   https://github.com/abstools/abstools \n\
# \n"
echo -e "EC_ABSFRONTENDHOME=$TOOL_PATH" #"/home/genaim/Systems/abstools"

echo -e "\n\
# ABSTOOLS \n\
export ABSFRONTEND=\${EC_ABSFRONTENDHOME}/absfrontend.jar \n\
# add the  absfrontend.jar to the CLASSPATH \n\
export CLASSPATH=\$ABSFRONTEND:\${CLASSPATH} "
