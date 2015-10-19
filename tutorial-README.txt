========================================================================================
In this tutorial we will migrate a 90 transistor layout with 2 levels of hierarchy. 
The layout will be migrated from 90nm to 45nm:

  Source Process: fabx 90nm gs  (tech-a)
  Target Process: faby 45nm lp  (tech-b)
  Top cell: decode_mux_top

"tech-a" refers to the 90nm input technology
"tech-b" refers to the 45nm output technology
All paths in this tutorial are relative to the "tutorial" directory.

Quick Tips for users new to Titan:
  Use "Query->Add ruler (snap)" menu to measure shapes
  Use "View->Pan to XY..." menu to pan to a location.
  Mouse wheel zooms in/out
  Middle-mouse button zooms to rectangle
========================================================================================


1.UNTAR: Unzip and untar file: 
  unix> gunzip alx_tutorial.tar.gz
  unix> tar -xvf alx_tutorial.tar
  unix> cd tutorial


2. TITAN: Start titan in the tutorial directory
   Titan is located in directories:
     32-bit:  <install_path>/linux26_x86/bin/
     64-bit:  <install_path>/linux26_x86_64/bin/
   Add this to your PATH and set your license file path, and run:
   
   unix> titan


3. TECH SETUP: Examine the tech-a and tech-b layer maps in the technology root for this project.
   The directory structure is as below where all files under "techa" are for the input
   tech and all files under "techb" are for the output tech:
   
   tutorial
     |
     +___project --> project.tcl
            |
            +---root
                   |
                   +---techa
                   |     |
                   |     +---fabx90gs --> lmap.tcl
                   |
                   +---techb
                         |
                         +---faby45lp --> lmap.tcl rule.tcl titan.cfg pcell.tcl
             
   
   project.tcl : project specific settings
   lmap.tcl    : Source or target layermap from ALX tag to a layer number and purpose (datatype)
   rule.tcl    : Target technology DRC rules
   titan.cfg   : Titan technology file including layer defs, layer purpose defs, LDP defs, etc.
   pcell.tcl   : Target tech PCell mapping and parameterization 
   
   Take a look at the input tech-a layer map:  ./project/root/techa/fabx90gs/lmap.tcl
   
   The layer map is just a Tcl array of ALX tag and layer/datatype pair(s). 
   
      For example,
         via1         {{51 252}}
   
      Here, "via1" is an ALX tag for metal1-to-metal2 vias.  So all shapes
      on <layer 51, datatype 252> will be considered metal1 to metal2 vias.
   
   Also, take a look at the target tech-b layer map:  ./project/root/techb/faby45lp/lmap.tcl
   You can see that the via1 is mapped as follows in techb:
   
       {via1 drawing}  {{51 252}}
   
       Here you can see that via1 ALX tag is mapped to the same layer in the output as the input.
       Also, note that a layer purpose of "drawing" is specified in the output table. Note that 
       all input layer purposes default to "drawing" if none is specified as in the input lmap.
   

4. DESIGN SETUP: Examine the project settings for ALX:
   The ./project/project.tcl file is used to store project specific settings for ALX.
   There are 2 main parameters that must be set before running migration.
   
       a) Tell ALX if N and P diffusion is on different layers or if there is a single OD layer.
          In this design, N and P are on pdiff and ndiff layers, thus air_od is set to 0 which indicates
          this. See full docs on this parameter for other scenarios.
   
             alx set param air_od 0          ; # pdiff/ndiff are defined in the input layout
   
       b) Tell ALX about the implant layers in the input layout. In this case both PP/NP are available
          in the input layout, so maintain these in the output layout:
   
            alx set param air_pp 0          ; # maintain existing PP/NP
   

