JAVA_SRC = $(shell find src -name '*.java')
# Change this to the path of your antlr jar
ANTLR_JAR = /usr/local/lib/antlr-4.13.1-complete.jar
.PHONY: build
build: $(JAVA_SRC)
	javac -d bin $(JAVA_SRC) -cp $(ANTLR_JAR) -encoding UTF-8

.PHONY: clean
clean:
	find bin -name '*.class' -or -name '*.jar' | xargs rm -f

.PHONY: run
run:
java -cp bin:/usr/local/lib/antlr-4.13.1-complete.jar Compiler