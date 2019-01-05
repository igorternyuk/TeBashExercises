#!/bin/bash

declare -r GRID_SIZE=4
DX=(1 0 -1 0)
DY=(0 1 0 -1)

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

isValidCoords(){
	if [[ $1 -ge 0 ]] && [[ $1 -lt GRID_SIZE ]] && [[ $2 -ge 0 ]] && [[ $2 -lt GRID_SIZE ]]; then
		echo TRUE
	else
		echo FALSE
	fi
}

initGame(){
	grid=()
	maxTileVal=2
	moveCount=0
	score=0
	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = 0; x < GRID_SIZE; x++ )); do
			local i=$(index x y)
			#grid[i]=$(( (( i % 2 )) == 0 ? 2048 : 256 ))
			grid[i]=0
		done
	done
	placeNewTile
	placeNewTile
}

placeNewTile(){
	local emptyTiles=()
	local index=0
	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = 0; x < GRID_SIZE; x++ )); do
			local i=$(index x y)
			#grid[i]=$(( (( i % 2 )) == 0 ? 2048 : 256 ))
			if [ ${grid[i]} == 0 ]; then
				emptyTiles[index]=$i
				let ++index
			fi
		done
	done
	local emptyTilesCount=${#emptyTiles[@]}
	local randIndex=$(getRandom 0 emptyTilesCount)
	local randGridIndex=${emptyTiles[randIndex]}
	grid[randGridIndex]=$(( $(( $(getRandom 0 100) )) > 90 ? 4 : 2 ))
}

countEmptyTiles(){
	local emptyCounter=0
	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = 0; x < GRID_SIZE; x++ )); do
			local i=$(index x y)
			if [[ ${grid[i]} == 0 ]]; then
				let emptyCounter++
			fi
		done
	done
	echo $emptyCounter	
}

checkGameStatus(){
	local emptyCount=$(countEmptyTiles)
	if [[ maxTileVal -ge 2048 ]]; then
		echo PLAYER_WON
		return
	elif [[ emptyCount -gt 0 ]]; then
		local hasMoves=FALSE
		for (( y = 0; y < GRID_SIZE; y++ )); do
			for (( x = 0; x < GRID_SIZE; x++ )); do
				local i=$(index x y)
				local currVall=${grid[i]}				
				local counter=0
				for (( dir = 0; dir < 4; dir++ )); do
					local nx=$(( x+${DX[dir]} ))
					local ny=$(( y+${DY[dir]} ))
					valid=$(isValidCoords nx ny)
					if [ "$valid" == TRUE ] ; then
						let counter++
						local ni=$(index nx ny)
						echo "ni = $ni"
						if [ ${grid[ni]} == ${grid[i]} ]; then
							echo PLAY
							return
						fi
					fi
				done
				grid[i]=$counter
				if [[ ${grid[i]} -gt  maxTileVal ]]; then
					maxTileVal=${grid[i]}
				fi
			done
		done
	fi
	echo PLAYER_LOST
	return
}

checkGameOver(){
	res=$(checkGameStatus)
	if [ $res == PLAYER_WON]; then
		msg="You won!!! Score: $score."
	elif [ $res == PLAYER_LOST ]; then
		msg="You lost!!! Score: $score."
	else
		return
	fi

	if [ msg != "" ]; then
		for((;;))
		do
			echo  "Would you like to play again [y/n]?"
			read -n 1 -s
			case $REPLY in
				y|Y)
					initGame
					break
					;;
				n|N)
					exit
					;;
			esac
		done	
	fi	
}

slideRight(){
	echo Sliding right
}

slideLeft(){
	echo Sliding right
}

slideUp(){
	echo Sliding up
}	

slideDown(){
	echo Sliding down
}

mainLoop(){
	for((;;));
	do
		echo "Use w,a,s,d to slide and q to quit"
		read -n 1 -s
		case $REPLY in
			w )
				slideUp
				;;
			a )
				slideLeft
				;;
			s )
				slideDown
				;;
			d )
				slideRigh
				;;
			q )
				quitGame
				;;
		esac
		printGrid
		checkGameOver
	done
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

printGrid(){
	clear
    D="-----------------------------"
    C1="|%6s|%6s|%6s|%6s|\n"
    C2="|\n|%6s|%6s|%6s|%6s|\n"
    S="|%6s"
    for((y=0; y < GRID_SIZE; ++y))
    do
    	echo $D
    	printf $C1
    	for((x=0; x < GRID_SIZE; ++x))
    	do
    		k=$(index x y)
    		if [ ${grid[k]} == 0 ]; then
    			printf $S "."
    		else
    			printf $S ${grid[k]:-"."}
    		fi
    	done
    	printf $C2
    done
    echo $D
    echo "Score: $score MaxVal: $maxTileVal MoveCount: $moveCount"
    echo ${grid[@]}
}

initGame
countEmptyTiles
checkGameStatus
printGrid