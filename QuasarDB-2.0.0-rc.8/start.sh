#!/bin/bash

#==================================================================================================
# @author : Alexis Ducastel <aducastel@makazi.com>
#==================================================================================================

#===[ Searching for binary absolute path ]=========================================================
QDB_SERVER=`which qdbd`
QDB_HTTPD=`which qdb_httpd`
AWK=`which awk`

#===[ Initializing QuasarDB Daemon options ]=======================================================
OPT=""

#===[ Checking simple variables ]==================================================================
[ "$DEVICE" = "" ] && echo "Error : must specify hardware listening device (eth0?)" >&2  && exit 1
[ "$PORT" = "" ] && PORT=2836
[ "$WEBPORT" = "" ] && WEBPORT=8080

#===[ Force $PEER resolution with dig ]============================================================
function checkNwait4Peer {
  if [[ $PEER =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
  then
    IP="$PEER"
  else
    IP=""
    while [ "$IP" = "" ]
    do
      echo "Waiting for $PEER"
      IP=$(dig +short $PEER |head -n1)
      sleep 1
    done
  fi
  OPT="$OPT --peer $IP:$PORT"
  echo "[INFO] Using peer $IP:$PORT"
}

[ "$PEER" != "" ] && checkNwait4Peer

#===[ If Web UI flag is present, only start Web UI ]===============================================
if [ "$1" = "httpd" ]
then
	echo $QDB_HTTPD -a $DEVICE:$WEBPORT --node $IP:$PORT
	$QDB_HTTPD -a $DEVICE:$WEBPORT --node $IP:$PORT
	exit
fi

#===[ Checking presence of attributes related variables ]==========================================
if [ "$ID" != "" ]
then
    echo "[INFO] Using node ID $ID"
    OPT="$OPT --id $ID"
fi

if [ "$LICENSE" != "" ]
then
    echo "[INFO] Using license $LICENSE"
    OPT="$OPT --license-key $LICENSE"
fi

if [ "$REPLICATION" != "" ]
then
  echo "[INFO] Using replication factor $REPLICATION"
  OPT="$OPT --replication $REPLICATION"
fi

if [ "$LIMITER_MAX_BYTES" != "" ]
then
  echo "[INFO] Maximum number of bytes allowed in memory set to $LIMITER_MAX_BYTES"
  OPT="$OPT --limiter-max-bytes $LIMITER_MAX_BYTES"
fi

#===[ Printing command and start QuasarDB Daemon in front ]========================================
echo $QDB_SERVER -a ${DEVICE}:${PORT} $OPT
$QDB_SERVER -a ${DEVICE}:${PORT} $OPT
