#based on the iraf version 2.16, so there may be problems on earlier versions.


procedure script()


string *list1
string *list2 
string *list3
string *list4
string *list5
string *list6
string *list7
string *list8
string *list9






begin




#define variables
struct strs #used to read whole line (including spaces)
string list_input
string imagename,flag,starname,dirresult
string namelist,namelist_val,ref_image,ref_image_coo #name or list, starname or name list file, reference image, coordinates of reference image
string key_dateobs,key_exposure,BME,key_band #image header keywords
int    i,j,k #inner loop variables
real   aaa,bbb,ccc #inner loop variables
string sss,ttt,rrr #inner loop variables
int    nfind,minmatch #stat finding number, the minimum star number matched
real   fwhm,MAG,MERR,APERTURES,exposure,HJD,JD #phot parameters
string readline,DATEOBS,band #phot parameters
int    ID #phot parameters
real   ap1,ap2,ap3,ap4,ap5,ap6,ap7,ap8,ap9,ap10,aps[10] #phot apertures, default 0


wait;flprcache #Cache reflush



#manual definition(the list file needed to be made before)
list_input = 'list_input'
read_iraf_settings('#image_header_keywords#') | scanf('%s %s %s %s',key_dateobs,key_exposure,BME,key_band) #read image header keywords name
read_iraf_settings('#phot_name-list_refim_refcoo#') | scanf('%s %s %s %s',namelist,namelist_val,ref_image,ref_image_coo) #read image matching settings
read_iraf_settings('#minimum_star_number_matched#') | scanf('%d',minmatch); nfind=5*minmatch
read_iraf_settings('#phot_apertures#') | scanf('%g %g %g %g %g %g %g %g %g %g',ap1,ap2,ap3,ap4,ap5,ap6,ap7,ap8,ap9,ap10) #read apertures settings
  aps[1]=ap1; aps[2]=ap2; aps[3]=ap3; aps[4]=ap4; aps[5]=ap5; aps[6]=ap6; aps[7]=ap7; aps[8]=ap8; aps[9]=ap9; aps[10]=ap10; #store the apertures into array for the convenience of using 
read_iraf_settings('#full-width_half-maximum#') | scanf('%g',fwhm) #Full width half maximum



#pre-load task/reset task
imdelete.verify=no; delete.verify=no #so the latter actions of deleting do not need to set this parameter
images(); imutil(); system(); 
images(); immatch();
noao(); digiphot(); ptools(); daophot();
unlearn('sort'); unlearn('head'); unlearn('tail'); unlearn('hselect'); unlearn('pdump');
unlearn('datapars'); unlearn('findpars'); unlearn('daofind'); #finding star task, enter into the daofind package at last
unlearn('centerpars'); unlearn('fitskypars'); unlearn('photpars'); unlearn('phot'); #phot parameters task
unlearn('xyxymatch'); unlearn('geomap'); unlearn('geoxytran'); #match/calculate coordinates


#the finding task parameters
  daophot(); #enter into the daophot package
  datapars.scale        = 1
  datapars.fwhmpsf      = fwhm
  datapars.datamin      = INDEF
  datapars.datamax      = INDEF
  datapars.sigma        = 3. #manual adjustment
  datapars.exposure     = key_exposure
  datapars.obstime      = key_dateobs
  datapars.filter       = key_band
  findpars.threshold    = 4 #manual adjustment unit is sigma
  findpars.nsigma       = 1.5 #manual adjustment
#phot parameters
  centerpars.maxshift   = 2.5*fwhm
  centerpars.cbox       = 3*fwhm     #the suitable value is 2.5-4.0 times of fwhm
  photpars.weight       = "constant"
  photpars.zmag         = 25
#sky parameters
  fitskypars.annulus    = 3*fwhm #inner sky aperture, manual adjustment
  fitskypars.dannulu    = 50*fwhm #annular sky background width, manual adjustment






#pre-cleaning
delete('pt_*.daofind, pt_*.pdump, pt_*.sort, pt_*.head, pt_*.xyxymatch, pt_*.geomap, pt_*.geoxytran, pt_*.mag.*, pt_*.phot') #pre-cleaning
delete('failing_ma?ch') #pre-cleaning the log of failing match
delete('phot_resul?s.dat') #pre-cleaning the final results file

