; ============================================================================
; Generate 250-hPa Wind Images
; Description: Generates GFS comparison images for 250-hPa winds
; Contributors: Shannon Shields (NOAA/NWS/NCEP/EMC)
; Last Modified: Oct. 14, 2021
; ============================================================================

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
  ; Pre-defined domain definitions
  minlatlist=(/15.0,35.0,25.0,31.0,40.0,25.5,35.0,42.0,41.0,34.0,40.0,34.0,24.5,12.5,10,20,1,-40,15,9/)
  maxlatlist=(/60.0,75.0,50.0,43.0,50.0,37.5,44.0,50.0,49.5,43.0,48.0,42.5,35.0,35,27,47.5,60,-1,62.5,35/)
  minlonlist=(/-135.0,160.0,-120,-125.0,-125.0,-108.0,-108.0,-110.0,-97.0,-97.0,-81.0,-86.0,-92.0,-105,-81,-95,110,137.5,-167.5,-100/)
  maxlonlist=(/-60.0,250.0,-72.5,-105.0,-107.0,-90.0,-92.0,-95.0,-80.5,-83.0,-66.5,-72.0,-76.0,-72.5,-55,-57.5,179,192.5,-115,-50/)
  regionlist=(/"us","ak","uszoom","sw","nw","t","cp","np","mw","ov","ne","ma","se","gom","pr","nwatl","wpac","spac","epac","watl"/)
  ;scriptregion="ak"
  ;scriptyyyymmddhh="2017101900"
  inc=240
  three=1
  do c=0,dimsizes(regionlist)-1
    if (regionlist(c).eq.scriptregion) then
      minlat=minlatlist(c)
      minlon=minlonlist(c)
      maxlat=maxlatlist(c)
      maxlon=maxlonlist(c)
    end if
  end do
  
  scriptyear=toint(str_get_cols(scriptyyyymmddhh,0,3))
  scriptmonth=toint(str_get_cols(scriptyyyymmddhh,4,5))
  scriptday=toint(str_get_cols(scriptyyyymmddhh,6,7))
  scripthour=toint(str_get_cols(scriptyyyymmddhh,8,9))
  timeunits="hours since 1800-01-01 00:00"
  datemodel=cd_inv_calendar(scriptyear,scriptmonth,scriptday,scripthour,0,0,timeunits,0)
  datestart=cd_inv_calendar(scriptyear,scriptmonth,scriptday,scripthour,0,0,timeunits,0)

  enddate1=datestart+inc
  enddate1@units=timeunits
  endints=cd_calendar(enddate1,0)
  
  dateend=cd_inv_calendar(toint(endints(:,0)),toint(endints(:,1)),toint(endints(:,2)),toint(endints(:,3)),0,0,timeunits,0)
  datemodel@units=timeunits
  fdates=ispan(toint(datestart),toint(dateend),3)
  fhours=ispan(toint(datestart)-toint(datemodel),toint(dateend)-toint(datemodel),3)

  do h=0,dimsizes(fdates)-1
    ;print((/fhours(h)/))
    thisdate=fdates(h)
    thisdate@units=timeunits
    modelstrings=tostring(cd_calendar(thisdate,-3))
    ms=tostring(cd_calendar(datemodel,-3))
    ;Model init. date
    yearm=str_get_cols(ms,0,3)
    monthm=str_get_cols(ms,4,5)
    daym=str_get_cols(ms,6,7)
    hourm=str_get_cols(ms,8,9)
    mdhm=str_get_cols(ms,4,9)
    ymdm=str_get_cols(ms,0,7)
    ;Valid date
    year=str_get_cols(modelstrings,0,3)
    month=str_get_cols(modelstrings,4,5)
    day=str_get_cols(modelstrings,6,7)
    hour=str_get_cols(modelstrings,8,9)
    mdh=str_get_cols(modelstrings,4,9)
    ymd=str_get_cols(modelstrings,0,7)
    monthind=toint(month)
    months=(/"","January","February","March","April","May","June","July","August","September","October","November","December"/)
    prod=addfile("/gpfs/dell1/nco/ops/com/gfs/prod/gfs."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2","r")
    para=addfile("/gpfs/hps3/stmp/Shannon.Shields/gfsx."+ymdm+"/"+hourm+"/gfs.t"+hourm+"z.pgrb2.0p25.f"+sprinti("%0.3i",fhours(h))+".grib2","r")

   ; print(prod)
      vnames:=getfilevarnames(prod)
   uprod=prod->UGRD_P0_L100_GLL0({25000},:,:)
   upara=para->UGRD_P0_L100_GLL0({25000},:,:)
   vprod=prod->VGRD_P0_L100_GLL0({25000},:,:)
   vpara=para->VGRD_P0_L100_GLL0({25000},:,:)
   uprod=uprod*1.94
   upara=upara*1.94
   vprod=vprod*1.94
   vpara=vpara*1.94
   magprod=uprod
   magpara=upara
   magprod=(uprod^2+vprod^2)^.5
   magpara=(upara^2+vpara^2)^.5

   dif=magprod
   dif=magpara-magprod

  
  wks  = gsn_open_wks("png","gfsx_"+scriptregion+"_250wind_"+ms+"_"+sprinti("%0.2i",(h+1)))                 ; open a png file
    
  gsn_define_colormap(wks,"jetu")  

  plot=new(3,"graphic")

  res  = True
  if scriptregion.eq."pac"
    minlon = 124.0
    maxlon = -124.0
    minlat = -35.0
    maxlat = 60.0
    maxlon = maxlon+360.0
  end if
  res@mpMinLatF                = minlat
  res@mpMaxLatF                =  maxlat
  res@mpMinLonF                = minlon
  res@mpMaxLonF                = maxlon
  ;res@mpOutlineBoundarySets="AllBoundaries"
  res@mpOutlineBoundarySets="GeophysicalAndUSStates"
  res@mpDataBaseVersion="MediumRes"
  res@gsnMaximize=True
  res@tmXBLabelFontHeightF=.008
  res@tmYLLabelFontHeightF=.008
  res@gsnRightString="250-hPa wind (kt)"
  res@gsnAddCyclic=False
  res@gsnLeftString="GFSv15 initialized "+hourm+"Z "+daym+" "+months(toint(monthm))+ " " +yearm+" valid "+hour+"Z "+day+ " "+months(monthind)+ " " +year+ " (F"+sprinti("%0.2i",fhours(h))+")"
  res@mpOutlineDrawOrder="PostDraw"
  res@mpFillColor="grey75"
  res@cnInfoLabelOn=False
  res@mpFillDrawOrder="PreDraw"
  res@cnLabelMasking=True
  res@mpGeophysicalLineColor="black"
  res@mpGeophysicalLineThicknessF=2.0
  res@mpNationalLineThicknessF=2.0
  ;res@cnFillMode="RasterFill"
  ;res@cnRasterSmoothingOn=True
  res@mpUSStateLineThicknessF=1.0
  res@mpCountyLineThicknessF=.5
  ;res@mpUSStateLineThicknessF=3.0
  res@mpNationalLineColor="black"
  res@mpUSStateLineColor="black"
  res@cnLineLabelsOn=False
  res@pmLabelBarHeightF=.05
  res@lbLabelFontHeightF=.008
  res@gsnLeftStringFontHeightF=.01
  res@gsnRightStringFontHeightF=.01
  res@cnFillOn=True
  res@mpFillOn=True
  res@cnFillColors(0)=-1
  res@cnFillMode="RasterFill"
  res@cnRasterSmoothingOn=True
  res@cnLevelSelectionMode="ExplicitLevels"
  res@cnLevels=ispan(40,200,20)
  res@cnLinesOn=False
  res@mpLimitMode="LatLon"
  res@gsnDraw=False
  res@mpProjection="LambertConformal"
  res@mpLambertParallel1F = 33.0         ; two parallels
  res@mpLambertParallel2F = 45.0
  res@mpLambertMeridianF  = -95.0        ; central meridian
  if scriptregion.eq."ak" then
    res@mpLambertMeridianF  = 215.0        ; central meridian
  end if
  ;res@lbLabelStride=1
  res@cnLinesOn=False
  res@lbLabelAutoStride=True
  res@gsnFrame=False
   res@lbLabelBarOn=True
  if scriptregion.eq."us" then
    res@mpNationalLineThicknessF=2.0
    res@mpGeophysicalLineThicknessF=2.0
  end if


  res@cnLineLabelInterval=1
  res@cnLineLabelDensityF=1.5
  if scriptregion.eq."pac" then
    res@mpProjection="Mercator"
    res@mpGridAndLimbOn = True
    res@pmTickMarkDisplayMode = "Always"
    res@mpCenterLonF = 180.0
  end if
  
  plot(0) = gsn_csm_contour_map(wks,magprod,res)       ; create a default plot
  if scriptregion.eq."pac" then
    ;create domain box that Pacific Region requested
    ypts = (/30.0,  30.0,  -25.0,   -25.0, 30.0/)
    xpts = (/130.0, 220.0, 220.0, 130.0, 130.0/)
    ;add the box
    resp = True
    resp@gsLineColor = "black"
    resp@gsLineThicknessF = 4.0
    ;create array of dummy graphic variables
    dum = new(4,graphic)
    ;draw each line separately
      do i = 0,3
         dum(i)=gsn_add_polyline(wks,plot(0),xpts(i:i+1),ypts(i:i+1),resp)
      end do
  end if
   

  wres=True
  wres@vcRefMagnitudeF=10.0
  wres@gsnLeftString=""
  ;wres@vcVectorDrawOrder="PostDraw"
  wres@gsnRightString=""
  wres@gsnDraw=False
  wres@gsnFrame=False
  wres@vcRefLengthF=.035
  wres@vcMinDistanceF=.045
  wres@vcGlyphStyle="WindBarb"
  wres@vcWindBarbLineThicknessF=2.0
  wres@vcMonoWindBarbColor=True
  wres@vcWindBarbColor="black"
  ;wres@vcLineArrowColor="black"
  ;wres@vcWindBarbTickLengthF=.4
  wres@vcRefAnnoOn=False
  ;print("plotting wind")
  ;if scriptregion.eq."us" then
    wres@vcRefLengthF=.025
    wres@vcWindBarbLineThicknessF=2.0
    wres@vcMinDistanceF=.03
  ;end if

  wres2=True
  wres2=wres
  wres2@vcWindBarbLineThicknessF=5
  wres2@vcWindBarbColor="white"
  if scriptregion.eq."us" then
    wres2@vcWindBarbLineThicknessF=5
  end if
  plot_windprod2=gsn_csm_vector(wks,uprod,vprod,wres2)

  plot_windprod=gsn_csm_vector(wks,uprod,vprod,wres)
  plot_windpara2=gsn_csm_vector(wks,upara,vpara,wres2)

  plot_windpara=gsn_csm_vector(wks,upara,vpara,wres)






  res@gsnLeftString="GFSv16 initialized "+hourm+"Z "+daym+" "+months(toint(monthm))+ " " +yearm+" valid "+hour+"Z "+day+ " "+months(monthind)+ " " +year+ " (F"+sprinti("%0.2i",fhours(h))+")"
  plot(1) = gsn_csm_contour_map(wks,magpara,res)       ; create a default plot
  if scriptregion.eq."pac" then
    ;create domain box that Pacific Region requested
    ypts = (/30.0,  30.0,  -25.0,   -25.0, 30.0/)
    xpts = (/130.0, 220.0, 220.0, 130.0, 130.0/)
    ;add the box
    resp = True
    resp@gsLineColor = "black"
    resp@gsLineThicknessF = 4.0
    ;create array of dummy graphic variables
    dumm = new(4,graphic)
    ;draw each line separately
      do i = 0,3
         dumm(i)=gsn_add_polyline(wks,plot(1),xpts(i:i+1),ypts(i:i+1),resp)
      end do
  end if 
  resdif=True
  resdif=res
  delete(resdif@cnFillColors)
  resdif@cnFillPalette=("BlueWhiteOrangeRed")
  resdif@cnLevels:=fspan(-50,50,11)
  resdif@gsnLeftString="GFSv16 minus GFSv15 valid "+hour+"Z "+day+ " "+months(monthind)+ " " +year+ " (F"+sprinti("%0.2i",fhours(h))+")"
  plot(2) = gsn_csm_contour_map(wks,dif,resdif)       ; create a default plot
  if scriptregion.eq."pac" then
    ;create domain box that Pacific Region requested
    ypts = (/30.0,  30.0,  -25.0,   -25.0, 30.0/)
    xpts = (/130.0, 220.0, 220.0, 130.0, 130.0/)
    ;add the box
    resp = True
    resp@gsLineColor = "black"
    resp@gsLineThicknessF = 4.0
    ;create array of dummy graphic variables
    dummm = new(4,graphic)
    ;draw each line separately
      do i = 0,3
         dummm(i)=gsn_add_polyline(wks,plot(2),xpts(i:i+1),ypts(i:i+1),resp)
      end do
  end if
  resP=True
  resP@gsnMaximize=True
  resP@txFontHeightF=.012
  resP@gsnPanelLabelBar=False
  resP@gsnFrame=False
  overlay(plot(0),plot_windprod2)
  overlay(plot(0),plot_windprod)
  overlay(plot(1),plot_windpara2)
  overlay(plot(1),plot_windpara)
  gsn_panel(wks,plot,(/2,2/),resP)
 
print("drawing")
;draw(plot)
print("framing")
frame(wks)
print("deleting")
delete(wks)
;print(h)
;print(max(dif))
system("convert -trim +repage gfsx_"+scriptregion+"_250wind_"+ms+"_"+sprinti("%0.2i",(h+1))+".png -trim +repage gfsx_"+scriptregion+"_250wind_"+ms+"_"+sprinti("%0.2i",(h+1))+".png")                 ; open a png file
end do
end



