#!/bin/bash

# Grafana API Auth token
token= xxxx_xxxx_xxx

# Grafana API Url Path
grafanaurl= http://xxx.xxx:3000/api

# DIRECTORY CHECK
PARENT_DIR=export
DASH_DIR=dashboard
DS_DIR=datasources

rm -rf $PARENT_DIR
mkdir -p $PARENT_DIR
mkdir $PARENT_DIR/$DASH_DIR $PARENT_DIR/$DS_DIR

# EXPORT DATASOURCE
datasources=$(curl -s -H "Authorization: Bearer $token" -X GET $grafanaurl/datasources)
for uid in $(echo $datasources | jq -r '.[] | .uid'); do
  uid="${uid/$'\r'/}" # remove the trailing '/r'
  curl -s -H "Authorization: Bearer $token" -X GET "$grafanaurl/datasources/uid/$uid" | jq > grafana-datasource-$uid.json
  slug=$(cat grafana-datasource-$uid.json | jq -r '.name')
  mv grafana-datasource-$uid.json $PARENT_DIR/$DS_DIR/grafana-datasource-$uid-$slug.json # rename with datasource name and id
  echo "Datasource $uid exported"
done

# EXPORT DASHBOARD
dashboards=$(curl -s -H "Authorization: Bearer $token" -X GET $grafanaurl/search?folderIds=0&query=&starred=false)
for uid in $(echo $dashboards | jq -r '.[] | .uid'); do
  uid="${uid/$'\r'/}" # remove the trailing '/r'
  curl -s -H "Authorization: Bearer $token" -X GET "$grafanaurl/dashboards/uid/$uid" | jq > grafana-dashboard-$uid.json
  slug=$(cat grafana-dashboard-$uid.json | jq -r '.meta.slug')
  mv grafana-dashboard-$uid.json $PARENT_DIR/$DASH_DIR/grafana-dashboard-$uid-$slug.json # rename with dashboard name and id
  echo "Dashboard $uid exported"
done

