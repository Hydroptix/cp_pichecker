# Cal Poly CSC Pi Availability Checker
A script to check if Cal Poly CSC315 Pis are available

## Warnings
This script uses ssh with the `-o StrictHostKeyChecking=no` option to prevent false negatives. This means that if you have not previously connected to one of the Pis, the script is vulnerable to man-in-the-middle DNS attacks. However, if you are running the script on Cal Poly's internal servers/network, this is incredibly unlikely to happen. If you have previously connected to a Pi, ssh will throw an error if the signature does not match.

## Setup
This script requires you to have a **passwordless** RSA key set up for Cal Poly's CSC unix servers. I recommend creating a second key separate from your main key for usage only when connecting from one of Cal Poly's servers to another.

### Setting up a second RSA key
1. SSH into Cal Poly Unix servers.
2. Generate the new RSA key with `ssh-keygen`.
3. Don't use the default file, as you could override your previous key. I used `~/.ssh/cp_csc` for my key.
4. Press enter twice to dismiss the password prompt.
5. Make sure Cal Poly Unix servers will accept the key. The easiest way I found to do this was to use ssh-copy-id. My command looked like this:
```
ssh-copy-id -i ~/.ssh/cp_csc unix1.csc.calpoly.edu
```
Because the file systems are replicated, this will ensure **all** of the Cal Poly servers will accept the key, including the Pis. Because pi02 and pi08 are not replicated, you will also have to copy the keys to these as well.
```
ssh-copy-id -i ~/.ssh/cp_csc pi02.csc.calpoly.edu
ssh-copy-id -i ~/.ssh/cp_csc pi08.csc.calpoly.edu
```

6. Make sure the ssh command uses the new key first when connecting to the Pis. The repository includes a sample config that tells ssh to use the key with the path `~/.ssh/cp_csc` whenever connecting to a host that ends with the address csc.calpoly.edu. Modify the file as appropriate and copy it from the repository to the ~/.ssh directory.
```
cp ./config ~/.ssh/
```
7. Make sure the ssh config file has the appropriate permissions. 
```
chmod 0600 ~/.ssh/config
```
8. The script should now be able to authenticate automatically and securely.

## Usage
It is recommended to run the script from Cal Poly Unix servers, not local machines.
```
sh checkpi.sh
```

The status/load of each Pi will be displayed, and the name of the Pi with the lowest load will be indicated.

## Brief explanation of script behavior
1. Attempt to SSH into each Pi and immediately exit.
2. If the connection succeeded, get system load from `/proc/loadavg`.
3. Report the lowest load, or none if none of the connections succeeded.

## Known Issues
The timeout for connecting to a Pi is relatively low, so the script should not take more than a minute to run even if the Pis don't respond. However, if the Pi accepts the ssh key but quits responding afterwards, the script will hang for approximately 30 seconds before moving on to the next Pi. If you want to troubleshoot this you can replace the `-q` option in the first ssh command with `-v`. Pull requests appreciated if you can fix this as my bash/ssh experience is pretty limited.