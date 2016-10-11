#!/bin/bash
TOOL_PATH=$1
echo -e "\n\
# Path to apet and syco -- where you've extracted   \n\
# \n\
#   http://costa.ls.fi.upm.es/download/apet.colab.zip  \n\
# \n"

echo -e "EC_APETHOME=$TOOL_PATH"
echo -e "EC_SYCOHOME=$TOOL_PATH"
echo -e " \n\
# APET \n\
export APETHOME=\${EC_APETHOME} \n\
\n\
#SYCO \n\
export SYCOHOME=\${EC_SYCOHOME} "
