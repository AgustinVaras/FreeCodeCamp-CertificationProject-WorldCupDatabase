#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games;")
if [[ $1 == "test" ]]
then
  cat games_test.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
    if [[ $WINNER != "winner" ]]
    then  
      #Get winner ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER' ")

      #if not found
      if [[ -z $WINNER_ID ]]
      then
        #Insert winner
        INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')" )
        
        if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into teams, $WINNER"
        fi

        #Get new ID
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name LIKE '$WINNER' ")
      fi

      #Get opponent ID
      OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name LIKE '$OPPONENT' ")

      #If not found
      if [[ -z $OPPONENT_ID ]] 
      then
        #Insert opponent
        INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')" )
        
        if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
        then
          echo "Inserted into teams, $OPPONENT"
        fi

        #Get new OPPONENT
        OPPONENT_ID=$($PSQL "SELECT name FROM teams WHERE name LIKE '$OPPONENT' ")
      fi 
    fi
  done
fi