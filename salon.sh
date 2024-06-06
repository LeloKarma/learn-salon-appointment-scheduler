#! /bin/bash

# Display list of services
echo "Services offered:"
psql -U freecodecamp -d salon -c "SELECT CONCAT(service_id, ') ', name) FROM services;"

# Prompt for service selection
read -p "Enter the service ID: " SERVICE_ID_SELECTED

# Check if service ID exists
while [ $(psql -U freecodecamp -d salon -tAc "SELECT COUNT(*) FROM services WHERE service_id=$SERVICE_ID_SELECTED;") -eq 0 ]; do
    echo "Invalid service ID. Please select from the list of services."
    read -p "Enter the service ID: " SERVICE_ID_SELECTED
done

# Prompt for customer phone number
read -p "Enter customer's phone number: " CUSTOMER_PHONE

# Check if customer already exists
CUSTOMER_EXISTS=$(psql -U your_username -d your_database_name -tAc "SELECT COUNT(*) FROM customers WHERE phone='$CUSTOMER_PHONE';")
if [ $CUSTOMER_EXISTS -eq 0 ]; then
    read -p "Enter customer's name: " CUSTOMER_NAME
    # Insert new customer into customers table
    psql -U your_username -d your_database_name -c "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE');"
fi

# Prompt for appointment time
read -p "Enter appointment time: " SERVICE_TIME

# Insert appointment into appointments table
psql -U your_username -d your_database_name -c "INSERT INTO appointments (customer_id, service_id, time) VALUES ((SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'), $SERVICE_ID_SELECTED, '$SERVICE_TIME');"

# Output confirmation message
CUSTOMER_NAME=$(psql -U your_username -d your_database_name -tAc "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
SERVICE_NAME=$(psql -U your_username -d your_database_name -tAc "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

