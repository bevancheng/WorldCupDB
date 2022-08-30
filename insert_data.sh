#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

TRUNCATE=$($PSQL "TRUNCATE games,teams;")


cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  
  if [[ $YEAR != year ]]
  then
    #echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    # get winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER';")
    # if not found 
    if [[ -z $WINNER_ID ]]
    then
      # insert winner
      INSERT_WINNER_RESULT=$($PSQL "insert into teams(name) values('$WINNER');")
      echo "INSERT INTO teams(name) : $WINNER"
      # get winner_id 
      WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER';")
    fi

    # get opponent_id
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT';")
    # if not found 
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values('$OPPONENT');")
      echo "INSERT INTO teams(name) : $OPPONENT"
      # get opponent_id
      OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT';")
    fi

    #insert all
    INSERT_GAMES_RESULT=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")
    echo "INSERT INTO ALL"
  fi
done
