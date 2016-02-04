# iraf photometry scripts
The three cl suffix files (pretreat.cl, photer.cl and read_iraf_settings.cl) are the iraf scripts for measuring stars flux in CCD images. It is written in iraf command language, not in Python.

The other three files (iraf_settings, list_input and reference.fits.coo) are the input files for the processing.

The three scripts can process photometric CCD images automatically: do dark and flat correction, match images for the shifts and rotations between them, measure stars in different apertures. It is specified to observations of FRAM (http://gloria.fzu.cz/en/fram) telescope located in Mendoza province in Argentina. These scripts were used to process FRAM data in one-click way: about 7x7 degree field of view, ~30G size, ~4000 frames, several thousands stars in one frame, shifts and rotations between frames. Two hundreds stars were measured in each frame with different apertures.

How to use them?

1.install iraf on linux like system.

2.add the scripts in the iraf.

3.prepare the observation data.

4.prepare name list file like "list_input".

5.prepare parameters setting file like "iraf_settings"

6.prepare reference image and its photometric stars coordinates like "reference.fits.coo". (the names are setted in "iraf_settings")

7.enter into data directory (with all the data and input files inside) in iraf command language environment.

8.type the command: pretreat | photer

then the scripts run, and generate the results catalogs in a folder.
