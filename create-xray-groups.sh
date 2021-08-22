#!/bin/bash

aws xray create-group \
  --group-name Home \
  --filter-expression "http.url ENDSWITH \"/\" AND !(http.url ENDSWITH \"/housekeeping/\" OR http.url ENDSWITH \"/PetListAdoptions\") AND http.method = \"GET\" AND service(\"PetSite\")" \
  --insights-configuration "InsightsEnabled=true,NotificationsEnabled=true"

aws xray create-group \
  --group-name PetSearch \
  --filter-expression "http.url CONTAINS \"selectedPetType\" AND http.url CONTAINS \"selectedPetColor\" AND http.method = \"GET\" AND service(\"PetSite\")" \
  --insights-configuration "InsightsEnabled=true,NotificationsEnabled=true"

aws xray create-group \
  --group-name TakeMeHome \
  --filter-expression "http.url ENDSWITH \"/adoption/takemehome\" AND http.method = \"POST\" AND service(\"PetSite\")" \
  --insights-configuration "InsightsEnabled=true,NotificationsEnabled=true"

aws xray create-group \
  --group-name MakePayment \
  --filter-expression "http.url ENDSWITH \"/Payment/MakePayment\" AND http.method = \"POST\" AND service(\"PetSite\")" \
  --insights-configuration "InsightsEnabled=true,NotificationsEnabled=true"

aws xray create-group \
  --group-name ListAdoptions \
  --filter-expression "http.url ENDSWITH \"/PetListAdoptions\" AND http.method = \"GET\" AND service(\"PetSite\")" \
  --insights-configuration "InsightsEnabled=true,NotificationsEnabled=true"

aws xray create-group \
  --group-name Housekeeping \
  --filter-expression "http.url ENDSWITH \"/housekeeping/\" AND http.method = \"GET\" AND service(\"PetSite\")" \
  --insights-configuration "InsightsEnabled=true,NotificationsEnabled=true"
