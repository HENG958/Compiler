.PHONY: build
build:
	find -name '*.java' | xargs javac -d bin -cp /usr/local/lib/antlr-4.13.1-complete.jar

.PHONY: run
run:
	cd bin && java -cp /usr/local/lib/antlr-4.13.1-complete.jar:. Compiler