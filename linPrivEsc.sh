#!/bin/bash
echo "MADE BY Vinax"
rm out.txt
echo "You are scaning as user: $1"
echo "With the password: $2"
sleep 5
echo "-----START OF FILE--------------------------------------------------" >> out.txt
#USER PERMISSIONS/INFO
echo "--------------------" >> out.txt
echo "|CURRENT USER INFO:|" >> out.txt
echo "--------------------" >> out.txt
echo "Username provided: $1" >> out.txt
echo "Password provided: $1" >> out.txt
echo "ID:" >> out.txt
id >> out.txt
echo "-----------------------" >> out.txt
echo "|USER COMMAND HISTORY:|" >> out.txt
echo "-----------------------" >> out.txt
cat ~/.*history >> out.txt

echo "Listing permissions as user $1..."
echo "------------------" >> out.txt
echo "|SUDO PERMISSIONS|" >> out.txt
echo "------------------" >> out.txt
echo "$2" | sudo -S -l 2> check.txt >> out.txt
if [[ $(grep Sorry check.txt) != '' ]]; then
	echo "User $1 cant use sudo." >> out.txt
fi



echo "-------------------------" >> out.txt
echo "|FILES WITH SUID BIT SET|" >> out.txt
echo "-------------------------" >> out.txt
find / -perm -u=s -type f 2>/dev/null >> out.txt
find / -perm -u=s -type f 2>/dev/null > check.txt

if [[ $(grep nmap check.txt) != '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m Nmap exploit : https://gtfobins.github.io/gtfobins/nmap/" >> out.txt
fi

if [[ $(grep base64 check.txt) != '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m Base64 exploit : https://gtfobins.github.io/gtfobins/base64/" >> out.txt
fi







echo "Gathering info about the system..."
echo "--------------" >> out.txt
echo "|System info:|" >> out.txt
echo "--------------" >> out.txt
echo "[Kernel info:]" >> out.txt
uname -a >> out.txt
uname -r >> out.txt
echo "(Release info:)" >> out.txt
cat /etc/release >> out.txt



#MISSCONFIGURATION FOLDERS/FILES
echo "Checking important files/folders permissions..."
#FILES
echo "------------------------" >> out.txt
echo "|IMPORTANT FILES PERMS:|" >> out.txt
echo "------------------------" >> out.txt

echo "[/etc/passwd:]" >> out.txt
cat /etc/passwd 2> check.txt
if [[ $(grep denied check.txt) == '' ]] && [[ $(grep 'No such file' check.txt) == '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m User $1 can read /etc/passwd!" >> out.txt
else
	echo "User $1 cant read /etc/passwd" >> out.txt
fi

ls -l /etc/passwd >> out.txt
echo "----------------------------" >> out.txt

echo "[/etc/shadow:]" >> out.txt
cat /etc/shadow 2> check.txt
if [[ $(grep denied check.txt) == '' ]] && [[ $(grep 'No such file' check.txt) == '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m User $1 can read /etc/shadow!" >> out.txt
else
	echo "User $1 cant read /etc/shadow" >> out.txt
fi
ls -l /etc/shadow >> out.txt
echo "----------------------------" >> out.txt

echo "[/etc/sudoers:]" >> out.txt
cat /etc/sudoers 2> check.txt
if [[ $(grep denied check.txt) == '' ]] && [[ $(grep 'No such file' check.txt) == '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m User $1 can read /etc/sudoers!" >> out.txt
else
	echo "User $1 cant read /etc/sudoers" >> out.txt
fi
ls -l /etc/sudoers >> out.txt
echo "----------------------------" >> out.txt

echo "[/etc/opasswd:]" >> out.txt
cat /etc/security/opasswd 2> check.txt
if [[ $(grep denied check.txt) == '' ]] && [[ $(grep 'No such file' check.txt) == '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m User $1 can read /etc/opasswd!" >> out.txt 
else
	echo "User $1 cant read /etc/opasswd" >> out.txt
fi
ls -l /etc/security/opasswd >> out.txt
echo "----------------------------" >> out.txt

#FOLDERS
echo "--------------------------" >> out.txt
echo "|IMPORTANT FOLDERS PERMS:|" >> out.txt
echo "--------------------------" >> out.txt
ls -ld /root >> out.txt
echo "----------------------------" >> out.txt
ls -ld /home >> out.txt



#CRON JOBS
echo "Checking cronjobs..."
echo "------------" >> out.txt
echo "|Cron jobs:|" >> out.txt
echo "------------" >> out.txt
cat /etc/crontab >> out.txt


#NFS
echo "Checking NFS Setings..."
echo "-----------------------" >> out.txt
echo "|NETWORK FILE SHARING:|" >> out.txt
echo "-----------------------" >> out.txt
cat /etc/exports 2> check.txt
if [[ $(grep "No such file or directory" check.txt) != '' ]]; then
	echo "No /etc/exports so probably no NFS" >> out.txt
fi
cat /etc/exports > check.txt
if [[ $(grep no_root_squash check.txt) != '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m You can add file as root to a NFS folder!" >> out.txt
fi
cat /etc/exports >> out.txt



#PATH
echo "Checking path..."
echo "-------" >> out.txt
echo "|PATH:|" >> out.txt
echo "-------" >> out.txt
echo $PATH >> out.txt
export PATH=/tmp:$PATH 2> check.txt 
if [[ $(grep denied check.txt) != '' ]]; then
	echo "User cant edit path." >> out.txt
else
	export PATH=/tmp:$PATH
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m You can edit PATH the directory /tmp as already been added to it!" >> out.txt
fi

# Cap
echo "Checking cap..."
echo "------" >> out.txt
echo "|Cap:|" >> out.txt
echo "------" >> out.txt
getcap -r / 2>/dev/null >> out.txt
getcap -r / 2>/dev/null > check.txt

if [[ $(grep 'cap_setuid+ep' check.txt) != '' ]]; then
	echo -e "\033[0;33m!!!IMPORTANT!!!\033[0m Python cap exploit : https://gtfobins.github.io/gtfobins/python/#capabilities" >> out.txt
fi

#OTHER SHIT
echo "Finding INTERESTING files"
echo "--------------------" >> out.txt
echo "|INTERESTING FILES:|" >> out.txt
echo "--------------------" >> out.txt

echo "[ssh:]" >> out.txt
find / -name *.ssh* 2>/dev/null >> out.txt


#FullScan
#echo "[flags:]" >> out.txt
#find / -name *flag* 2>/dev/null >> out.txt
#echo "----------------------------" >> out.txt
#echo "----------------------------" >> out.txt
#echo "[files containing passwords:]" >> out.txt
#grep --color=auto -rnw '/' -ie "PASSWORD" --color=always 2> /dev/null >> out.txt
echo "-----END OF FILE--------------------------------------------------" >> out.txt

#END
echo "Remooving leftover files"
rm check.txt
echo "Scan completed checkout out.txt"
less -R out.txt
