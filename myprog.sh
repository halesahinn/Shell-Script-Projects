# Project 1 
# Özge Yıldırım - Hale Şahin

function myprog1() {


# check if all the given argument number is different than 2, cause it is an error
if [ $# -ne 2 ] 
then
echo "You should give one argument as string and one argument as number" 
return 0
fi


#check if the arguments have same length or argument 2 is 1
if [[ ${#1} -ne ${#2}  &&  ${#2} -ne 1 ]]
then 
echo "Argument lengths should be equal to or the number in the second argument should be one digit"
return 0
fi

str=$1   #First argument is string
number=$2  #Second argument is the number

 #Do the loop as long as the string length and convert string into character array
for (( i=0 ; i < ${#str} ; i++ )) 
 do
   word[$i]=${str:i:1}
done

#Do the loop as long as the number length and convert number into array
for (( i=0 ; i < ${#number} ; i++ )) 
 do
   num[$i]=${number:i:1}
done
#Create alphabet array and digit numbers array
alphabet=( a b c d e f g h i j k l m n o p q r s t u v "w" x y z )
numbers=( 0 1 2 3 4 5 6 7 8 9)

k=-1
#Try to find each character in alphabet if all exist in alphabet, then this string is valid
#And k value should be equal to strings length in order to validfy that string consist of only letters

for((i=0;i<=${#word[@]};i++))
do
for((j=0;j<=${#alphabet[@]};j++))
do 

if [[ ${word[i]} == ${alphabet[j]} ]]
then 
  k=`expr $k + 1`
fi

done 
done
#If k value is not equal to strings length then this string have other characters than letters, so exit the program with error message
if [ "$k" -ne ${#word[@]} ]
then 
echo "You need to write your string with only using English Alphabet"
return 0
fi

#same control in the string, in here for the number with t value
t=-1

for((i=0;i<=${#num[@]};i++))
do
for((j=0;j<=${#numbers[@]};j++))
do 

if [[ ${num[i]} == ${numbers[j]} ]]
then 
  t=`expr $t + 1`
fi

done 
done
#if t is not equal to the number size then, error detected
if [ "$t" -ne ${#num[@]} ]
then 
echo "You need to write your number with only using Natural Digits"
return 0
fi
#word size is greater than one but we choose to use 1 digit then we needed number array to become exact same size with the word, So we add the remaining places of array with the same number.
#For example if the input is aaaa 1 , then this loop will make it aaaa 1111.
if [[ ${#num[@]} -eq 1 && ${#word[@]} -ne 1 ]]
then 
for ((i=0;i<${#word[@]};i++)); do
  num[$i]=${num[0]}
done
fi

#And now take letter from alphabet where the index of alphabet array comes from index of letter in alphabet plus the corresponding number

for((i=0;i<${#word[@]};i++)); do
for((j=0;j<=${#alphabet[@]};j++))
do 

if [[ ${word[i]} == ${alphabet[j]} ]]
then 
  let "m = ${num[i]}+j"
   if [[ m -gt 26 ]]
   then 
   let "m = m - 26" #If it is at the end of alphabet, start from all over again.
  fi
 arr[$i]=${alphabet[m]}
fi
done
done

printf "`echo "The result string is "``echo ${arr[@]} | tr -d ' '`"
 #Resulting array is showed in the screen  without spaces









}




##############################################################################



function myprog2() {
#Control the argument number which user gave, it should be 1.

if [ $# -gt 1 ] 
then
echo "You should give only one argument for the file name" 
return 0
fi
#If no arguments given, prompt the user
if [ -z "$1" ]
then 
echo "You should give one argument for the file name "
return 0
fi

#create 3 random numbers differ from 0 to 2 
DIFF=$((2+1))
a=$(($RANDOM%$DIFF))

DIFF=$((2+1))
b=$(($RANDOM%$DIFF))

DIFF=$((2+1))
c=$(($RANDOM%$DIFF))

#Read first txt file and hold line by line in array 'giris'
i=0
while IFS='' read -r line || [[ -n "$line" ]]; do
   if [ -n "$line" ]; then
    giris[$i]=$line
    let "i += 1"
    fi
done < "giris.txt"

#Read second txt file and hold line by line in array 'gelisme'
i=0
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ -n "$line" ]; then
    gelisme[$i]=$line
    let "i += 1"
    fi
done < "gelisme.txt"

#Read third txt file and hold line by line in array 'sonuc'
i=0
while IFS='' read -r line || [[ -n "$line" ]]; do
    if [ -n "$line" ]; then
    sonuc[$i]=$line
    let "i += 1"
    fi
done < "sonuc.txt"

#If the given file exist, prompt user and get choice
if [ -e $1 ]; then
echo "$1 exist. Do you want it to be modified? (y/n): "
read choice1
if [ $choice1 == 'y' ]; then
#If choice is yes, overrite the file
echo "A random story is created and stored in $1"
{
echo ${giris[a]} > $1
echo " " >> $1
echo ${gelisme[b]} >> $1
echo " " >> $1
echo ${sonuc[c]} >> $1
}
else #if no, prompt user, we didn't do anything
echo "You can try again with a non-exist file name."
fi
else
#if file does not exxist, create and write the sentences chosen randomly from the arrays
echo "A random story is created and stored in $1"
echo ${giris[a]} >> $1
echo " " >> $1
echo ${gelisme[b]} >> $1
echo " " >> $1
echo ${sonuc[c]} >> $1
fi

}

##################################################################

function myprog3() {

#control for there will be no arguments
if [ "$#" -gt 0 ]; then
echo "You cannot give any arguments when you are trying to move the files to writable directory"
return 0
fi

mkdir -p writable  #-p prevents error if this directory already exists

moved=`ls -l | find -path ./writable -prune -o -type f -perm /u=w | wc -l`
((moved--))

#find the permission which u is user and w is write permission, execute results and move them on the writable directory
#type f means do this command for only file types, '.' means do the search in current directory
#mv functions controls and prompts if the file to be moved is alredy exists in the writable directory.
#{} \+ makes command run only one time and append each result and all results moved
find . -type f -perm /u=w -exec mv -t writable {} \+


#find how many files in the current directory has write permission for user, 
#prompt the result to user, 
#path for writable directory excluded from the searching directories,
#because if there is already files in the writable directory, then it shouldn't count them as the moved files.
#wc will give the number permission will be looked in current directory ls -l command
echo "$moved files moved to writable directory."


}

###################################################################
function isPrime () {  #function to identify prime numbers 
x=$(( $1 ))  #take the argument int form in x value
if [ $x -eq 2 ]; then #if argument is 2 then it is prime but special one, return 1
return 1
fi

for((i=2;i < $x;i++)); do #if x value have not divided all the integer values below them with zero remainder
t=`expr $x % $i`          #that means it is prime it does not divided any number other than itself and 1
if [ "$t" -eq 0 ]; then   #that iss why we excluded those from the loop
return 0
fi
done

return 1    #if the loop failed then it is prime return 1
}

##############################################################################################################


function hexa () {
num=$1   #take the argument into two values to use
num2=$1
s=0
while [ $num -ne 0 ]; do  #do the loop until number is 0
rm=`expr $num % 16`   #remainder of the number divided by 16 is kept in rm value
case $rm in
0)                   #case for hexadecimal format for each value of remainder
hexa[$s]=0
s=`expr $s + 1`     #hold the resulting hexadecimal value in array but in reverse way
;;
1)
hexa[$s]=1
s=`expr $s + 1`
;;
2)
hexa[$s]=2
s=`expr $s + 1`
;;
3)
hexa[$s]=3
s=`expr $s + 1`
;;
4)
hexa[$s]=4
s=`expr $s + 1`
;;
5)
hexa[$s]=5
s=`expr $s + 1`
;;
6)
hexa[$s]=6
s=`expr $s + 1`
;;
7)
hexa[$s]=7
s=`expr $s + 1`
;;
8)
hexa[$s]=8
s=`expr $s + 1`
;;
9)
hexa[$s]=9
s=`expr $s + 1`
;;
10)
hexa[$s]=A
s=`expr $s + 1`
;;
11)
hexa[$s]=B
s=`expr $s + 1`
;;
12)
hexa[$s]=C
s=`expr $s + 1`
;;
13)
hexa[$s]=D
s=`expr $s + 1`
;;
14)
hexa[$s]=E
s=`expr $s + 1`
;;
15)
hexa[$s]=F
s=`expr $s + 1`
;;
esac
if [ $num -gt 16 ]; then    #if number is higher than 16 divide 16 and continue with remaniders
num=`expr $num / 16`
else
num=0                      #if not, then this will be over set the num 0
fi

done
#reverse the array of result because it should be last in first out
h=0
for((f=`expr ${#hexa[@]} - 1`;f>=0;f--)); do
out[$h]=${hexa[f]}
h=`expr $h + 1`
done
#prompt the user as requested way
printf "`echo "Hexadecimal of $num2 is "` `echo ${out[@]} | tr -d ' '`\n"
}


######################################################################################################

function myprog4() {


# check if all the given argument number is different than 1, cause it is an error
if [ $# -ne 1 ] 
then
echo "You should give only one argument in type of number" 
return 0
fi

number=$1  #argument is the number
numbers=( 0 1 2 3 4 5 6 7 8 9)

#Do the loop as long as the number length and convert number into array
for (( i=0 ; i < ${#number} ; i++ )) 
 do
   num[$i]=${number:i:1}
done
#control if argument is composed of digits if contrary, then prompt error and exit
t=-1

for((i=0;i<=${#num[@]};i++))
do
for((j=0;j<=${#numbers[@]};j++))
do 

if [[ ${num[i]} == ${numbers[j]} ]]
then 
  t=`expr $t + 1`
fi
done 
done

#if t is not equal to the number size then, error detected
if [ "$t" -ne ${#num[@]} ]
then 
echo "You need to write your number with only using Natural Digits"
return 0
fi

if [ $number -lt 0 ]; then #if somehow argument is negative say it is error
echo "You should execute this program with only positive numbers"
return 0
fi

#from 2 to the number call hexa function for all prime numbers detected by isPrime function
for ((jj=2;jj < $number;jj++)); do
isPrime $jj
rslt=$?
if [ $rslt -eq 1 ]; then
hexa $jj
fi
done

}

################################################################################

function myprog5() {

if [ -z $opt ]; then  #if second argument is null that means 
#we are looking in just current directory
count=0
#take all arguments in the command line 
for ((arg=1;arg<=$#;arg++)); do
if [[ -f ${!arg} ]]; then #choose only the files not directories
files[$count]=${!arg} #pass them into array
((count++))
fi
done
#do the loop as long as array and ask for each to delete prompt user
deletedfile=0
for ((size=0;size<${#files[@]};size++)); do
echo "Do you want to delete ${files[$size]}? (y/n): "
read choice2
if [ $choice2 == 'y' ]; then #if user says yes than delete file
rm ${files[$size]}
((deletedfile++))
echo "1 file deleted"
else 
continue
fi
done
echo "$deletedfile files deleted." #write down how many files deleted in total



else #if a specific directory is given
#find the resulting files in that director and all the sub directories
#-L is preventing error symbolic
#type -f of course for the file type
#iname ignores capital letters



files2=(`find $opt -type f -iname "$wild" `)
#ask user to delete for each file
deletedfile2=0
for ((size2=0;size2<${#files2[@]};size2++)); do
echo "Do you want to delete ${files2[$size2]}? (y/n): "
read choic2
if [ $choic2 == 'y' ]; then
rm ${files2[$size2]}
((deletedfile2++))
echo "1 file deleted"
else 
continue
fi
done
echo "$deletedfile2 files deleted."

fi


}



############################################################################################



#do the loop until it says exit
while true; do
echo " "
echo "1. Cipher word"
echo "2. Create story"
echo "3. Move files"
echo "4. Convert hexadecimal"
echo "5. Delete files"
echo "6. Exit"
echo "Please select an option: "
read selection    #take selection
case $selection in
1)
echo "Write your string value: "  #take arguments
read arg1
echo "Write your number value: "
read arg2
myprog1 $arg1 $arg2   #call functions
;;
2)
echo "Write your file name: "
read fileNamee
myprog2 $fileNamee
;;
3)
myprog3
;;
4)
echo "Write your number: "
read numb
myprog4 $numb
;;
5)
echo "Write your wildcard: "
read wild
echo "You can add a specific directory."
read opt

if [ -z "$opt" ]; then
myprog5 $wild
else
myprog5 $wild $opt
fi
;;
6)
exit 1
;;
*) 
echo "You entered wrong selection try again!"
;;
esac
done