5. RUN MIGRATION: Setup and run the layout migration:
   a) Open the input design by clicking on "my_library" in the "Libraries" window, and then 
      double-click the cell "decode_mux_top" in the "Cells" window.
   
   b) Initialize ALX:
        titan> alx::boot
   
   c) Set the ALX technology root (location where all the ALX tech files are stored):
        titan> alx set root ./project/root
   
   d) Setup the ALX migration (scale all geometry by 50%)
        titan> alx setup -techa fabx90gs -techb faby45lp -sf 0.5
   
          (Note here it would have been sufficient and equivalent to say:
              titan> alx setup
           This is because there is only a single tech defined under the root/techa and root/techb
           directories. The scaling factor is also computed as techb/techa, ie, 45/90=0.5)
   
   e) Source the ALX project specific migration settings (we will review this later in this tutorial):
        titan> source ./project/project.tcl
   
   f) Run the ALX solver to create the migrated layout (and store the resulting cell's ID):
        titan> set resultid [alx run solver -hflow]
   
6. REVIEW RESULTS: Examine the resulting migrated layout:
   --> In the "Libraries" window, click and highlight "my_library@alxh_faby45lp",
       and double-click "decode_mux_top"
   
    Notice that the original cell hierarchy is maintained (clicking on the up/down arrows on
    top-right of titan window controls the hierarchy view depth).
   
    Notice all the pins/ports/nets are preserved (use menu Query->SummaryDeep to get design details)
   
    You can check what level of scaling was achieved for the block by running the following command:
   
      titan> get_scaling_info
        
      Note that you will not always achieve the specified scaling since depends on the compactness of
      layout, target device sizing, and so on. In general, smaller layouts like this example do not
      compact as much as larger layouts.
   

7. PRESERVE LAYER PURPOSE: Notice that the input layout had power/ground purposes, but the output does not.
   Lets now enhance the layer maps to get ALX to maintain these power/ground datatypes.
   
   In the input layout metal2 and metal3 layers have shapes on power/ground purpose to indicate the power
   grid. The datatype numbers for power and ground in tech-a are 62 and 63, respectively. In tech-b, 
   the power and ground datatypes are 41 and 42.  To map these datatypes, use the following command:
   
      titan> alx! update layer datatypes $resultid {{62 41} {63 42}} -run
   
        where, {62 41} means from datatype 62 in tech-a, to datatype 41 in tech-b. This will automatically 
        change all shapes on all layers with datatype 62 to datatype 41.
   
      Use the Query->Summary Deep menu to see that the datatypes have now been changed to 41 and 42.
      Also, refresh the layer palette by clicking on "sort->by layer number" on top of the layer palette.
      In the refreshed palette, you should now be able to see the "pwr" and "gnd" layer purposes.
   

8. CROPPING PIN SHAPES
   Examine the pin shapes in the output layout. Notice that they may get very large sometimes since 
   ALX merges touching shapes together for better results and performance. The pins can be put back close
   to their original shape by running the following post-process command:
   
      titan> alx! pin crop $resultid -laya [alx get param lay_a_cellid0] -verbose
   
   Refresh the display, and examine the pin shapes once again. You will note the shapes are now close
   to the pin shapes of the original design.
   


9. CREATE VIA ARRAYS
    For easier editing, it's useful to map all evenly spaced contacts and vias to via arrays. ALX can do this 
    automatically as a post-process step by running the following command:
    
       titan> alx generate via arrays $resultid

       If a PDK is specified in titan.libs, then a the PDK is first checked for existing symbolic vias
       and these definitions will automatically get used to create the symbolic via arrays.


10. GENERATE IMPLANT LAYERS: Notice that implant layers (PP/NP) are there but do not cover the full design.
    We can now go ahead and automatically fill the holes in the implant layers by running:

      titan> alx generate implant layers $resultid

      Refresh the window and you can see that the complete design is now covered by PP/NP.



11. DEVICE SIZING CHANGES
    Notice that all device sizes are the same as the input layout. This is due to the following parameter
    set in the project.tcl file:
 
       alx set param fix_device_sizes 1
 
    This forces all devices to have the same size as the input layout.
 
 
    ALX offers various methods for modifying the sizes of the target layout.
 
      A) Uniformly scale device sizes same as wires:
            To scale all device widths and lengths by the same amount as the wire geometry, you
            can simply use the scaling factor on the setup command. For example, here we are using a 
            scale factor of 0.5 as shown in step 5d.
 
               titan> alx set param fix_device_sizes 0
               titan> alx set param air_resize {}
 
            This instructs ALX to use the scaling factor on the setup command since no re-size file is
            specified to the air_resize parameter.
 
            --> Close the result window by clicking "x" in top-right corner (save the design when prompted)
            --> Set the focus to the input layout window and re-run the solver to get a new solution:
            
               titan> set resultid [alx run solver -hflow]
 
               DONT FORGET to make the input layout visible in the editor before running the solver command.
               ALX operates on the active window when a cell ID is not specified (as in command above).
 
          Now re-open the resulting layout, and notice that all devices are half the size. Also notice that
          poly spacers were automatically inserted around some devices where needed by the 45nm DRC rules.
 
          Notice also that a short was introduced during this run as reported in the terminal log. 
          This can be easily corrected by the user using the ALX GUI:
             --> Start the ALX debug GUI, by going to the menu ALX->Migrate, and click on the "Debug" tab.
             --> With the result window in focus, click the "short m1" error in the debug tab window.
                   You can see the m1 to m1 short here. This can easily be corrected by hand later 
                   before proceeding with LVS.
             --> Click on the "Error File" drop-down, and select the via_forced.err file.
                 Step thru these warnings. You can see here the was not sufficient space to add a contact
                 but a contact was added anyway and a DRC trade-off was made to maintain LVS correctness.
                 This can be easily corrected manually during manual DRC clean-up later.
 
                 This trade-off is configurable, and will be discussed later.
             --> Close the ALX gui window and move to the next step.
 
      B) Uniformly Scale Devices by Width/Length signature table:
            This can be used for 2 common scenarios:
              a) To scale devices differently than the wire geometries
              b) To scale all devices of a certain W/L to a different W/L
 
               ALX writes out a table of all W and L of devices found in the input layout.
               This file can be modified and fed back into ALX to get the new desired sizes.
 
            --> Locate the following file:  ./alxrundata/my_library--decode_mux_top/origsizet.txt
            --> Copy this file into the ./project directory and name it "origsizet_mod.txt"
 
               This file is formatted as follows:
                 input_device_type W L   output_device_type W L
 
               Notice that by default, all input and output device types and W/L are the same.
 
 
               Lets target all PMOS devices (device_type 1) of size 2000x200 to 1200x150, while leaving all
               other devices the same as the input layout. 
            --> To do this modify the 5th line in the file "origsize_mod.txt":
