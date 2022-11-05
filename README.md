# MCForgeServerInstallScript


script that installs forge server + mod pack 
on second execution it will attempt to start the server, but yet with no or wrong start args. bc not implemented jet ...

How to use:
1. set your needed mc and forge version in installer.cfg
2. optional: set url to download mod pack, leave empty if not needed.

set already_installed to "0" to install again. (all files will get deleted / overwritten, hopefully ...)

the downloaded files will be saved in the same folder as installer.sh
make sure to place and execute installer.sh in the folder where you want your server to be.

TODO:
implement startup args
example: installer.sh -xmx4096m -xms512m
