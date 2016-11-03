# installation-scripts

<b>During the development process all paths point into the folder ~/tmp</b>

## How to use

### Configure file
<!-- add ... and write ... -->
First of all review the file [default.cfg](default.cfg)
```
INSTALL_EI="yes"
#if you install easyinterface => absfrontend is required!!
INSTALL_TOOLS=( "absfrontend" "saco" "apet" )

EI_PATH="ei"
EXAMPLES_PATH="benchmarks"
```
It has few variables defined:
<ul>
<li> <b>INSTALL_EI</b> : "yes" or "no". Select if you want to install easyinterface. </li>
<li> <b>INSTALL_TOOLS</b> : a bash array with the name of each tool that you want to install.</li>
<li> <b>BASE_PATH</b> : full path.</li>
<li> <b>EI_PATH</b> : where do you want to install easyinterface (In the Future this variable will be moved to easyinterface/config). </li>
<li> <b>EXAMPLES_PATH</b> : where do you want to download the examples (In the Future this variable will be moved to easyinterface/config). </li>
</ul>

If you want to edit some variable you can copy this file into another (e.g myconf.cfg)
#### Configure each tool

By default each tool uses non-local installation, it means, the scripts downloads the tool from some where (e.g. https://costa.ls.fi.upm.es/download )

LOCAL installation only configure the easyinterface files...

Set the variable:
TOOL_PATH : if you want to install in other place...

### Install
<!-- Several methods -->

#### Bash Script
The easiest way is: run the script
<!-- run `./install.sh` -->
```bash
# it will use the default.cfg config file
./install.sh
```
or 

```bash
# to use your own config file
./install.sh myconf.cfg
```

#### Docker
TO-DO
<!-- run `sudo docker` -->
```bash
sudo docker
```


#### Makefile
TO-DO
<!-- run `make` -->
```bash
make
```

## How to add new tool
<!-- create folder and the install script -->
<!-- add reference in config -->

Create a new folder and their corresponding files:
- config 
or 
- install.sh

and ?
if you want to support easyinterface you must add
- ei/app (with the line &ltapp id="your id" src="path-to/file.cfg" /&gt)
- ei/common_settings.sh (see [saco/ei/common_settings.sh](saco/ei/common_settings.sh) )
- ei/config/path-to/file.cfg (same path-to as ei/app)
- ei/bin/....  (with the sh that launch your tool. Place the script at the same path that your config file says..)

The best way is to explore [saco](saco) to see how easy is...
