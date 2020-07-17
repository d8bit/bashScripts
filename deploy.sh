#!/bin/bash

LDIR="/var/www/html/projectname"     #Your local directory
RDIR="/public_html/projectname.com"               #FTP server directory

lftp -f "
set ftp:ssl-allow no
open $BROKER_FTP
user $BROKER_FTP_USER $BROKER_FTP_PASS
mirror --continue --reverse --delete --verbose $LDIR/frontend/public $RDIR/frontend/public --exclude uploads/ --exclude images/ --exclude vendor/ --exclude .htaccess --exclude robots.txt
mirror --continue --reverse --delete --verbose $LDIR/frontend/app $RDIR/frontend/app
mirror --continue --reverse --delete --verbose $LDIR/frontend/config $RDIR/frontend/config
mirror --continue --reverse --delete --verbose $LDIR/frontend/resources $RDIR/frontend/resources
mirror --continue --reverse --delete --verbose $LDIR/backend/app $RDIR/backend/app
bye
"

