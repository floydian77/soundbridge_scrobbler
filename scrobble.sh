
#!/bin/bash

USER=user
PASSWORD=password
SB_LOG=/path/to/scripts/scrobbler/scrobbler.log
SCROBBLE_CLI=/path/to/scripts/scrobbler/scrobble-cli

# scrobble log to last.fm
if [ -f $SB_LOG ]; then
$SCROBBLE_CLI -n -u $USER -p $PASSWORD -l $SB_LOG
SB_LOG_OLD=$SB_LOG`date +%s`
mv $SB_LOG $SB_LOG_OLD
fi
