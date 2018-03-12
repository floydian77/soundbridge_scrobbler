
#!/bin/bash
#logger.sh
#What is playing on the soundbridge

SB_HOST=10.10.0.10
SB_PORT=5555
SB_PATH=/path/to/scripts/scrobbler/

SB_LOG=$SB_PATHscrobbler.log
SB_OUT=$SB_PATHsb.out
SB_TIME=$SB_PATHsb.time

# Create log if not exist
if [ -f $SB_LOG ]; then
echo log exist nothing to do
else
echo #AUDIOSCROBBLER/1.0 > $SB_LOG
echo #TZ/UTC+2 >> $SB_LOG
echo #CLIENT/Soundbridge logger 0.1 >> $SB_LOG
fi

function seconds {
TIME=`echo $1 | tr -d '\r'`
SEC=`echo $TIME | sed -e 's/^[0-9]:[0-9][0-9]://'`
TIME=`echo $TIME | sed -e 's/:[0-9][0-9]$//'`
MIN=`echo $TIME | sed -e 's/^[0-9]://'`
HOUR=`echo $TIME | sed -e 's/:[0-9][0-9]$//'`

let HOUR=HOUR*60
let MIN=HOUR+MIN
let MIN=MIN*60
let SEC=MIN+SEC
return $SEC
}

#Current track info
UDATE=`date +%s`
nc $SB_HOST $SB_PORT > $SB_OUT <<EOF
GetCurrentSongInfo
GetElapsedTime
GetTotalTime
exit
EOF
TRACK=`grep title $SB_OUT | sed -e 's/GetCurrentSongInfo: title: //'`
TRACKNR=`grep trackNumber $SB_OUT | sed -e 's/GetCurrentSongInfo: trackNumber: //'`
ALBUM=`grep album $SB_OUT | sed -e 's/GetCurrentSongInfo: album: //'`
ARTIST=`grep artist $SB_OUT | sed -e 's/GetCurrentSongInfo: artist: //'`
POS=`grep GetElapsedTime $SB_OUT | sed -e 's/GetElapsedTime: //'`
TIME=`grep GetTotalTime $SB_OUT | sed -e 's/GetTotalTime: //'`

#Remove Carriage returns.
ARTIST=`echo $ARTIST | tr -d '\r'`
ALBUM=`echo $ALBUM | tr -d '\r'`
TRACK=`echo $TRACK | tr -d '\r'`
TRACKNR=`echo $TRACKNR | tr -d '\r'`
seconds $TIME
TRLENGHT=$SEC

seconds $POS
let POS=(SEC*100)/TRLENGHT
if [ $POS -gt 50 ]; then
RATING=L
let STIME=UDATE-SEC
OLDSTIME=`tail $SB_TIME`
let DTIME=OLDSTIME-STIME
if [ $DTIME -lt -60 ];then
echo -e $ARTIST'\t'$ALBUM'\t'$TRACK'\t'$TRACKNR'\t'$TRLENGHT'\t'$RATING'\t'$STIME >> $SB_LOG
fi
echo $STIME > $SB_TIME
else
RATING=CL
fi
