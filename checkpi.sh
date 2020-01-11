#!/bin/bash
#a script to check if raspberry pi servers respond

#loop through all the Pis that should be available
for HOST in pi01 pi02 pi03 pi04 pi05 pi06 pi07 pi08 pi09
do	
	#connect quietly and fail if it asks for a password or doesn't connect, if connection is successful get the load
	LOAD=`ssh -q -o ConnectTimeout=1 -o BatchMode=yes -o PasswordAuthentication=no -o StrictHostKeyChecking=no $HOST.csc.calpoly.edu cat /proc/loadavg | awk '{print $1}'`
	if [ -z "$LOAD" ]
	then
		echo $HOST down
	else
		#save this host if it has the lowest load
		echo $HOST has load $LOAD
		if [ -z "$BESTHOST" ]
		then
			BESTHOST=$HOST
			BESTLOAD=$LOAD
		else
			if (( $(echo "$BESTLOAD > $LOAD" |bc -l) ));
			then
				BESTHOST=$HOST
				BESTLOAD=$LOAD
			fi
		fi
	fi
done

#Connect to the host with the lowest amount of load
if [ -z "$BESTHOST" ]
then
	echo no hosts up
else
	echo $BESTHOST has lowest load
fi
