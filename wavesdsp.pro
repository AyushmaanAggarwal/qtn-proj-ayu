
                  WAVESDSP.PRO

;NSSDC has successfully run this code, by invoking the MACX window. 
; The few lines following line # 170 have been modified,
; to reflect the exact name of the data file; make sure the exact names
; you gave reside around lines 170-173 of this code.
; Also, the reference to "gsfc_color" in line # 217 has been changed to
; "13". After entering the timespan, etc, when the X-window will pops up,
; be sure to highlight "Screen DS" in the minipanel to plot spectra. 
; r.parthasarathy, 15 oct 99.

; Modified version of MLK's wavesdsp.pro [RJM calls this version 1.1]
; Original  Jan. 1997
; Minor correction to DOY labelling Feb. 1997
; Minor correction to correct filename construction Mar 31, 1997
; Minor correction to fix long plots April 29, 1997
; Addition of log scales for rads May 16, 1997
; Fix of tnr intensities (x2 error --> 20 log not 10 log) June 4, 1997
; Fix fractional hour plots bug  June 24, 1997  [RJM calls this version 1.2]
; Added capability to plot single time series a la RAR.  1/25/98 RJM 
; Version 2.0:  Modified to use CASE statement, added RJM stuff.   1/26/98 RJM
; Version 2.01: Corrected up/low freq limits when < full range.    1/30/98 RJM
; Version 2.02:  Removed some of MacDowall's modifications                 MLK
; Version 3.0:  New rad formats and new file names                 8/17/98 MLK
; Version 3.01  Fix screen color problems                          8/21/98 MLK
; Version 3.02  Fix tnr fixed frequency plot bug                   9/01/98 MLK
; Note: Users at other locations will need to edit the directory names of the
; data files below (search for CHANGE).  Also, you may want to change the
; color tables used.  If so uncomment (remove the leading ;) and assign
; values to the next 2 variables.  GSFC_COLOR is for the monitor, IOWA_COLOR
; is for the color printer.
; gsfc_color =
; iowa_color =

set_plot,'x'
window,xsize=1150
erase
resetfig ; these ensure that I don't have stuff setfrom another program.  RJM
resetidl

not_open1 = "TRUE"
not_open2 = "TRUE"
sub_interval = "FALSE"
plot_type = "dynamic_spec"

start:
rcvr=' '
read,' Enter rcvr name rad1, rad2, or tnr: ', rcvr
rcvr = strlowcase(rcvr)
case rcvr of
'rad1':	begin
flow=20
fhigh=1040
fspace=4.
funit='kHz'
linlog=0
	end
'rad2':	begin
flow=1.075
fhigh=13.825
fspace=.050
funit='MHz'
linlog=0
	end
'tnr':	begin
flow=4.
fhigh=245.146
fspace=.188144e-1
funit='kHz'
linlog=1
	end
