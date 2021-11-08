#!/bin/ksh
## ============================================================================
## Edit gfsximages.html
## Description: Updates HTML file with current date and cycle run
## Contributors: Shannon Shields (NOAA/NWS/NCEP/EMC)
## Last Modified: Oct. 14, 2021
## ============================================================================

source /u/Shannon.Shields/.profile
cyc=`cut -c 9-10 holddate.txt`
year=`cut -c 1-4 holddate.txt`
month=`cut -c 5-6 holddate.txt`
daydate=`cut -c 7-8 holddate.txt`


sed '201s/[0-9]\+/'${year}${month}${daydate}${cyc}'/' gfsximages.html > tmpfile

mv tmpfile gfsximages.html
  

exit
