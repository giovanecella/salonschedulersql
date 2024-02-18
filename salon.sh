#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  echo "How may I help you?" 
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) REGISTER_APPOINTMENT ;;
    2) REGISTER_APPOINTMENT ;;
    3) REGISTER_APPOINTMENT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}

REGISTER_APPOINTMENT() {
  # get customer info
    echo -e "\nWhat's your phone number?"
      read CUSTOMER_PHONE

      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

      # if customer doesn't exist
      if [[ -z $CUSTOMER_NAME ]]
      then
        # get new customer name
        echo -e "\nWhat's your name?"
        read CUSTOMER_NAME

        # insert new customer
        INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
      fi

    # get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    #get appointment time
    echo -e "\nAt what time would you like your appointment?"
    read SERVICE_TIME

    # insert appointment
    INSERT_SERVICE_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    # get bike info
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/ |/"/')
        
    # send to main menu
    echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."

}

EXIT() {
  echo -e "\nThank you for stopping by.\n"
}

MAIN_MENU