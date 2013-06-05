#!/bin/sh
# $1 = union directory
#mv $1/usr/bin/xterm $1/usr/bin/xterm.bin
#echo -ne "#!/bin/bash\nexec xterm.bin -fg white -bg black \"\$@\"" > $1/usr/bin/xterm
#chmod a+x $1/usr/bin/xterm
rm $1/usr/share/applications/*
