##############################################################
#
#  Makefile Template for MaxMSP Object on Mac systems written by Erwan Ledoux
#  derived from Makefile Template for wxMac Applications written by Mark Wilkinson
# 
#  This makefile is designed for experienced UNIX
#  developers who wish to learn how to build Mac OS X
#  packages (.app) and MaxMSP packages (.mxo) 
#  using Makefiles rather than Apple's
#  Xcode IDE.
#
#  Developed with the assistance of Kevin Hock, CHB,
#    and DialogBlocks examples.
#  Distribution of this file is subject to the terms of
#    the wxWindows License, see www.wxwidgets.org
#
##############################################################


##############################################################
#
#  A Brief Tutorial on Packages : .mxo MaxMSP objects as Bundle Mac .app
#
#  Rather than use resource forks on application
#    files, as Apple did in their Classic operating
#    system, Mac OS X uses application packages.
#  Application packages have a .app extension and
#    are actually directories which contain the
#    true executable as well as several resource
#    files.  The structure of an application
#    package is:
#
#    (program).app
#     |
#     +-- Contents
#          |
#          +--  Info.plist
#          |
#          +--  MacOS
#          |     |
#          |     +--  (program)
#          |
#          +--  PkgInfo
#          |
#          +--  Resources
#                |
#                +-- (icon file)
#
#    In this diagram "(program)" is the name of
#    the executable program.  "Contents," "MacOS,"
#    and "Resouces," are directories.  "Info.plist"
#    is an XML DTD file.  And "PkgInfo" is a text
#    file containing data.
#  This makefile generates the package directory
#    structure, and it compiles and places the
#    executabel in the MacOS directory.  This
#    makefile also creates the "PkgInfo" and
#    "Info.plist" files.  The PkgInfo file is very
#    simple.  Info.plist is an XML DTD and contains
#    several variables, which can be examined in
#    this makefile.
#  You need to supply the source code and the icon
#    file.  The icon file is copied into the
#    Resources directory of the package.
#
##############################################################

##############################################################
#
#  For the Max Objects specificity, you need to some stuff before compiling :
#
#  1. A version of the MaxSDK library is given here, but you can 
#	of course update it on : http://cycling74.com/products/sdk/
#
#	2. On Mac Systems, a call of an external .mxo object needs to use the MaxAPI
#	framework given here, in the ./MaxSDK-6.0.4/c74support/max-includes/ folder
#	The Makefile will copy this folder into your Library/Frameworks directory if
#	you don't have yet this. 
#
#	3. Note that if you want to build Max Object from C++ class, you may need to use 
#	already written encapsulation functions for C++ class, like max5cpp.h that we can find 
#	for example here : http://code.google.com/p/maxcpp/, but also here attached in the lib folder
#	3-bis. max5cpp.h needs to use the common_symbols_init() function that is not defined into max-includes. 
#	Note that you can to download somewhere its definition like here https://github.com/Cycling74/max6-sdk/blob/master/c74support/max-includes/
#	common/, but the file is also here in the lib folder and included into the compilation.
#
#	4. Last but not Least, where the .mxo object will be installed ?? In /Applications/Max5/Cycling74/max-eternals/
#	Normally, MaxMSP looks automatically to this folder once you create an object on a patch…So it should work hopefully.	
#
#	5. If COMPILATION WORKS, then you can try the example.maxhelp in order to see if Max loads in a good manner the new example object. 
#	Then try the object by using the bang or messages connected to the object just to check that each function is working.
#
#
##############################################################

##############################################################
#
#    These variables are used to compile the program.  You
#    will need to provide this information.  You may need
#    to specify the full path to the wx-config executable.
#    The output path may be left blank.  The program name
#    and object names are essential.  You may use the icon
#    file included with the wxMac distribution
#    (wxMac-2.6.1/src/mac/wxmac.icns) or create your own
#    icon using the Apple Developer Tools
#    (/Developer/Applications/Utilities/Icon Composer).
#
#     Usual problems are : 
#	A. What is the language for my object…If it is in C only, well you may better 
#	change LANGUAGE into c.
#
#	B. What is the architecture of my computer ? Type arch on a shell to see.
#	Depending on the damned diversity of Mac distributions…You should or not change the 
#	ARCH option.
#
#	C. If you need to recompile, because you change something in the Makefile (because it didn't work…)
#	don't forget to do a "make clean" to erase old files in order to let the Makefile doing new ones.
#
##############################################################

