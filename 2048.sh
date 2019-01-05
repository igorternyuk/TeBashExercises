#!/bin/bash

declare -r GRID_SIZE=4
declare -r DX=(1 0 -1 0)
declare -r DY=(0 1 0 -1)

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
	printGrid
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
	if [[ emptyTilesCount -gt 0 ]]; then
		local randIndex=$(getRandom 0 emptyTilesCount)
		local randGridIndex=${emptyTiles[randIndex]}
		grid[randGridIndex]=$(( $(( $(getRandom 0 100) )) > 90 ? 4 : 2 ))
	fi
	
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

updateMaxVal(){
	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = 0; x < GRID_SIZE; x++ )); do
			local i=$(index x y)
			if [[ ${grid[i]} -gt maxTileVal ]]; then
				maxTileVal=${grid[i]}
			fi
		done
	done
}

checkGameStatus(){
	local emptyCount=$(countEmptyTiles)
	if [[ maxTileVal -ge 2048 ]]; then
		echo PLAYER_WON
		return
	fi

	local hasMoves=FALSE
	if [[ emptyCount -gt 0 ]]; then
		echo PLAY
		return
	fi

	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = 0; x < GRID_SIZE; x++ )); do
			local i=$(index x y)
			local currVall=${grid[i]}				
			for (( dir = 0; dir < 4; dir++ )); do
				local nx=$(( x+${DX[dir]} ))
				local ny=$(( y+${DY[dir]} ))
				valid=$(isValidCoords nx ny)
				if [ "$valid" == TRUE ] ; then
					local ni=$(index nx ny)
					if [ ${grid[ni]} == ${grid[i]} ]; then
						echo PLAY
						return
					fi
				fi
			done
		done
	done
	echo PLAYER_LOST
	return
}

checkGameOver(){
	res=$(checkGameStatus)
	if [ "$res" == PLAYER_WON ]; then
		msg="You won!!! Score: $score."
	elif [ "$res" == PLAYER_LOST ]; then
		msg="You lost!!! Score: $score."
	else
		return
	fi

	if [ msg != "" ]; then
		echo $msg
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
	moveDone=FALSE
	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = GRID_SIZE - 2; x >= 0; x-- )); do
			local i=$(index x y)
			if [ "${grid[i]}" -ne 0 ]; then
				local col=$x
				while [[ col -lt $((GRID_SIZE-1)) ]]; do
					local rightCol=$((col+1))
					local currIndex=$(index col y)
					local rightIndex=$(index rightCol y)
					if [ "${grid[rightIndex]}" == 0 ]; then
						grid[rightIndex]=${grid[currIndex]}
						grid[currIndex]=0
						let ++col
						moveDone=TRUE
					elif [ "${grid[rightIndex]}" == "${grid[currIndex]}" ]; then
						grid[rightIndex]=$(( 2 * ${grid[currIndex]} ))
						let score+=${grid[rightIndex]}
						grid[currIndex]=0
						moveDone=TRUE
						break
					else
						break
					fi
				done
			fi
		done
	done
}

slideLeft(){
	moveDone=FALSE
	for (( y = 0; y < GRID_SIZE; y++ )); do
		for (( x = 1; x < GRID_SIZE; x++ )); do
			local i=$(index x y)
			if [ "${grid[i]}" -ne 0 ]; then
				local col=$x
				while [[ col -ge 1 ]]; do
					local leftCol=$((col-1))
					local currIndex=$(index col y)
					local leftIndex=$(index leftCol y)
					if [ "${grid[leftIndex]}" == 0 ]; then
						grid[leftIndex]=${grid[currIndex]}
						grid[currIndex]=0
						let --col
						moveDone=TRUE
					elif [ "${grid[leftIndex]}" == "${grid[currIndex]}" ]; then
						grid[leftIndex]=$(( 2 * ${grid[currIndex]} ))
						let score+=${grid[leftIndex]}
						grid[currIndex]=0
						moveDone=TRUE
						break
					else
						break
					fi
				done
			fi
		done
	done
}

slideUp(){
	moveDone=FALSE
	for (( x = 0; x < GRID_SIZE; x++ )); do
		for (( y = 1; y < GRID_SIZE; y++ )); do
			local i=$(index x y)
			if [ "${grid[i]}" -ne 0 ]; then
				local row=$y
				while [[ row -gt 0 ]]; do
					local upRow=$((row-1))
					local currIndex=$(index x row)
					local upIndex=$(index x upRow)
					if [ "${grid[upIndex]}" == 0 ]; then
						grid[upIndex]=${grid[currIndex]}
						grid[currIndex]=0
						let --row
						moveDone=TRUE
					elif [ "${grid[upIndex]}" == "${grid[currIndex]}" ]; then
						grid[upIndex]=$(( 2 * ${grid[currIndex]} ))
						let score+=${grid[upIndex]}
						grid[currIndex]=0
						moveDone=TRUE
						break
					else
						break
					fi
				done
			fi
		done
	done	
}	

slideDown(){
	moveDone=FALSE
	for (( x = 0; x < GRID_SIZE; x++ )); do
		for (( y = GRID_SIZE - 2; y >= 0; y-- )); do
			local i=$(index x y)
			if [ "${grid[i]}" -ne 0 ]; then
				local row=$y
				while [[ row -lt $((GRID_SIZE-1)) ]]; do
					local downRow=$((row+1))
					local currIndex=$(index x row)
					local downIndex=$(index x downRow)
					if [ "${grid[downIndex]}" == 0 ]; then
						grid[downIndex]=${grid[currIndex]}
						grid[currIndex]=0
						let ++row
						moveDone=TRUE
					elif [ "${grid[downIndex]}" == "${grid[currIndex]}" ]; then
						grid[downIndex]=$(( 2 * ${grid[currIndex]} ))
						let score+=${grid[downIndex]}
						grid[currIndex]=0
						moveDone=TRUE
						break
					else
						break
					fi
				done
			fi
		done
	done
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
				slideRight
				;;
			q )
				quitGame
				;;
		esac
		
		if [ "$moveDone" == TRUE ]; then
			placeNewTile
			updateMaxVal
			let ++moveCount	
		fi
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
    local TOP="|%6s|%6s|%6s|%6s|\n"
    local BOTTOM="|\n|%6s|%6s|%6s|%6s|\n"
    local S="|%6s"
    for((y=0; y < GRID_SIZE; ++y))
    do
    	echo $D
    	printf $TOP
    	for((x=0; x < GRID_SIZE; ++x))
    	do
    		k=$(index x y)
    		if [ "${grid[k]}" == 0 ]; then
    			printf $S "."
    		else
    			printf $S ${grid[k]:-"."}
    		fi
    	done
    	printf $BOTTOM
    done
    echo $D
    echo "Score: $score MaxVal: $maxTileVal MoveCount: $moveCount"
}

initGame
mainLoop