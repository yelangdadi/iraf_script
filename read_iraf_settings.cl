


procedure script(pars_read)



string  pars_read='' {prompt="the parameters to be readed"}
string  starname='' {prompt="the name of the star"}
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

struct strs #used to read whole line (including spaces)
string label,direction,range
bool   read,printout
real exposure
int pixel



#read lamp split joint settings
if(pars_read == '#lamp_settings_for_combine#'){
  list1='iraf_settings'; read=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){
      print(strs) | scanf("%g %d %s",exposure,pixel,direction)
      if(strupr(direction) == '+Y'){range='[*,1:'//str(pixel)//']'}
      if(strupr(direction) == '+X'){range='[1:'//str(pixel)//',*]'}
      print(exposure,' ',range);printout=yes  #print two parameters on the screen-- exposure time and copy range(the range copied from long exposure to short exposure)
      break} 
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
if(read == no){print(-1)};
};
#read flat split joint settings
if(pars_read == '#flat_settings_for_combine#'){
  list1='iraf_settings'; read=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){
      print(strs) | scanf("%g %d %s",exposure,pixel,direction)
      if(strupr(direction) == '+Y'){range='[*,1:'//str(pixel)//']'}
      if(strupr(direction) == '+X'){range='[1:'//str(pixel)//',*]'}
      print(exposure,' ',range);printout=yes  #print two parameters on the screen-- exposure time and copy range(the range copied from long exposure to short exposure)
      break} 
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
if(read == no){print(-1)};
};





#read stars informations
if(pars_read == '#stars_informations#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){
      print(strs) | scanf("%s",label)
      if(strup(label) == strup(starname)){print(strs);printout=yes;break}
      else {next}; 
    }
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
  if(printout == no){print('NULL')};
};


#read site informations
if(pars_read == '#site_informations#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};
#read lamp calibration file
if(pars_read == '#reference_lamp#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};
#read keyword name
if(pars_read == '#image_header_keywords#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};
#read trim section
if(pars_read == '#trim_range#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
if(read == no){print('[*,*]')}; #if no, then all ranges copied
};
#read rotation keywords
if(pars_read == '#rotate_images_based_on_header#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
if(read == no){print('NULL NULL')}; #if no output is NULL
};
#read image matching pars 
if(pars_read == '#phot_name-list_refim_refcoo#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};
#read phot pars apertures
if(pars_read == '#phot_apertures#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};
#read phot pars fwhm
if(pars_read == '#full-width_half-maximum#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};
#read the minimum number matched
if(pars_read == '#minimum_star_number_matched#'){
  list1='iraf_settings'; read=no; printout=no #default no
  while(fscan(list1,strs)!=EOF){
    if(read == yes){print(strs); break}
    print(strs) | scanf("%s",label)
    if(label == pars_read){read=yes} 
  };
};






end
