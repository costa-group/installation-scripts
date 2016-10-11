#!/bin/bash
TOOL_PATH=$1
echo -e "\n\
# Path to saco --- where you've extracted   \n\
# \n\
#   http://costa.ls.fi.upm.es/download/saco.colab.zip \n\
# \n"
#/Systems/costa/costabs/dist/saco

echo -e "EC_SACOHOME=$TOOL_PATH \n\
export SACOHOME=\${EC_SACOHOME} \n\
export COSTABSHOME=\${SACOHOME} \n\
export PATH=\${PATH}:\${SACOHOME}/bin "
