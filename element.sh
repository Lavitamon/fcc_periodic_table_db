#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  # check if argument is an integer or a string and que database accordingly
  if [[ $1 -gt 0 ]]
  then
    RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi

  # if not found
  if [[ -z $RESULT ]]
  then
    echo I could not find that element in the database.
  else
    # echo result
    echo $RESULT | while IFS="|" read NUMBER SYMBOL NAME TYPE MASS MELTING_POINT BOILING_POINT
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      done
  fi
else
  echo Please provide an element as an argument.
fi