endcase
; start:
ymd=0l
hms=0l
yymmdd1=0l
read,' Enter start YYYYMMDD: ',yymmdd1
if(yymmdd1 gt 19000000l) then goto, yearok
print,' Must enter 4 digit year'
goto,exit
yearok:
hour1=' '
read,' Enter start time in hours [0]: ',hour1
if (hour1 eq '') then begin
hour1=0.
endif else begin
hour1=float(hour1)
endelse
oyymmdd1 = yymmdd1
ohour1 = hour1
hour1_start = hour1
yymmdd2=' '
print, ' Enter stop YYYYMMDD [' + strtrim(yymmdd1,2) + ']: '
read, yymmdd2
if (yymmdd2 eq '') then begin
yymmdd2=yymmdd1
endif else begin
yymmdd2 = long(yymmdd2)
endelse
oyymmdd2 = yymmdd2
hour2=' '
read,' Enter stop time in hours [24]: ',hour2
if (hour2 eq '') then begin
hour2=24.
endif else begin
hour2=float(hour2)
endelse
fhz1=' '
fhz2=' '
print,' Enter low frequency in ',funit,' [',flow,']: '
read,fhz1
print,' Enter high frequency in ',funit,' [',fhigh,']: '
read,fhz2
if(fhz1 eq '') then begin
fhz1=flow
endif else begin
fhz1=float(fhz1)
endelse
if(fhz2 eq '') then begin
fhz2=fhigh
endif else begin
fhz2=float(fhz2)
endelse
if(rcvr eq 'tnr') then begin
chan1=fix((alog10(fhz1)-alog10(flow))/fspace)+1
chan2=fix((alog10(fhz2)-alog10(flow))/fspace)+1
fhz1=alog10(flow)+chan1*fspace
fhz2=alog10(flow)+chan2*fspace
endif else begin
chan1=fix((fhz1-flow)/fspace)
chan2=fix((fhz2-flow)/fspace)
fhz1=flow+chan1*fspace
fhz2=flow+chan2*fspace
endelse
ydim=(chan2-chan1)+1
av_interval=' '
read,' Enter averaging interval in minutes [1]: ',av_interval
if(av_interval eq '') then begin
av_interval=60
endif else begin
av_interval=fix(av_interval)*60
endelse
print, " collecting data ..."
redo_interval:
; ih1=fix(hour1)*10000l  changed 9/17/97
; ih2=fix(hour2)*10000l
ih1=(fix(hour1*60.)+(fix(hour1*60.)/60l)*40l)*100l
ih2=(fix(hour2*60.)+(fix(hour2*60.)/60l)*40l)*100l
iday=0l
isec=0l
doy1=0l
diff,(yymmdd1/10000l)*10000l+100l,0l,yymmdd1,0l,doy1,isec
if(hour1 gt 0.) then doy1=doy1+1
odoy1 = doy1
diff,yymmdd1,ih1,yymmdd2,ih2,iday,isec
xdim=fix((iday*86400+isec)/av_interval)
; read data
diff,yymmdd1,0l,yymmdd2,0l,iday,isec
; ind1=fix(hour1)*60  changed 9/17/97
; ind2=fix(hour2)*60-1+iday*1440
ind1=fix(hour1*60.)
ind2=fix(hour2*60.)-1+iday*1440
hold=fltarr(1440*(iday+1),ydim)
yymmdd=yymmdd1
for dayno=0,iday do begin
yymmdda=strtrim(string(yymmdd),1)
; CHANGE TO YOUR FILE NAMES HERE
;if (rcvr eq 'tnr') then file='/usr3/tnr/'+yymmdda+'.tnr'
;if (rcvr eq 'rad1') then file='/usr1/rad1/'+yymmdda+'.R1'
;if (rcvr eq 'rad2') then file='/usr2/rad2/'+yymmdda+'.R2'
; I CHANGED. rp, 14 oct 99
if (rcvr eq 'tnr') then file = string(yymmdd1) + '.tnr'
if (rcvr eq 'rad1') then file = string(yymmdd1) + '.R1'
if (rcvr eq 'rad2') then file = string(yymmdd1) + '.R2'
restore,filename=file
i1=dayno*1440l
i2=i1+1439l
hold(i1:i2,0:*)=arrayb(0:1439,chan1:chan2)
addymd,yymmdd,1l
endfor
; form array
array=rebin(hold(ind1:ind2,0:*),xdim,ydim)
lt1=where(array lt 1.)
; array(lt1)=1.   changed 9/17/97
; array=10.*alog10(array)
if(lt1(0) ne -1) then array(lt1)=1.
array=20.*alog10(array)

plot_data:
scale1=0.
scale2=10.
nticks=10
;******
if(yymmdd1 eq yymmdd2) then begin
  datefm,yymmdd1,date
  dates = date
endif else begin
  datefm,yymmdd1,date1
  datefm,yymmdd2,date2
  dates = date1+' to '+date2
endelse
hour=findgen(xdim+1)*av_interval/3600.+hour1
hour2=hour1+float(xdim)*av_interval/3600.
ohour2 = hour2 ; save for plotting subintervals
redo_labels:
hints=fix(hour2-hour1)
xlabel='GMT (HRS)'
if(hints gt 24) then begin
  htics=fix(float(hints)/12.+1.)
  if(htics eq 5) then htics=6
  if(htics gt 6) then htics=24
  midnoon=where((hour mod htics) eq 0)
  tickv=hour(midnoon)
  if(htics lt 24) then $
    hlabels=strtrim(string(fix(hour(midnoon)) mod 24),1) $
  else hlabels=strtrim(string(doy1+indgen(iday+2)),1)
  if(htics gt 6) then xlabel='DOY'
  ok=size(tickv)
  hints=ok(1)-1
endif else begin
  hrs=where((hour mod 1.) eq 0)
  tickv=hour(hrs)
  hlabels=strtrim(string(fix(hour(hrs)) mod 24),1)
  ok=size(tickv)
  hints=ok(1)-1
