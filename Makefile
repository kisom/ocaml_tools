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
TOPDIR := /usr/lib/ocaml
INCDIRS := -I $(TOPDIR)/netclient
PACKAGES := -linkpkg -package unix,netclient
BINARIES := wget xxtea
COMMON := $(LIBDIR)/common.cmxa

vpath %.ml src
vpath %.mli src

all: $(BINARIES)

libs: $(COMMON)

$(LIBDIR)/common.cmxa: $(SRCDIR)/common.mli $(SRCDIR)/common.ml
	@echo "building $(COMMON)..."
	@echo "compiling interface $(LIBDIR)/common.cmi"
	$(FIND) $(BYTE) -o $(LIBDIR)/common.cmi -c $(SRCDIR)/common.mli
	@echo "compiling common library..."
	$(FIND) $(NATIVE) -o $(LIBDIR)/common.cmx -I $(LIBDIR) -c $(SRCDIR)/common.ml
	@echo "building .cmxa..."
	$(FIND) $(NATIVE) -o $(LIBDIR)/common.cmxa -I $(LIBDIR) -a $(LIBDIR)/common.cmx

wget: $(COMMON) $(LIBDIR)/wget.cmi $(LIBDIR)/wget.cmx
	@echo "building wget binary..."
	$(FIND) $(NATIVE) $(PACKAGES) -o $(BINDIR)/$@ $(INCLUDES) $(COMMON) $(LIBDIR)/wget.cmx

xxtea: $(COMMON) $(LIBDIR)/xxtea.cmi $(LIBDIR)/xxtea.cmx
	@echo "building xxtea binary..."
	$(FIND) $(NATIVE) $(PACKAGES) -o $(BINDIR)/$@ $(INCLUDES) $(COMMON) $(LIBDIR)/xxtea.cmx

cat: $(COMMON) $(LIBDIR)/cat.cmi $(LIBDIR)/cat.cmx
	@echo "building cat binary..."
	$(FIND) $(NATIVE) $(PACKAGES) -o $(BINDIR)/$@ $(INCLUDES) $(COMMON) $(LIBDIR)/cat.cmx

$(LIBDIR)/%.cmi: $(SRCDIR)/%.mli
	@echo "compiling interface $*.mli"
	$(FIND) $(BYTE) -o $@ -c $<

$(LIBDIR)/%.cmx: $(SRCDIR)/%.ml 
	@echo "compiling $*.ml..."
	$(FIND) $(NATIVE) -o $@ -I $(LIBDIR) $(INCDIRS) -c $(SRCDIR)/$*.ml

clean: 
	rm -rf $(LIBDIR)/*.* $(BINDIR)/*

.PHONY: clean all libs
