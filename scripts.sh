#!/bin/bash
currentDate=`date '+%d-%m-%Y'`
errorFile="cron/log/$currentDate-error.txt"
logFile="cron/log/$currentDate-log.txt"

addTimestamps() {
    echo "[`date '+%H:%M:%S'`]" >> $errorFile
    echo "[`date '+%H:%M:%S'`]" >> $logFile
}

runCommand() {
    addTimestamps
    echo "command: $1" >> $logFile >> $errorFile
    (eval "$1") >> $logFile 2>> $errorFile
    echo $?
}

log() {
    addTimestamps
    echo $1 >> $logFile
}

logError() {
    addTimestamps
    echo $1 >> $errorFile
}

runScript() {
    counter=0
    executedOk=0
    maxAttempts=3
    sleepTime=5m
    while [ $counter -le $maxAttempts -a $executedOk -eq 0 ]
    do
        commandResult=`runCommand "$1"`
        if [ $commandResult -eq 0 ]; then
            executedOk=1
        else
            sleep $sleepTime
            ((counter++))
        fi
    done
    echo $executedOk
}

# script example
scriptResult=`runScript "mysql -u userName -ppassword databaseName < mysqlfile.sql"`
if [ $scriptResult -eq 0 ]; then
    logError "Script with error"
    exit 1
else
    log "Script without error"
fi

log "Done"
