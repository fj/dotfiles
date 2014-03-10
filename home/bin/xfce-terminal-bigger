#!/bin/bash
SIZE=`grep 'FontName' ~/.config/xfce4/terminal/terminalrc | cut -d' ' -f 2`
NEWSIZE=$((SIZE + 2))
REGEXPR='s/FontName.*/FontName=Monospace '$NEWSIZE'/g'
sed -i "$REGEXPR" ~/.config/xfce4/terminal/terminalrc