endelse
if (plot_type eq "time_series") then goto, plot_timeser
if (sub_interval eq "TRUE") then goto, replot
freqlo=findgen(ydim)*fspace+fhz1
if(rcvr eq 'tnr') then freqlo=10.^freqlo
set_plot,'x'
;loadct,gsfc_color;  THIS WAS THE ORIGINAL PI line. Doesn't work at NSSDC.
loadct,13
!p.background=255
!p.color=0
p_title = ' Wind Waves ' + strupcase(rcvr) + ' receiver: '+ dates
erase
main:
menu=['WAVES_DS MENU','Screen (DS)','Hardcopy (DS or TS)', $
'Zoom','New color scale','New Dates/Rcvr', $
'Plot sub-interval','Plot 1 time series', 'Quit']
choice = makemenu(menu) 
print, "Selection: ", menu(choice)
; ***** New Plot ************************************
case menu(choice) of
'Screen (DS)': begin
replot:
plot_type = "dynamic_spec"
sub_interval = "FALSE"
erase
ncolors=!d.n_colors
if(ncolors gt 255) then ncolors=255
colors=indgen(ncolors)
bar=intarr(ncolors,5)
for j=0,4 do begin
bar(*,j)=colors
endfor
contour,bar,position=[.2,.075,.8,.1],$
xrange=[scale1,scale2],xticks=nticks,$
xstyle=1,ystyle=4,$
xtitle='intensity (dB) relative to background',/nodata,/noerase
px=!x.window*!d.x_vsize
py=!y.window*!d.y_vsize
sx=px(1)-px(0)+1
sy=py(1)-py(0)+1
tv,poly_2d(byte(bar),[[0,0],[ncolors/sx,0]],[[0,5/sy],$
[0,0]],0,sx,sy),px(0),py(0)
contour,array,hour(0:xdim-1),freqlo,position=[.1,.2,.9,.9],$
/noerase,/nodata,xstyle=4,ystyle=4,ticklen=-.01,ytype=linlog
px=!x.window*!d.x_vsize
py=!y.window*!d.y_vsize
sx=px(1)-px(0)+1
sy=py(1)-py(0)+1
arrayb=bytscl(array,min=scale1,max=scale2,top=(!d.n_colors<256)-2)
tv,poly_2d(arrayb,$
[[0,0],[xdim/sx,0]],[[0,ydim/sy],$
[0,0]],0,sx,sy),px(0),py(0)
contour,array,hour(0:xdim-1),freqlo,position=[.1,.2,.9,.9],$
/noerase,/data,xstyle=1,ystyle=1,ytype=linlog,$
xtitle=xlabel,xticks=hints,xtickv=tickv,xtickname=hlabels,$
title=p_title,ytitle=funit,ticklen=-.01,/nodata
end
;***** Hardcopy ********************************************
'Hardcopy (DS or TS)': begin
jplt=wmenu(['HC MENU','B & W','Color','Cancel'],title=0,init=1)
if jplt eq 3 then goto, main
set_plot,'ps'
if jplt eq 1 then begin
device,/landscape,bits_per_pixel=8,scale_factor=1.
!p.background=0
!p.color=0
rev=255
endif else begin device,/color,/landscape,bits_per_pixel=8
loadct,iowa_color
!p.background=255
!p.color=0
rev=0
endelse
erase
if (plot_type eq "time_series") then goto, plot_timeser
colors=indgen(255)
bar=intarr(255,5)
for j=0,4 do begin
bar(*,j)=colors
endfor
bar2=rebin(bar,510,20)
contour,bar2,position=[.2,.075,.8,.10],$
xrange=[scale1,scale2],xticks=nticks,font=0,$
xstyle=1,ystyle=4,$
xtitle='intensity (dB) relative to background',/nodata,/noerase
tv,abs(rev-bar2),!x.window(0),!y.window(0),$
xsize=!x.window(1)-!x.window(0),ysize=!y.window(1)-!y.window(0),/norm
contour,array,hour(0:xdim-1),freqlo,position=[.15,.2,.85,.5],$
/nodata,/noerase,xstyle=4,ystyle=1,ytype=linlog,$
ytitle=funit,ticklen=-.01,xcharsize=.75,font=0
arrayb=bytscl(array,min=scale1,max=scale2,top=(!d.n_colors<256)-2)
tv,abs(rev-arrayb),!x.window(0),!y.window(0),$
xsize=!x.window(1)-!x.window(0),ysize=!y.window(1)-!y.window(0),$
/norm
contour,arrayb,hour(0:xdim-1),freqlo,position=[.15,.2,.85,.5],$
/noerase,/nodata,xstyle=1,ystyle=4,xtickv=tickv,$
xtitle=xlabel,font=0,xticks=hints,xtickname=hlabels,$
ytype=linlog,title=p_title,ticklen=-.01
device,/close
if (jplt eq 1) then b_and_w
if (jplt eq 2) then color
set_plot,'x'
resetfig   ; added 97/08/06
loadct,gsfc_color
!p.background=255
!p.color=0
; erase ;; Not needed or wanted
end
;***** Zoom *******************************************************
'Zoom':  begin
zoom,Interp=1
end

