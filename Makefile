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
COMMON := $(LIBDIR)/common.cmxa

vpath %.ml src
vpath %.mli src

all: $(BINARIES)

libs: $(COMMON)

$(LIBDIR)/common.cmxa: $(SRCDIR)/common.mli $(SRCDIR)/common.ml
	@echo "building $(COMMON)..."
	@echo "compiling interface $(LIBDIR)/common.cmi"
	$(FIND) $(BYTE) -o $(LIBDIR)/common.cmi -c $(SRCDIR)/common.mli
	$(FIND) $(NATIVE) -o $(LIBDIR)/common.cmxa -a -I $(LIBDIR) $(SRCDIR)/common.ml

wget: $(COMMON) $(LIBDIR)/wget.cmi $(LIBDIR)/wget.cmx
	@echo "building wget binary..."
	$(FIND) $(NATIVE) $(PACKAGES) -o $(BINDIR)/$@ $(INCLUDES) $(COMMON) $(LIBDIR)/wget.cmx

$(LIBDIR)/%.cmi: $(SRCDIR)/%.mli
	@echo "compiling interface $*.mli"
	$(FIND) $(BYTE) -o $@ -c $<

$(LIBDIR)/%.cmx: $(SRCDIR)/%.ml 
	@echo "compiling $*.ml..."
	$(FIND) $(NATIVE) -o $@ -I $(LIBDIR) $(INCDIRS) -c $(SRCDIR)/$*.ml

clean: 
	rm -rf $(LIBDIR)/*.* $(BINDIR)/*

.PHONY: clean all libs
