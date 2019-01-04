#!/bin/bash

declare -r NUM1=5

getDate(){
	date 
	return
}

num2=4
num3=$((NUM1+num2))
num4=$((NUM1-num2))
num5=$((NUM1*num2))
num6=$((NUM1/num2))

echo $num5
echo $(($num2**3))
echo $((24%7))
counter=0
while [[ counter -le 50 ]]; do
	rand=$RANDOM
	let rand%=100
	echo "rand[$counter] = $rand"
	let counter+=1
done

val=$RANDOM
let val%=100
echo "val = $val"
echo "val++ = $((val++))"
echo "val-- = $((val--))"
echo "++val = $((++val))"
echo "--val = $((--val))"

num7=18.44
num8=7.99
echo $(python3 -c "print(eval(\"$num7**2+8/$num8\"))")
getDate

getSum(){
	local num1=$1
	local num2=$2
	local sum=$(($num1+$num2))
	echo $sum
}

num10=100
num11=200
sum=$(getSum num10 num11)
echo "The sum is $sum"

read -p "How old are you? " age
canVote=$((age >= 18?(canVote=1):(canVote=0)))
echo "Can vode: $canVote"

if [ $age -le 15 ]
then
	echo "You can't drive"
elif [ $age -ge 16 -a $age -le 60 ]
then
	echo "You can drive"
else
	echo "You are too old"
fi

read -p "How old is your daughter: " hijaEdad

case $hijaEdad in
	[0-4])
		echo "Too young for school"
		;;
	5)
		echo "She should go to KinderGarten"
		;;
	[6-9]|1[0-8])
		grade=$((hijaEdad-5))
		echo "She should go to grade $grade"
		;;
	*)
		echo "She is too old for school"
		;;
esac

read -p "Enter your height in sm: " height
read -p "Enter your weight: " weight
normalWeight=$((height-100))
if(($weight >= normalWeight))
then
	echo "You are fat"
fi

read -p "Enter a number: " number

if (( (( number % 2 )) == 0 ))
then
	echo "The number is even"
else
	echo "The number is odd"
fi

read -p "Enter a number: " num

if (( (( $num >= 0 )) && (( $num <= 10 )) ))
then
	echo "The number is between 1 and 10"
fi

str1="Ubuntu"
str2="Windows"
str3="MacOS"

if [ "$str1" == "Ubuntu" ]; then
	echo "Ubuntu"
elif [ -z "str1" ]; then
	echo "$str1 is not null"
fi

if [ "$str1" > "$str2" ]; then
	echo "$str1 is greater then $str2"
elif [ "$str1" < "$str2" ]; then
	echo "$str2 is greate then $str1"
else
	echo "$str1 and $str2 are equal"
fi	#statements

file1="/home/igor/.bashrc"
if [ -e "$file1" ]; then
	echo "$file1 exists"
else
	echo "$file1 does not exists"
fi

read -p "Validate a date: " fecha

pattern="^[0-9]{6}$"

if [[ $fecha =~ $pattern ]]; then
	echo "The date is valid"
else
	echo "The date isn't valid"
fi

rand_str="Quick brown fox jumps over old lazy dog"

echo "String length : ${#rand_str}"
echo "${rand_str:6}"
echo "${rand_str:6,15}"
echo "${rand_str#*x}"

#Loops

num=1

while [[ num -le 100 ]]; do
	if (( ((num % 2)) == 0 )); then
		let num++
		continue
	fi

	if (( $num >= 77 )); then
		break
	fi

	echo "num = $num"

	num=$((++num))
done

num=1

until [[ num -gt 20 ]]; do
	num=$((num+1))
	echo "num = $num"
done

for (( i=0; i <= 50; ++i)); do
	echo $i
done

for j in {A..Z}; do
	echo $j
done

#Arrays

fav_nums=(3.14 2.718 .57721 4.6692)

echo "Pi: ${fav_nums[0]}"
echo "E: ${fav_nums[1]}"
echo "GR: ${fav_nums[2]}"

fav_nums[4]=1.618

fav_nums+=(1 7)

for i in ${fav_nums[*]}; do
	echo $i
done

#Interate through all array indexes
for index in ${#fav_nums[@]}; do
	echo $index
done

#Get array length

arrLength=${#fav_nums[@]}

echo "arrLength = $arrLength"

sorted_nums=($(for i in ${fav_nums[@]}; do echo $i; done | sort))

echo "Sorted:"

for i in ${sorted_nums[*]}; do
	echo $i
done

unset 'fav_nums[0]'

for i in ${fav_nums[*]}; do
	echo $i
done

arrLength=${#fav_nums[@]}
echo "arrLength = $arrLength"