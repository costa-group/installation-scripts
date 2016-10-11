#!/bin/bash

### A wrapper script for SYCO (systematic testing tool for concurrent objects)
###
###

# execute environment_settings.sh to set some environment variables
# needed by costabs, etc.
#

. misc/common_settings.sh

# decide which executable to use
#
if [[ -e ${SYCOHOME}/bin/syco ]] ; then
    PROGRAM=${SYCOHOME}/bin/syco
else
    PROGRAM=${SYCOHOME}/src/interfaces/shell/syco
fi

# Execute syco
#
${PROGRAM} $@ &> /tmp/syco.stderr

# If costabs exit with exit-code 0 we just print the output to the
# stdout, otherwise we print an error message to the stdout as well.
#
R=$?
if [ $R == 0 ]; then
    cat /tmp/pet/output.xml    
else
    
    echo "<eiout>"
    echo "<eicommands>"
    echo "<printonconsole consoleid='Error'>"
    echo "<content format='text'>"
    cat /tmp/syco.stderr
    echo "</content>"
    echo "</printonconsole>"
    echo "<dialogbox boxtitle='Execution Error' boxwidth='400'>"
    echo "<content format='html'>"
    echo "<span style='color:red;' >syco exit with non-zero exit code: $R</span>"
    echo "</content>"
    echo "</dialogbox>"
    echo "</eicommands>"
    echo "</eiout>"
fi

#\rm -f /tmp/syco.stderr