NAME=example

CXX=g++-4.2
LANGUAGE=c++

ARCH= -arch i386

FRAMEWORKS=/Library/Frameworks/
MAXAPI=/Library/Frameworks/MaxAPI.framework
MAXAUDIOAPI=/Library/Frameworks/MaxAudioAPI.framework
MAXMSPSDK=./MaxSDK-6.0.4
c74SUPPORT=$(MAXMSPSDK)/c74support
MAXINCLUDES=$(c74SUPPORT)/max-includes
MSPINCLUDES=$(c74SUPPORT)/msp-includes
JITINCLUDES=$(c74SUPPORT)/jit-includes

WXCONFIG=wx-config

OUTPUTPATH=
MAXOBJECT=$(NAME).mxo
PROGVER=1.0
OBJECTS=./lib/commonsyms.o ./src/$(NAME).o 

ICONFILE=TemplateICon.icns

##############################################################
#
#  These variables are used in the Info.plist and PkgInfo
#    files.  Aside from the company name (which should have
#    no spaces, like a domain name), you should not have
#    to modify these variables.
#
##############################################################

COMPANY=towerravens

BUNDLEPACKAGE=APPL

BUNDLESIGNATURE=????

##############################################################
#
#  It should not be necessary to modify the Makefile
#    below this line; although, you may have to make
#    changes depending on your system configuration.
#
##############################################################

BUNDLE=$(OUTPUTPATH)/$(MAXOBJECT)
MACICON=$(BUNDLE)/Contents/$(ICONFILE)
MACPKGINFO=$(BUNDLE)/Contents/PkgInfo
MACINFOPLIST=$(BUNDLE)/Contents/Info.plist

LIBS=`$(WXCONFIG) --inplace  --libs`
LINKERFLAGS= -lstdc++
WARNINGFLAGS=
OPTFLAGS=
DEBUGFLAGS=

CPPINC=`$(WXCONFIG) --inplace --cxxflags`
LDFLAGS=$(LIBS) $(LINKERFLAGS)
CPPFLAGS=$(CPPINC) $(GCCFLAGS) $(DEBUGFLAGS) $(OPTFLAGS) $(WARNINGFLAGS)

all: $(MAXAPI) $(MAXAUDIOAPI) \
$(OBJECTS) $(BUNDLE) $(BUNDLE)/Contents/MacOS/$(MAXOBJECT).mxo \
$(MACICON) $(MACPKGINFO) $(MACINFOPLIST) 

clean:
	rm -f $(OBJECTS)
	rm -fr $(BUNDLE)

help:
   @echo "Usage: make -f Makefile [all|clean|help]"

#  This builds the bundle's directory structure.
$(BUNDLE):
	@echo "==== Building bundle directory structure ===="
	mkdir -p $(OUTPUTPATH)
	mkdir -p $(BUNDLE)/Contents
	mkdir -p $(BUNDLE)/Contents/MacOS
	mkdir -p $(BUNDLE)/Contents/Resources
	@echo "\n"

#  This builds the executable right inside the bundle.
$(BUNDLE)/Contents/MacOS/$(MAXOBJECT): $(OBJECTS)
	@echo "==== Building executable ===="
	$(CXX) $(ARCH) -o $(BUNDLE)/Contents/MacOS/$(MAXOBJECT) $(OBJECTS) $(LDFLAGS)
	@echo "\n"

#  This builds the executable MaxMSP object right inside the bundle.
$(BUNDLE)/Contents/MacOS/$(MAXOBJECT).mxo : $(OBJECTS)
	@echo "==== Building MaxMSP objects  ===="
	${CXX} $(ARCH) -bundle \
	-isysroot /Developer/SDKs/MacOSX10.6.sdk \
	-F$(MAXINCLUDES) \
	-F$(MSPINCLUDES) \
	-F$(JITINCLUDES) \
	-mmacosx-version-min=10.6  \
	-framework MaxAPI \
	-framework MaxAudioAPI \
	-o $(BUNDLE)/Contents/MacOS/$(NAME) $(OBJECTS)
	@echo "\n"

