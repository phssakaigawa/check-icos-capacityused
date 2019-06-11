#!/bin/bash

FILENAME=$1

for LINE in `cat ${FILENAME} | grep -v ^# | grep -v ^$`
do
	BUCKET=`echo ${LINE} | cut -d, -f 1`
	APIKEY=`echo ${LINE} | cut -d, -f 2`
	./check-icos-capacityused.sh ${BUCKET} ${APIKEY}
done