;***** New Scale ************************************************
'New color scale': begin
print,'enter new min and max in dB'
read,scale1,scale2
scale=scale2-scale1
if(scale le 10) then nticks=scale
if((scale gt 10) and (scale lt 20)) then begin
scale=2*fix(scale/2+.9)
scale2=scale1+scale
nticks=scale/2
endif
if(scale ge 20) then begin
scale=10*fix(scale/10+.9)
scale2=scale1+scale
nticks=10
iplt=2
endif
goto,replot
end
;***** New Day ********************************************
'New Dates/Rcvr': begin
 sub_interval = "FALSE"
 goto, start
end

;****** Plot Sub-interval ******************************************
'Plot sub-interval': begin
  print, "Click cursor at start and end times"
  cursor, hour1, freqx, /down
  cursor, hour2, freqx, /down
  if (hour2-hour1) lt 2.0 then begin
    print, "The program labeling does not work for less than 2 hrs"
    print, "Resetting to 2 hours"
    hour1 = (hour1+hour2)/2.0 - 1.
    hour2 = hour1 + 2.
  endif
; need to recalculate date labels
  if(yymmdd1 lt yymmdd2) then begin
    new_iday = fix((hour1+hour1_start)/24.)
    yymmdd1 = oyymmdd1
    addymd, yymmdd1, new_iday
    doy1 = odoy1 + new_iday;  needed for labels
    if (hour1 mod 24 ne 0.00) then doy1 = doy1 + 1
    new_iday = fix((hour2+hour1_start)/24.)
    yymmdd2 = oyymmdd1
    addymd, yymmdd2, new_iday
    if (yymmdd1 eq yymmdd2) then begin
      datefm,yymmdd1,date
      dates = date
    endif else begin
      datefm,yymmdd1,date1
      datefm,yymmdd2,date2
      dates = date1+' to '+date2
    end
  p_title = ' Wind Waves ' + strupcase(rcvr) + ' receiver: '+ dates
  endif
  ihr1 = long((hour1-ohour1)*3600./av_interval) > 0
  ihr2 = long((hour2-ohour1)*3600./av_interval) < (xdim-1)
  ohour1 = hour1
  xdim = ihr2-ihr1 + 1
  print, " selecting subset of data..."
  array = array(ihr1:ihr2,*)
  hour =  hour(ihr1:ihr2+1)
  sub_interval = "TRUE"
  goto, redo_labels
end
;****** Plot One Time series ******************************************
'Plot 1 time series': begin
   if (!D.NAME ne 'X' or plot_type ne "dynamic_spec") then begin
     print, "Enter freq (" + funit + '):'
     read, freq1
   endif else begin
     print, "Select frequency with cursor"
     cursor, hourxx, freq1, /down
   endelse
   plot_type = "time_series"

   if(rcvr eq 'tnr') then begin  ; note fhz1 & freq1 are in log(freq) for TNR
     freq1 = (10.^fhz1 > freq1) < 10.^fhz2
     chan1=fix((alog10(freq1)-fhz1)/fspace)+1
     freq1=fhz1+chan1*fspace
   endif else begin
     freq1 = (fhz1 > freq1) < fhz2
     chan1=fix((freq1-fhz1)/fspace)
     freq1=fhz1+chan1*fspace
   endelse

   goto, redo_labels
   plot_timeser:
   if(rcvr eq 'tnr') then freq_00=long(100.*10.^freq1)/100. $
     else freq_00=long(100.*freq1)/100. 
   print, "Freq (" + funit + ') = ', freq_00
   if (!D.name eq "PS") then begin
      plot, hour(0:xdim-1), array(*,chan1), psym=-1, /xstyle, $
        title=p_title + "   Freq: "+ strtrim(freq_00,2) + " " + funit, $
        ytitle="dB above background", xtitle=xlabel, xtickv=tickv,$
        xticks=hints,xtickname=hlabels, symsize=0.3,font=0
    endif else begin
      plot, hour(0:xdim-1), array(*,chan1), psym=-1, /xstyle, $
        title=p_title + "   Freq: "+ strtrim(freq_00,2) + " " + funit, $
        ytitle="dB above background", xtitle=xlabel, xtickv=tickv,$
        xticks=hints,xtickname=hlabels, symsize=0.3
   endelse
   if (menu(choice) eq "Hardcopy (DS or TS)") then begin
     if (jplt eq 1) then b_and_w
     if (jplt eq 2) then color
     set_plot,'x'
     loadct,gsfc_color
     !p.background=255
     !p.color=0
  endif
end

;***** Quit ******************************************************
'Quit': goto, exit

endcase

goto, main

exit:
if (not_open1 eq "FALSE") then free_lun, ounit1
if (not_open2 eq "FALSE") then free_lun, ounit2
end
;**********************************************************************
;**********************************************************************