#prepare the folder for the results
time | scanf('%s %s %s',sss,ttt,rrr) #obtain time
dirresult='phot_results_'//ttt//'_'//rrr; mkdir(dirresult) #make a fold named by the current time
#find star in the reference image, the suffix is ref
    delete(ref_image//'*.daofind,'//ref_image//'*.pdump,'//ref_image//'*.sort,'//ref_image//'*.ref') #pre-cleaning
daofind(image=ref_image,output=ref_image//'.daofind',wcsout='tv',interac=no,verbose=no,verify=no)  #find star
pdump(infiles=ref_image//'.daofind',field="XCENTER,YCENTER,MAG",headers=no,parameters=no,expr=yes, > ref_image//'.pdump') #extract coordinates
sort(input_fi=ref_image//'.pdump',column=3,numeric=yes,reverse=no, > ref_image//'.sort') #make mag sorted coordinate file
head(input_fi=ref_image//'.sort',nlines=nfind, > ref_image//'.ref') #obtain the matchingcoordinate file
    delete(ref_image//'*.daofind,'//ref_image//'*.pdump,'//ref_image//'*.sort') #pre-cleaning
#phot--with matching images inside
list1=list_input; while(fscan(list1,strs)!=EOF){
  print(strs) | scanf("%s %s",imagename,flag) #read file name and flag
      if(strlen(imagename) == 0) next #if there is empty line, skip
      if(strupr(flag) != strupr(namelist_val)) next #not target, skip
  ##if exist, skip, used to complete the previous break off task
  #if(access(dirresult//'/'//namelist_val//'_'//imagename//'.dat')) {next}
  #find star
  daofind(image='pt_'//imagename,output='pt_'//imagename//'.daofind',wcsout='tv',interac=no,verbose=no,verify=no)  #find star
  pdump(infiles='pt_'//imagename//'.daofind',field="XCENTER,YCENTER,MAG",headers=no,parameters=no,expr=yes, > 'pt_'//imagename//'.pdump')  #extract coordinates
  sort(input_fi='pt_'//imagename//'.pdump',column=3,numeric=yes,reverse=no, > 'pt_'//imagename//'.sort')  #make mag sorted coordinate file
  head(input_fi='pt_'//imagename//'.sort',nlines=nfind, > 'pt_'//imagename//'.head')
      delete('pt_'//imagename//'.daofind*'); delete('pt_'//imagename//'.pdump*'); delete('pt_'//imagename//'.sort*') #latter clean
  #match
  xyxymatch(input='pt_'//imagename//'.head',referenc=ref_image//'.ref',output='pt_'//imagename//'.xyxymatch',refpoin='',toleranc=fwhm,xcolumn=1,ycolumn=2,xrcolum=1,yrcolum=2,separat=3*fwhm,matchin='triangles',nmatch=nfind,nreject=10,interac=no,verbose=no)       
      tail(input_fi='pt_'//imagename//'.xyxymatch',nlines=minmatch+1) | head(input_fi='',nlines=1) | scanf('%s',readline) #judge the number of stars matched
      if(readline == '#' || readline == '') {print('pt_'//imagename, >> 'failing_match'); delete('pt_'//imagename//'.xyxymatch'); delete('pt_'//imagename//'.head');display(image='pt_'//imagename,contras=0.25,fill=yes,frame=2,zscale=yes,erase=yes); next} #if the matched number is less the setting, skip
  geomap(input='pt_'//imagename//'.xyxymatch',database='pt_'//imagename//'.geomap',xmin=INDEF,xmax=INDEF,ymin=INDEF,ymax=INDEF,transfo='',results='',fitgeom='general',functio='polynomial',verbose=no,interac=no)
  geoxytran(input=ref_image_coo,output='pt_'//imagename//'.geoxytran',database='pt_'//imagename//'.geomap',transfor='pt_'//imagename//'.xyxymatch',geometr='geometric',directi='forward')
      delete('pt_'//imagename//'.head*'); delete('pt_'//imagename//'.xyxymatch*'); delete('pt_'//imagename//'.geomap*') #latter clean
  #display the matched result
  display(image='pt_'//imagename,contras=0.25,fill=yes,frame=1,zscale=yes,erase=yes)
  tvmark(frame=1,coords='pt_'//imagename//'.geoxytran',outimag='',mark="circle",radii=2.5*fwhm,color=204,label=no,number=no,txsize=1.5,interac=no)
  #aperture phot
      daophot(); #enter the daophot package
  for(i=1;i<=10;i+=1){if(aps[i] == 0){break}; photpars.aperture=aps[i]*fwhm; phot(image='pt_'//imagename,coords='pt_'//imagename//'.geoxytran',output='default',interac=no,radplot=no,cache=yes,verify=no,update=no,verbose=no)}
  pdump(infiles='pt_'//imagename//'.mag.*',field='mag,MERR,ID,APERTURES',expr='mag != INDEF', > 'pt_'//imagename//'.phot') 
      delete('pt_'//imagename//'.geoxytran*'); delete('pt_'//imagename//'.mag*'); 
  #log the phot results
  list2='pt_'//imagename//'.phot'; while(fscan(list2,MAG,MERR,ID,APERTURES)!=EOF){
  hselect(images='pt_'//imagename,fields=key_exposure//','//key_dateobs//',jd_helio,jd,'//key_band,expr=yes) | scanf("%g %s %g %g %s",exposure,DATEOBS,HJD,JD,band)
  #print(DATEOBS,' ',MAG,' ',MERR,' ',ID,' ',APERTURES,' ',exposure,' ',band,' ',HJD,' ',fwhm,' ',JD, >> dirresult//'/'//namelist_val//'_phot.dat') #save in to a file
  print(DATEOBS,' ',MAG,' ',MERR,' ',ID,' ',APERTURES,' ',exposure,' ',band,' ',HJD,' ',fwhm,' ',JD, >> dirresult//'/'//namelist_val//'_'//imagename//'.dat')  };
      delete('pt_'//imagename//'.phot*'); 
}



































dne:
;
list1=''
list2=''
list3=''
list4=''
list5=''
list6=''
list7=''
list8=''
list9=''
wait;flprcache #cache reflush



end



