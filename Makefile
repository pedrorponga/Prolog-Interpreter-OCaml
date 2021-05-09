# variables
TARGET = Jalon1 Jalon2 Jalon3 Interpreter
OCAMLC = ocamlfind ocamlc -package ounit2 -linkpkg str.cma
OCAMLCFLAGS = -g -I src
OCAMLLEX = ocamllex
OCAMLLEXFLAGS =
OCAMLDEP = ocamldep
MENHIR = menhir
MENHIRFLAGS = --explain
LIBS =

# sources générées automatiquement (par menhir, camllex)
AUTOGEN = src/lexer.ml src/parser.ml src/parser.mli

# sources à compiler
MLFILES = src/ast.ml src/parser.ml src/lexer.ml src/main.ml src/unify.ml src/solve.ml src/backtracker.ml src/interpret.ml src/tests.ml
JALON1ML = src/Jalon1.ml
JALON2ML = src/Jalon2.ml
JALON3ML = src/Jalon3.ml
INTERPRETERML = src/Interpreter.ml
MLIFILES = src/parser.mli

# règles de compilation

CMOFILES = $(MLFILES:%.ml=%.cmo)
CMOJALON1 = $(JALON1ML:%.ml=%.cmo)
CMOJALON2 = $(JALON2ML:%.ml=%.cmo)
CMOJALON3 = $(JALON3ML:%.ml=%.cmo)
CMOINTERPRETER = $(INTERPRETERML:%.ml=%.cmo)

all: $(TARGET)

Jalon1: $(CMOFILES) $(CMOJALON1)
	$(OCAMLC) -o $@ $(OCAMLCFLAGS) $(LIBS) $+

Jalon2: $(CMOFILES) $(CMOJALON2)
	$(OCAMLC) -o $@ $(OCAMLCFLAGS) $(LIBS) $+

Jalon3: $(CMOFILES) $(CMOJALON3)
	$(OCAMLC) -o $@ $(OCAMLCFLAGS) $(LIBS) $+

Interpreter: $(CMOFILES) $(CMOINTERPRETER)
	$(OCAMLC) -o $@ $(OCAMLCFLAGS) $(LIBS) $+

%.cmo: %.ml %.cmi
	$(OCAMLC) $(OCAMLCFLAGS) $(LIBS) -c $*.ml

%.cmi: %.mli
	$(OCAMLC) $(OCAMLCFLAGS) $(LIBS) -c $*.mli

%.cmo: %.ml
	$(OCAMLC) $(OCAMLCFLAGS) $(LIBS) -c $*.ml

%.ml: %.mll
	$(OCAMLLEX) $(OCAMLLEXFLAGS) $*.mll

%.ml %.mli: %.mly
	$(MENHIR) $(MENHIRFLAGS) $*.mly


# nettoyage
clean:
	rm -f depend $(AUTOGEN) $(TARGET)
	rm -f `find . -name "*.o"`
	rm -f `find . -name "*.a"`
	rm -f `find . -name "*.cm*"`
	rm -f `find . -name "*~"`
	rm -f `find . -name "\#*"`
	rm -f `find . -name "*.conflicts"`

.phony:	clean


# dépendances
depend: $(MLFILES) $(JALON1ML) $(JALON2ML) $(JALON3ML) $(INTERPRETERML) $(MLIFILES)
	$(OCAMLDEP) $+ > depend

include depend
