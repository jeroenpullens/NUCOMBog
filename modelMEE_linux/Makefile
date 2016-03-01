# Free Pascal Compiler
FPC=/usr/bin/fpc
# Sources od the project
SOURCES=modelMEE.pas maincl.pas plant.pas readwrite.pas water.pas

# debug flags
PCFLAGS=-Scghi -Cg -O1 
# Symbols define
PCDEFINE=-dLCL -dLCLgtk2 -dBorland -dVer150 -dDelphi7 -dCompiler6_Up -dPUREPASCAL
# Add unit paths 
UDIR=
#UDIR=-Fu/usr/share/lazarus/1.4.2/lcl/units/x86_64-linux -Fu/usr/share/lazarus/1.4.2/components/lazutils/lib/x86_64-linux -Fu/usr/share/lazarus/1.4.2/lcl/units/x86_64-linux/gtk2 

modelMEE: $(SOURCES)
	$(FPC) $(PCFLAGS) $(UDIR) $(PCDEFINE) modelMEE.pas

clean:
	rm -f *.ppu
	rm -f *.o
	rm -f *.or
	rm -f modelMEE
