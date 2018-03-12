# Soundbridge Scrobbler

## Introduction

Soundbridge scrobbler is a bash script that listen to your Soundbridge and scrobble the music your listen to last.fm
See my [journal][1] at last.fm for more details.

## Setup

### Requirements

* [QTScrobbler][2]
* netcat

### Configuration

in logger.sh

* SB_HOST
* SB_PATH

in scrobble.sh

* SB_LOG
* SCROBBLE_CLI

### Crontab

Add entries for both scripts

    */1 * * * * /path/to/logger.sh
    */15 * * * * /path/to/scrobble.sh

[1]: http://www.last.fm/user/SysV/journal/2008/02/11/20zc7r_scrobbling_with_the_soundbridge_on_linux "last.fm"
[2]: http://qtscrob.sourceforge.net/ "QTScrobbler"
