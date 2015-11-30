#!/bin/bash
echo -e "#######################################"
echo -e "#            MURLEXTRACTOR            #"
echo -e "#######################################"
echo -e "#    Retrieve URLS from a txt file    #"
echo -e "#  And extract mails from those URLS  #"
echo -e "#######################################"
#to run, you'll need sed and theharvester
#URL EXTRACTION
trap "exit" INT
echo -e "#######################################"
echo -e "file to extract URLS from ? :"
echo -e "#######################################"
read file
#rm -rf *.txt
echo -e "output to extracted.txt"
sed -ne 's/.*\(http[^"]*\).*/\1/p' < $file > extracted.txt
sed -e 's/^http\/\///g' -e 's/^http:\/\///g' -e 's/^https:\/\///g' extracted.txt > parsed.txt
sed 's/www.//' parsed.txt > parsed2.txt
sed 's/\///' parsed2.txt > parsed3.txt
rm -rf extracted.txt parsed.txt parsed2.txt

#Extract mails from those URLS
my_date=$(date +"%y_%m_%d")
oldproject=$(ls -d */|sed 's/\///')
for i in $oldproject
do
	rand1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
	echo -e "Old session found ..."
	echo -e "Backed up on $oldproject.tgz"
	tar -cvzf $oldproject.tgz $oldproject
	rm -rf $oldproject
	oldproject=$(ls -d */|sed 's/\///')
	sleep 1
done

rand1=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
myfolder=reports"-"$my_date"-"$rand1
mkdir "$myfolder"
file=parsed.txt
cat << EOF > $myfolder/reports_index.html
<h1>Reports from TheHarvester</h1>
EOF
trap "exit" INT
while read line1
do
	rand2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
	theharvester -d $line1 -l 100 -b bing -f $myfolder/$rand2.html
	echo -e "\r\n<a href=$rand2.html>$line1</a>" >> $my_folder/reports_index.html
done < parsed3.txt
