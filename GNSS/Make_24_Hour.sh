#/bin/bash
if [ "$2" == "" ];
then
   echo
   echo "Make_24_Hour.sh <Base File Name> <Extension> [Trailing Name]"
   echo
   echo "JCMBSoft V1.00. GPL V3.0"
   exit 100;
fi

if [ -e $1.$2 ]
then
   echo $1.$2 already exists, skipping creation
   exit 0
fi

files=
for i in {0..9}
do
#   echo $10$i.$2
   if [ -e $10$i$3.$2 ]
       then
       files="$files $10$i$3.$2"
       fi
done

for i in {10..23}
do
#   echo $1$i.$2
   if [ -e $1$i$3.$2 ]
       then
       files="$files $1$i$3.$2"
       fi
done

if [ "$files" = "" ]
then
   echo "No $2 files for $1"
   exit 101
fi

cat $files >$1.$2

echo $1.$2 Created
