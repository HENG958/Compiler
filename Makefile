.PHONY: build
build:
    find -name '*.java' | xargs javac -d bin -cp /ulib/antlr-4.13.1-complete.jar

.PHONY: run
run:
    cd bin && java -cp /ulib/antlr-4.13.1-complete.jar:. Compiler

.PHONY: Sema
Sema:
    ./testcases/sema/scripts/test.bash 'java -cp /ulib/antlr-4.13.1-complete.jar:bin Main' $(file)

.PHONY: Semall
Semall:
    time -p ./testcases/sema/scripts/test_all.bash 'java -cp /ulib/antlr-4.13.1-complete.jar:bin Main' testcases/sema/