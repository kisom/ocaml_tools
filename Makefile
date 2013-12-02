TARGETS = cat wc

all: $(TARGETS)

common: src/common.ml src/common.mli
	ocamlopt -o src/common.cmi -c src/common.mli
	ocamlopt -a -I src/ -o lib/common.cmxa src/common.ml

wget: common src/wget.ml src/wget.mli
	ocamlopt -o src/wget.cmi -c src/wget.mli
	ocamlopt -I src/ -o lib/wget.cmx -c src/wget.ml 
	ocamlopt -o bin/wget unix.cmxa netclient.cmxa lib/wget.cmx lib/common.cmxa

cat: common src/cat.ml src/cat.mli
	ocamlopt -o src/cat.cmi -c src/cat.mli
	ocamlopt -I src/ -o lib/cat.cmxa -c src/cat.ml 
	ocamlopt -o bin/cat unix.cmxa lib/cat.cmx lib/common.cmxa

wc: common src/wc.ml src/wc.mli
	ocamlopt -o src/wc.cmi -c src/wc.mli
	ocamlopt -I src/ -o lib/wc.cmxa -c src/wc.ml 
	ocamlopt -o bin/wc unix.cmxa lib/wc.cmx lib/common.cmxa

clean:
	rm -f lib/*.cm* lib/*.a lib/*.o
	rm -f bin/wc bin/cat bin/wget
