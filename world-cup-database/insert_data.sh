#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
then
#get team_id for winner
WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
#If not found
if [[ -z $WINNER_ID ]]
then
#Add winner to teams
  ADD_WINNER="$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")"
  echo -e "\n ADDED $WINNER"
fi

#get team_id for opponent
OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
#If not found

#Add opponent to teams

if [[ -z $OPPONENT_ID ]]
then
  ADD_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")"
  echo -e "\n ADDED $OPPONENT"
fi

#Get winner team id

WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"

#Get Opponent team id

OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"

#insert data into games

ADD_GAME="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
echo -e "\n ADDED " $WINNER AND $OPPONENT OF $YEAR
fi
done
