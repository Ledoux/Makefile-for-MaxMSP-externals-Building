Makefile-for-MaxMSP-externals-Building
======================================

  Building .mxo Max Objects without XCode for Mac Systems
  Installation of the example object will be like this:
  
  A. In a shell
  
  	```
		git clone git@github.com:Ledoux/Makefile-for-MaxMSP-externals-Building.git
		cd Makefile-for-MaxMSP-externals-Building && make
  	```
  
  B. If it's not working, open the Makefile that recommends 
  you some option settings that would be necessary for your 
  particular system. Don't forget each time to use "make clean" 
  to delete old not working executable files. 
  
  C. If COMPILATION WORKS, then you can try the example.maxhelp in 
  order to see if Max loads in a good manner the new example object. 
  Then try the object by using the bang or messages connected to the 
  object just to check that each function is working.
	
  The example object is a very basic object, but so you can then drag
  any .cpp files into the src folder and then make them compiled into your 
  Max object. You can change the name of the object by setting the variable 
  NAME in the Makefile. Pay attention that the .cpp file that has 
  
  
