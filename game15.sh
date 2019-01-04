#!/bin/bash

declare -r GRID_SIZE=4
declare -r NUM_TILES=15

getRandom(){
	local rand=$RANDOM
	if [[ ! -z "$2" ]]
	then
		local range=$(($2-$1))
		let rand%=range
		let rand+=$1
		echo $rand
	else
		let rand%=$1
		echo $rand
	fi
	return
}

index(){
	i=$(( $2 * $GRID_SIZE + $1 ))
	echo $i
}

swapTiles(){
	buf=${grid[$1]}
	grid[$1]=${grid[$2]}
	grid[$2]=$buf
}

makeSolvable(){
	numChaos=0
	for ((i=1; i <= NUM_TILES; ++i))
	do
		for ((j=i; j <= NUM_TILES; ++j))
		do
			if [[ ${grid[j]} -gt i ]]; then
				let numChaos++
			fi
		done
	done

	echo "numChaos = $numChaos"
	if (( ((numChaos % 2)) == 1 )); then
		last=$((NUM_TILES-1))
		before_last=$((NUM_TILES-2))
		swapTiles $last $before_last
		echo "make solvable"
	fi
}

quitGame(){
	for((;;))
	do
		read -n 1 -s -p "Do you really want to quit [y/n]?"
		case $REPLY in
			y|Y) exit
			;;
			n|N) return
			;;
		esac
	done

}

checkWin(){
	for(( i=0; i < NUM_TILES; ++i))
	do
		if [[ ${grid[i]} != $((i+1)) ]]; then
			return
		fi
	done
	for((;;))
	do
		read -n 1 -s
		case $REPLY in
			y|Y )
				initGame
				break
				;;
			n|N) exit
			;;
		esac
	done
}

isValidCoords(){
	if [[ $1 -ge 0 ]] && [[ $1 -lt NUM_TILES ]] && [[ $2 -ge 0 ]] && [[ $2 -lt NUM_TILES ]]; then
		echo TRUE
	else
		echo FALSE
	fi
}

startGame(){
	for (( ;; ));
	do
		echo "EMPTY = $EMPTY"
		ex=$((EMPTY%GRID_SIZE))
		ey=$((EMPTY/GRID_SIZE))
		echo "ex= $ex ey= $ey"
		echo "Use w,a,s,d to move and q to quit"
		read -n 1 -s

		case $REPLY in
			w)
				targety=$((ey+1))
				valid=$(isValidCoords ex targety)
				if [ "$valid" == TRUE ]; then
					t=$(index ex targety)
					swapTiles EMPTY t
					EMPTY=$t
					echo "Swaping tiles"
				fi
			;;

			a)
				targetx=$((ex+1))
				valid=$(isValidCoords targetx ey)
				if [ "$valid" == TRUE ]; then
					t=$(index targetx ey)
					swapTiles EMPTY t
					EMPTY=$t
					echo "Swaping tiles"
				fi
			;;

			s)
				targety=$((ey-1))
				valid=$(isValidCoords ex targety)
				if [ "$valid" == TRUE ]; then
					t=$(index ex targety)
					swapTiles EMPTY t
					EMPTY=$t
					echo "Swaping tiles"
				fi
			;;

			d)
				targetx=$((ex-1))
				valid=$(isValidCoords targetx ey)
				if [ "$valid" == TRUE ]; then
					t=$(index targetx ey)
					swapTiles EMPTY t
					EMPTY=$t
					echo "Swaping tiles"
				fi
			;;

			q)
			quitGame
			;;
		esac
		printGrid
		checkWin
	done
}

initGame(){
	grid=()	
	bound=$(($NUM_TILES+1))
	echo "bound = $bound"
	for ((i=1; i <= NUM_TILES; ++i))
	do
		j=$(getRandom 0 $bound)
		while [[ ${grid[j]} != "" ]]; do
			j=$(getRandom 0 $bound)
		done
		grid[j]=$i
	done

	for ((i=0; i <= NUM_TILES; ++i))
	do
		if [[ ${grid[i]} == "" ]]; then
			swapTiles i NUM_TILES 
		fi
	done
	EMPTY=$NUM_TILES;
	makeSolvable
}

printGrid(){
	clear
    D="-----------------"
    S="|%3s"
    for((y=0; y < GRID_SIZE; ++y))
    do
    	echo $D
    	for((x=0; x < GRID_SIZE; ++x))
    	do
    		k=$(index x y)
    		printf $S ${grid[k]:-"."}
    	done
    	printf "|\n"
    done
    echo $D
}

initGame
printGrid
startGame
