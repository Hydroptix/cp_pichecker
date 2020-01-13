#!/bin/bash
#a script to set up ssh keys for raspberry Pis

KEYPATH=~/.ssh/cp_pi_checker
CONFIGPATH=~/.ssh/config

#generate the new key
ssh-keygen -N "" -f $KEYPATH
if [ $? -ne 0 ]
then
	echo key generation threw an error
	exit 1
fi
echo Generated new key \"$KEYPATH\"

#add key to Cal Poly Unix servers
echo Attempting to add key \"$KEYPATH\" to Cal Poly CSC servers
ssh-copy-id -f -i $KEYPATH unix1.csc.calpoly.edu

echo Attempting to add key \"$KEYPATH\" to standalone Pis
ssh-copy-id -f -i $KEYPATH pi02.csc.calpoly.edu
ssh-copy-id -f -i $KEYPATH pi08.csc.calpoly.edu

#check if the key rule has already been added to the config file
grep -q -s pi??.csc.calpoly.edu $CONFIGPATH
if [ $? -eq 0 ]
then
	echo Existing rule detected, skipping ssh config
else
	echo appending key config to \"$CONFIGPATH\"
	echo Host pi??.csc.calpoly.edu cp_pi_checker >> $CONFIGPATH
	echo "	IdentityFile $KEYPATH" >> $CONFIGPATH
fi

echo Key setup complete.