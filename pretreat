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
string list_input,list_all,list_star,list_flat,list_bias,list_dark  #list name, character type
string imagename,flag,rot180key,rot180val,keyvalue,DATEOBS
real   exposure
string key_dateobs,key_exposure,BME,key_band,band,trim_range
real   aaa,bbb,ccc #inner loop variables
string sss,ttt,rrr #inner loop variables
real   hjd,detjd
string darkname,flatname


flprcache #Cache reflush


#manual definition(the list file needed to be made before)
list_input = 'list_input'
#read iraf_settings
read_iraf_settings('#image_header_keywords#') | scanf('%s %s %s %s',key_dateobs,key_exposure,BME,key_band) #read image header keywords name
read_iraf_settings('#trim_range#') | scanf('%s',trim_range) #read the trim section
read_iraf_settings('#rotate_images_based_on_header#') | scanf('%s %s',rot180key,rot180val) #read the rotate keywords name and value, for those needed to be rotated 180 degree




#pre-load task/reset task
imdelete.verify=no; delete.verify=no #so the latter actions of deleting do not need to set this parameter
images(); imutil(); system(); 
noao(); imred(); ccdred();
unlearn('hselect'); unlearn('sort'); unlearn('imcopy'); 
unlearn('darkcombine'); unlearn('zerocombine'); unlearn('flatcombine'); unlearn('ccdproc'); 







#make name sub-list based on the input list
    delete("l?st_bias,l?st_dark,l?st_flat,l?st_star,l?st_all") #pre-clean (use wildcard character to avoid warning when no file)
list1=list_input; while(fscan(list1,strs)!=EOF){
print(strs) | scanf("%s %s",imagename,flag) #read file name and flag
    if(strlen(imagename) == 0) next #if space line jump over
if      (strupr(flag) == 'BIAS') {print(imagename, >> 'list_bias')}
else if (strupr(flag) == 'DARK') {print(imagename, >> 'list_dark')}
else if (strupr(flag) == 'FLAT') {print(imagename, >> 'list_flat')}
else                             {print(imagename, >> 'list_star')}
print(imagename, >> 'list_all')} #every name wrote into all list 
list_all ='list_all'   #all list
list_star='list_star'  #star list
list_flat='list_flat'  #flat list
list_bias='list_bias'  #bias list
list_dark='list_dark'  #dark list
#specific to FRAM telescope, make hjd list (for using the nearest dark and flat)
    delete("DA?K.hjd, FLA?.hjd") #pre-cleaning
list1=list_input; while(fscan(list1,strs)!=EOF){
print(strs) | scanf("%s %s",imagename,flag) #read file name and flag
    if(strlen(imagename) == 0) next #if empty line, skip
    if(strupr(flag) != 'FLAT' && strupr(flag) != 'DARK') next #not FLAT/DARK, skip
hselect(images=imagename,fields='jd_helio,'//key_exposure//','//key_band,expr=yes) | scanf("%g %g %s",hjd,exposure,band)
print(imagename,'   ',hjd,'   ',exposure,'   ',band, >> strupr(flag)//'.hjd') }



#pre-cleaning
delete("*logfile") #clean log file
list1=list_all; while(fscan(list1,imagename)!=EOF){imdelete('*t_'//imagename)} #pre-cleaning(clean all the generated image files) seemed that can not delete multiple slice format
#trim (eradicate all the troubles from the very beginning)
list1=list_all; while(fscan(list1,imagename)!=EOF){imcopy(input=imagename//trim_range,output='t_'//imagename,verbose=no)} #the trim section needed to set manually
#rotate images--specify to 180 degree case only
list1=list_all; while(fscan(list1,imagename)!=EOF){
if(rot180key == 'NULL') {break} #if no label of rotating, skip
hselect(images=imagename,fields=rot180key,expr=yes) | scanf("%s",keyvalue)
if(keyvalue == rot180val) {imcopy(input='t_'//imagename//'[-*,-*]',output='t_'//imagename,verbose=no)}; } #rotate images
#prepares--add image header(Mandatory add exposure header--because many places use it, and do not specify the keyword name)
list1=list_input; while(fscan(list1,strs)!=EOF){
print(strs) | scanf("%s %s",imagename,flag) #read file name and flag
    if(strlen(imagename) == 0) next #if empty line, skip
hselect(images=imagename,fields=key_exposure,expr=yes) | scanf("%g %s",exposure)
hedit(images='t_'//imagename,fields="EXPOSURE",value=exposure,add=yes,addonly=no,delete=no,verify=no,show=no,update=yes) } #Mandatory add exposure header
#do dark flat (specify to the FRAM telescope)
list1=list_star; while(fscan(list1,imagename)!=EOF){
    hselect(images='t_'//imagename,fields=key_exposure//','//key_band//',jd_helio',expr=yes) | scanf("%g %s %g",exposure,band,hjd) #obtain the exposure and filter
    detjd=1e10; list2='DARK.hjd'; while(fscan(list2,sss,aaa,bbb,ttt)!=EOF){ if(exposure != bbb) {next}; if(detjd > abs(hjd-aaa)) {detjd=abs(hjd-aaa);darkname=sss};  }
    detjd=1e10; list2='FLAT.hjd'; while(fscan(list2,sss,aaa,bbb,ttt)!=EOF){ if(band     != ttt) {next}; if(detjd > abs(hjd-aaa)) {detjd=abs(hjd-aaa);flatname=sss};  }
ccdproc(images='t_'//imagename,output='pt_'//imagename,ccdtype='',dark='t_'//darkname,flat='t_'//flatname,fixpix=no,oversca=no,trim=no,zerocor=no,darkcor=yes,flatcor=yes,illumco=no,fringec=no,readcor=no,scancor=no,interac=no) #iamge Calibration
    imdelete('t_'//imagename)   #latter clean
}
#latter clean
list1=list_all; while(fscan(list1,imagename)!=EOF){imdelete('t_*'//imagename)} #latter clean(clean all the generated image files) seemed that can not delete multiple slice format






























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
flprcache;flprcache #cache reflush



end



