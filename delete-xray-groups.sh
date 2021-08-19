#!/bin/bash

aws xray delete-group --group-name Home
aws xray delete-group --group-name PetSearch
aws xray delete-group --group-name TakeMeHome
aws xray delete-group --group-name MakePayment
aws xray delete-group --group-name ListAdoptions
aws xray delete-group --group-name Housekeeping
