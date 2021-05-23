Please follow next instructions to run the simulation:

1- Make new project file in modelsim 

2- Upload all 31 VHDL files included in this RAR 

3- Compile all

4- Go to Library window and double click on 'MIPS'

5- A new window will appear with name 'Sim'

6- Right click on 'mips' in the window appeared in step 5

7- Go to Add --> To Wave --> All items in region 

8- Right click on the 'Clock' signal and then press on 'Clock..'

9- Set clock with the following setting: 

Offset: 0
Duty: 50
Period: 100
Cancel: keep it empty
Logic values:  High --> 1   and  low --> 0
First Edge: Rising  

10- Press on run button until you reach final needed value, which will appear at time 1950ns 