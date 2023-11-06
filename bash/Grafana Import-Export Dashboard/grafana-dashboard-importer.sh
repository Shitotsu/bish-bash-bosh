#!/bin/bash

# DESTINATION VARIABLESt
token=xxxxxx # Grafana API Auth Token
grafanaurl=http://xxx.xxx.xxx.xxx:3000/api # Grafana API Url

DIR=export # Json Location
DIR_DASH=$DIR/dashboard
DIR_DS=$DIR/datastores

# IMPORT DASHBOARD
for FILE in $DIR_DASH/*dashboard*; do
  echo Importing Dashboard: $FILE
  cat $FILE | jq '. * {overwrite: true, dashboard: {id: null}}' | curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $token" "$grafanaurl/dashboards/db" -d @- ;
done

# IMPORT DATASOURCE
for FILE in $DIR_DS/*datasource*; do
  echo Importing Dashboard: $FILE
  cat $FILE | curl -X POST -H "Content-Type: application/json" -H "Authorization: Bearer $token" "$grafanaurl/datasources/" -d @- ;
done
