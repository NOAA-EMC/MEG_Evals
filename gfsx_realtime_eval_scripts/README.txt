--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
Title:         GFSX_NCL
Contributors:  Shannon Shields (NOAA/NWS/NCEP/EMC)
Description:   Parallel GFS scripts for real-time model evaluation (specifically               for GFSv15 vs GFSv16 evaluation) used by the Model Eval. Group at               EMC
Created:       Oct. 5, 2021
Last Modified: Oct. 7, 2021
---------------------------------------------------------------------------------------------------------------------------------------------------------------- 
------------------------------------SET UP--------------------------------------

Scripts in this repository are designed to run on the WCOSS-Cray system (Surge/Luna).
For .bashrc, copy these lines into your ~/.bashrc:
export EDITOR=/usr/bin/vim

module swap craype-haswell craype-sandybridge
module load craype/2.3.0
module load PrgEnv-intel/5.2.82
module load hpss/4.1.0.3
module load cray-mpich/7.2.0
module load NetCDF-gnu-sandybridge/4.2
module load NCL-gnu-sandybridge/6.3.0
module load cfp-intel-sandybridge/2.0.1

Copy these lines into your ~/.profile:
# .profile

PATH=$PATH:$HOME/bin:.
export PATH

ENV=$HOME/.bashrc
export ENV

In your .ssh/known_hosts file, you will need to set up host names, keys, addresses, etc. such as:
emcrzdm.ncep.noaa.gov ssh-rsa
vxfer.ncep.noaa.gov (or mxfer.ncep.noaa.gov)
venus (or mars)

Source your updated .bashrc on the command line:
source ~/.bashrc
.profile and known_hosts will be sourced within the scripts when they run.

--------------------------------------------------------------------------------

To retrieve the GFSX real-time parallel scripts:
git clone https://github.com/NOAA-EMC/MEG_Evals.git
in your /gpfs/dell2/emc/verification/save/ directory
The scripts retrieve operational and parallel GFS forecast data from forecast hr 0 to forecast hr 240 every 3 hrs, and generate comparison graphics.