from:
1 2000 200 1 2000 200
to:
1 2000 200 1 1200 150
 	
               Now, instruct ALX to use this file for table based device sizing.
 
                  titan> alx set param air_resize_table [alx get root]/../origsizet_mod.txt
 
            Now, re-run the migration.
 
            --> Close the result window by clicking "x" in top-right corner (save the design if prompted)
            --> Set the focus to the input layout window and re-run the solver to get a new solution:
            
             titan> set resultid [alx run solver -hflow]
   
             (DONT FORGET to set the focus to the input layout before running the solver command above)
 
 	 Examine the result. Notice the size changes to all the 2000x200 devices (upper right) to 1200x150.
          Notice the following 2 lines in the terminal log confirming the device sizing:
            <91> of <91> devices sized by W/L signature (air_resize_table)
            <0> of <91> devices sized by coordinates (air_resize)
 


      C) Device specific scaling by coordinate
         Subsequently, every device can be scaled by coordinate if needed. This specification can be provided
         by itself or in conjunction with the the W/L signature based table sizing, where the device specific
         size takes priority over the table based sizing if there is an overlap.

           --> Locate the following file:  ./alxrundata/my_library--decode_mux_top/origsize.txt
                (notice this filename is origsize.txt, NOT origsizet.txt)

              This file is formatted as follows:
                 device_type x y W L fingers_head fingers_tail

               where, x y are the coordinates in the input layout, W/L are width and length, 
                  fingers_head are the number of fingers to add on the head of the transistor,
                  fingers_tail are the number of fingers to add on the tail of the transistor.

         Lets now change the trasistors at (10.435  2.075) and (10.795  2.075) from 1150x100 to 1000x50.

           --> Create a new file called:  ./project/origsize_mod.txt

	   Paste the following 2 lines into this file:
2 10435 2075 1000 50 0 0
2 10795 2075 1000 50 0 0

         (notice these two lines are the first 2 lines from the origsize.txt file, but we have modified the
          sizes to 1000x50. We only need these 2 lines since we only want to modify these 2 transistor fingers)


         Now, instruct ALX to use this file for coordinate based device sizing.

               titan> alx set param air_resize [alx get root]/../origsize_mod.txt

        Now re-run the migration.
           --> Close the result window by clicking "x" in top-right corner (save the design if prompted)
           --> Set the focus to the input layout window and re-run the solver to get a new solution:
           
            titan> set resultid [alx run solver -hflow]
  
            (DONT FORGET to set the focus to the input layout before running the solver command above)

	 Examine the result. Notice the two fingers of the device at coordinates (16.725  1.375) have
         changed to the new sizes of 1000x50. Also note that the previous sizing changes we did using the 
         W/L signature table are also still present. You can confirm this by looking at the teminal log
         message:

            <89> of <91> devices sized by W/L signature (air_resize_table)
             <2> of <91> devices sized by coordinates (air_resize)


      D) Automatic LVS based (or input-to-output schematic based) sizing
         [To be covered in future revision of the tutorial.]


12. MAPPING TO PCELLS
     [To be covered in future revision of the tutorial.]


