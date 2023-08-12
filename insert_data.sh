#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE TABLE games, teams")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    name1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $name1 ]]
    then
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER == 'INSERT 0 1' ]]
      then 
        echo Inserted $WINNER into teams
      fi
      winner_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
    name2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $name2 ]]
    then
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_OPPONENT == 'INSERT 0 1' ]]
      then 
        echo Inserted $OPPONENT into teams
      fi
      opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$winner_id', '$opponent_id', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ $INSERT_GAME == 'INSERT 0 1' ]] 
    then 
      echo Inserted $YEAR $ROUND $WINNER $OPPONENT into games
    fi
  fi
done