You will also need to copy the NCL package in your /save/ directory:
cp -r /usrx/local/prod/packages/gnu/4.8.5/ncl/6.4.0/* .

--------------------------------------------------------------------------------

--------------------------------THE GFSX SCRIPTS--------------------------------

drivecopyfiles_gfsx: Retrieves current date info, makes real-time data directory, and runs copy_files or copy_files_nco (depending on relevant para data path)
Need to change directory paths to match yours (change name).

copy_files: Copies GFS para forecast files from Venus/Mars EMC directory to Surge/Luna real-time data directory
Need to change name of directory paths to match yours.
Need to change vxfer.ncep.noaa.gov to mxfer.ncep.noaa.gov if on Mars/Luna and vice versa, and make sure para forecast file path is correct.

copy_files_nco: Copies GFS para forecast files from Venus/Mars NCO directory to Surge/Luna real-time data directory
Need to change name of directory paths to match yours.
Need to change vxfer.ncep.noaa.gov to mxfer.ncep.noaa.gov if on Mars/Luna and vice versa, and make sure para forecast file path is correct.

copy_files_interactive: Manual method (via command line) to copy GFS para forecast files from Venus/Mars directory to Surge/Luna real-time data directory (this is used when there is an outage and need to go back to retrieve data)
Need to change name of directory paths to match yours.
Need to change venus to mars if on Mars/Luna and vice versa, and make sure para forecast file path is correct.

drive_gfsx: Retrieves current date info and runs run_gfsx
Need to change name of directory paths to match yours.

run_gfsx: Submits launchgfsximages scripts to a poescript to generate graphics for all parameters contained within the launchgfsximages scripts, runs edit_gfsximages.ksh to edit the gfsximages.html file, and runs run_ftp_gfsx
Need to change name of directory paths to match yours.

launchgfsximages: Runs 250-hPa wind, 2m dewpoint, 2m temp, 500-hPa geopotential height, 3hr precip, instantaneous snow depth, 24hr water equivalent accum. snow depth, 1km reflectivity, composite reflectivity, low cloud cover avg, inst. low cloud cover, and PBL height NCL scripts for North America domain
Need to change name of directory paths to match yours.

launchgfsximages2: Runs 850-hPa wind, surface-based CAPE, total cloud cover avg,inst. total cloud cover, 24hr precip, SLP, sfc wind gust, middle cloud cover avg, inst. middle cloud cover, cloud ceiling height, and sfc temp NCL scripts for North America domain
Need to change name of directory paths to match yours.

launchgfsximages3: Runs 10m wind, 850-hPa temp, precip type, precipitable water,wind shear, sfc visibility, high cloud cover avg, inst. high cloud cover, 0-10 cm soil temp, 0-10 cm soil moisture, and total precip NCL scripts for North America domain
Need to change name of directory paths to match yours.

launchgfsximages4: Runs 250-hPa wind, 2m dewpoint, 2m temp, 500-hPa geopotentialheight, 3hr precip, instantaneous snow depth, 24hr water equivalent accum. snow depth, 1km reflectivity, composite reflectivity, low cloud cover avg, inst. low cloud cover, and PBL height NCL scripts for Alaska domain
Need to change name of directory paths to match yours. 

launchgfsximages5: Runs 850-hPa wind, surface-based CAPE, total cloud cover avg,inst. total cloud cover, 24hr precip, SLP, sfc wind gust, middle cloud cover avg, inst. middle cloud cover, cloud ceiling height, and sfc temp NCL scripts for Alaska domain
Need to change name of directory paths to match yours.

launchgfsximages6: Runs 10m wind, 850-hPa temp, precip type, precipitable water,wind shear, sfc visibility, high cloud cover avg, inst. high cloud cover, 0-10 cm soil temp, 0-10 cm soil moisture, and total precip NCL scripts for Alaska domain
Need to change name of directory paths to match yours.

launchgfsximages7: Runs 250-hPa wind, 2m dewpoint, 2m temp, 500-hPa geopotentialheight, 3hr precip, instantaneous snow depth, 24hr water equivalent accum. snow depth, 1km reflectivity, composite reflectivity, low cloud cover avg, inst. low cloud cover, and PBL height NCL scripts for CONUS domain
Need to change name of directory paths to match yours.

launchgfsximages8: Runs 850-hPa wind, surface-based CAPE, total cloud cover avg,inst. total cloud cover, 24hr precip, SLP, sfc wind gust, middle cloud cover avg, inst. middle cloud cover, cloud ceiling height, and sfc temp NCL scripts for CONUS domain
Need to change name of directory paths to match yours.

launchgfsximages9: Runs 10m wind, 850-hPa temp, precip type, precipitable water,wind shear, sfc visibility, high cloud cover avg, inst. high cloud cover, 0-10 cm soil temp, 0-10 cm soil moisture, and total precip NCL scripts for CONUS domain
Need to change name of directory paths to match yours.

launchgfsximages10: Runs 250-hPa wind, 2m dewpoint, 2m temp, 500-hPa geopotential height, 3hr precip, instantaneous snow depth, 24hr water equivalent accum. snow depth, 1km reflectivity, composite reflectivity, low cloud cover avg, inst. low cloud cover, and PBL height NCL scripts for Pacific domain
Need to change name of directory paths to match yours.

launchgfsximages11: Runs 850-hPa wind, surface-based CAPE, total cloud cover avg, inst. total cloud cover, 24hr precip, SLP, sfc wind gust, middle cloud cover avg, inst. middle cloud cover, cloud ceiling height, and sfc temp NCL scripts forPacific domain
Need to change name of directory paths to match yours.

launchgfsximages12: Runs 10m wind, 850-hPa temp, precip type, precipitable water, wind shear, sfc visibility, high cloud cover avg, inst. high cloud cover, 0-10cm soil temp, 0-10 cm soil moisture, and total precip NCL scripts for Pacific domain
Need to change name of directory paths to match yours.

launchgfsximages13: Runs 250-hPa wind, 2m dewpoint, 2m temp, 500-hPa geopotential height, 3hr precip, instantaneous snow depth, 24hr water equivalent accum. snow depth, 1km reflectivity, composite reflectivity, low cloud cover avg, inst. low cloud cover, and PBL height NCL scripts for West Atlantic domain
Need to change name of directory paths to match yours.

launchgfsximages14: Runs 850-hPa wind, surface-based CAPE, total cloud cover avg, inst. total cloud cover, 24hr precip, SLP, sfc wind gust, middle cloud cover avg, inst. middle cloud cover, cloud ceiling height, and sfc temp NCL scripts forWest Atlantic domain
Need to change name of directory paths to match yours.

launchgfsximages15: Runs 10m wind, 850-hPa temp, precip type, precipitable water, wind shear, sfc visibility, high cloud cover avg, inst. high cloud cover, 0-10cm soil temp, 0-10 cm soil moisture, and total precip NCL scripts for West Atlantic domain
Need to change name of directory paths to match yours.

For all of the plot_gfsxlambert*.ncl scripts, confirm the GFS prod directory andchange the GFS para directory to match yours.

gfsximages.html: Sets up the rzdm website (along with panel5.css) with text, graphics, and dropdown menus
No changes needed unless you want to edit text, domains, and/or parameters.
Need to confirm NOAA-Transparent-Logo_1.png, ncep_logo.gif, and us.gif are within your rzdm directory.

edit_gfsximages.ksh: Edits gfsximages.html file to update current date and time of cycle run 
Need to change profile path and if lines are changed in gfsximages.html, then confirm line number of var initdate in gfsximages.html (currently #201)

run_ftp_gfsx: Creates date directory based on current cycle run and transfers all .png images for each domain, as well as gfsximages.html, over to rzdm to populate website
Need to change name of directory paths to match yours.

--------------------------------------------------------------------------------

---------------------------HOW TO RUN GFSX SCRIPTS------------------------------

If you need to manually retrieve the parallel GFS data, first change the date and time in holddate.txt to the initialization cycle you want in YYYYMMDDHH format. Then run copy_files_interactive on the command line:
./copy_files_interactive
Then make changes to drive_gfsx:
Comment out #/bin/date +%Y%m%d${cyc}%a > holddate.txt
Uncomment cd /gpfs/hps3/stmp/Shannon.Shields/gfsx.20210303/${cyc} and change to your directory and date
Comment out #cd /gpfs/hps3/stmp/Shannon.Shields/gfsx.${ymd}/${cyc}
Run drive_gfsx on the command line with the cycle hour such as:
./drive_gfsx 00 (for 00Z cycle)

Otherwise, set up a cron job by typing crontab -e on the command line and entering lines such as:
00 06 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drivecopyfiles_gfsx 00 >& ~/drivecopyfiles_gfsx00.log
00 11 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drivecopyfiles_gfsx 06 >& ~/drivecopyfiles_gfsx06.log
00 17 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drivecopyfiles_gfsx 12 >& ~/drivecopyfiles_gfsx12.log
00 23 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drivecopyfiles_gfsx 18 >& ~/drivecopyfiles_gfsx18.log


30 06 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drive_gfsx 00 >& ~/drive_gfsx00.log
30 11 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drive_gfsx 06 >& ~/drive_gfsx06.log
30 17 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drive_gfsx 12 >& ~/drive_gfsx12.log
30 23 * * * /gpfs/dell2/emc/verification/save/Shannon.Shields/gfsv16/drive_gfsx 18 >& ~/drive_gfsx18.log

Setting the job run times will depend on when the parallel GFS data is available. Allow 30 mins for data to transfer. Generating all the graphics for each parameter, domain, and forecast hour will take a while. Once done, check the website (https://www.emc.ncep.noaa.gov/users/meg/gfsv16/realtime/gfsximages.html) to make sure everything looks correct/was loaded properly.