#  This copies the icon file into the bundle.
$(MACICON): $(ICONFILE)
	@echo "==== Copying icon file into bundle ===="
	cp -f $(ICONFILE) $(BUNDLE)/Contents/Resources/$(ICONFILE)
	@echo "\n"

#  This creates the Contents/PkgInfo file.
$(MACPKGINFO):
	@echo "==== Creating PkgInfo ===="
	touch $(MACPKGINFO)
	@echo -n "$(BUNDLEPACKAGE)$(BUNDLESIGNATURE)" > $(MACPKGINFO)
	@echo "\n"

#  This creates the Contents/Info.plist file.
$(MACINFOPLIST):
	@echo "==== Creating Info.plist ===="
	touch $(MACINFOPLIST)
	@echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $(MACINFOPLIST)
	@echo -n "<!DOCTYPE plist PUBLIC " >> $(MACINFOPLIST)
	@echo -n "\"-//Apple Computer//DTD PLIST 1.0//EN\" " >> $(MACINFOPLIST)
	@echo "\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> $(MACINFOPLIST)
	@echo "<plist version=\"1.0\">" >> $(MACINFOPLIST)
	@echo "<dict>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleDevelopmentRegion</key>" >> $(MACINFOPLIST)
	@echo "   <string>English</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleExecutable</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(MAXOBJECT)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleIconFile</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(ICONFILE)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleName</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(MAXOBJECT)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleIdentifier</key>" >> $(MACINFOPLIST)
	@echo "   <string>com.$(COMPANY).$(PROGRAM)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleInfoDictionaryVersion</key>" >> $(MACINFOPLIST)
	@echo "   <string>6.0</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundlePackageType</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(BUNDLEPACKAGE)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleSignature</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(BUNDLESIGNATURE)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleVersion</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(PROGVER)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleShortVersionString</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(PROGVER)</string>" >> $(MACINFOPLIST)
	@echo "   <key>CFBundleGetInfoString</key>" >> $(MACINFOPLIST)
	@echo "   <string>$(MAXOBJECT), Version $(PROGVER), $(COMPANY)</string>" >> $(MACINFOPLIST)
	@echo "</dict>" >> $(MACINFOPLIST)
	@echo "</plist>" >> $(MACINFOPLIST)

# This copy the attached MaxAPI framework into the Library if it doesn't yet exist
$(MAXAPI): $(MAXINCLUDES)/MaxAPI.framework
	@echo "==== Copy MaxAPI.framework Check ===="
	test -d $(MAXAPI) || cp -r $(MAXINCLUDES)/MaxAPI.framework $(FRAMEWORKS)
	@echo "\n"

# This copy the attached MaxAudioAPI framework into the Library if it doesn't yet exist
$(MAXAUDIOAPI): $(MSPINCLUDES)/MaxAudioAPI.framework
	@echo "==== Copy MaxAudio.framework Check ===="
	test -d $(MAXAUDIOAPI) || cp -r $(MSPINCLUDES)/MaxAudioAPI.framework $(FRAMEWORKS)
	@echo "\n"

#  This compiles all the .cpp files into .o objects to be linked after
$(OBJECTS): %.o: %.cpp
	@echo "==== Building objects  ===="
	${CXX} $(ARCH) $(CPPFLAGS) -x ${LANGUAGE} \
	-Wmost -Wno-four-char-constants -Wno-unknown-pragmas \
	-isysroot /Developer/SDKs/MacOSX10.6.sdk \
	-fmessage-length=0 -pipe -Wno-trigraphs -fpascal-strings -O0 \
	-I/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/CarbonCore.framework/Versions/A/Headers/ \
	-I$(MAXINCLUDES) \
	-I$(MSPINCLUDES) \
	-I$(JITINCLUDES) \
	-I./lib/ \
	-include "$(MAXINCLUDES)/macho-prefix.pch" \
	-I/Developer/SDKs/MacOSX10.6.sdk \
	-I/Developer/Headers/FlatCarbon \
	-fasm-blocks -mmacosx-version-min=10.6 -gdwarf-2 \
	"-DDENORM_WANT_FIX = 1" \
	-c -o $@  $<
	@echo "\n"

.PHONY:    all clean
