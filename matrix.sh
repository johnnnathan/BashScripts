#!/usr/bin/env bash

board=()
cols=$(tput cols)
lines=$(tput lines)
GREEN='\033[0;32m'

reset_cursor ()
{
  tput cup 0 0
}

print_board ()
{
  local foreign_chars=('0' '4' 'λ' 'Φ' 'ω' 'á' 'é' 'í' 'ó' 'ú' 'ñ' 'ç' 'ß' 'ø' 'å' 'æ' 'ø' 'ä' 'ö' 'ü' 'ÿ' 'œ' 'þ' 'ð' 'ł')
  local char_count=${#foreign_chars[@]}
  local counter=0

  for ((i = 0; i < lines - 1; i++)); do 
    for ((j = cols - 1; j > -1; j--)); do 
      value="${board[$((i * cols + j))]:-0}"
      if [ $value -eq 0 ]; then
        echo -n " "
      else
        foreign_char="${foreign_chars[$((counter % char_count))]}"
        echo -n -e "${GREEN}$foreign_char"
        ((counter++))
      fi
    done
    echo ""
  done
}
initialize_board ()
{
  for ((i = 0; i < cols; i++));do 
    for ((j = 0; j < lines; j++));do 
      board[$i * cols + $j]=0
    done
  done
  
}

clone_active ()
{
  for ((i = 0 ; i < cols; i++)); do 
    index=$i
    value="${board[$((cols + index))]:-0}"
    if [ $value -eq 1 ]; then 
      roll=$((RANDOM % 2))
      hit=0 
      if [ $roll -eq $hit ]; then 
        board[$index]=1
      fi 
    fi
  done
}

populate_first_line ()
{
  for ((i = 0 ; i < cols; i++)); do 
    index=$i
    value="${board[$index]:-0}"
    if [ $value -eq 0 ]; then
      roll=$((RANDOM % 40 ))
      hit=0
      if [ "$roll" -eq "$hit" ]; then 
        board[$i]=1
      fi 
    fi 
  done
}
operate ()
{
  for ((i = lines - 1 ; i > -1 ; i--));do 
    for ((j = cols ; j > -1 ; j--)); do 
      value="${board[$((i * cols + j))]:-0}"
      if [ "$value" -eq 1 ]; then 
        next_line=$(($i + 1))
        board[$((next_line * cols + j))]=1
        board[$((i * cols + j))]=0
      fi
    done 
  done 
}

function cleanup() {
    tput cnorm
}

trap cleanup EXIT

tput civis
initialize_board
while true; do 
  reset_cursor        # Step 1: Clear the screen and reset the cursor
  operate             # Step 2: Move particles down
  clone_active        # Step 3: Clone active particles in the next row
  populate_first_line # Step 4: Populate the first line with new particles
  print_board         
  sleep 0.1
done

