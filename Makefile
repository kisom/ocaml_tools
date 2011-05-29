#################
### COMPILERS ###
#################
BYTE := ocamlc
NATIVE := ocamlopt
FIND := ocamlfind

####################
### ORGANISATION ###
####################
# project is organised into a couple directories
# contains *.ml and *.mli
SRCDIR := src

# contains *.cm? *.o
LIBDIR := lib

# contains the completed binaries
BINDIR := bin


#######################
### PACKAGES / LIBS ###
#######################
# all the directories with the special libraries
INCDIRS := -I /usr/lib/ocaml/netclient
PACKAGES := -linkpkg -package unix,netclient
BINARIES := wget

vpath %.ml src
vpath %.mli src

all: $(BINARIES)

wget: $(LIBDIR)/wget.cmi $(LIBDIR)/wget.cmx 
	$(FIND) $(NATIVE) $(PACKAGES) -o $(BINDIR)/$@ $(INCLUDES) $(LIBDIR)/wget.cmx

$(LIBDIR)/%.cmi: $(SRCDIR)/%.mli
	$(FIND) $(BYTE) -o $@ -c $<

$(LIBDIR)/%.cmx: $(SRCDIR)/%.ml
	$(FIND) $(NATIVE) -o $@ -I $(LIBDIR) $(INCDIRS) -c $<

clean: 
	rm -rf $(LIBDIR)/*.* $(BINDIR)/*

.PHONY: clean all