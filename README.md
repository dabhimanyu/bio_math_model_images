# Main Cell Image Processing Code:

### NOTE: Sequence Of Running Codes:
Main Folder (i.e. "bio_math_model_images") contains only 3 '.m' Files.
##### -> bio_science_plotter_.m			
##### -> main_tracking_code_for_cells.m		
##### -> new_MAIN_Cell_Image_Code_13_06_2022_.m

## Step 1. 
First Of all we'll run "Main Cell Image Code". 
It'll identify the individual cells/beads [ cute little, 
small islands, as I call them :-) ] in the image, calculate their
centroid and export this "centroid_data" as a ".mat" File

## Step 2.
run "main tracking code".

It'll import the centroid data which were exported earlier in Step 1 and 
Do the following: 

     (a) Remove NearBy Particles ( If Toggle is Switched On )
     (b) Make Tracking Input File, and 
     (c) Track Your particles:
     (d) Calculate Pixel Displacement:
     
  NOTE: Currently we have switched off the toggle switch for
  near_by_particle_removal_macro upon Prof. Nikhil's Suggestion

## Step 3.
 Run bio_science_plotter to do the necessary plotting
 This part of the code frequently changes depending on how results needs
 to be visualized
