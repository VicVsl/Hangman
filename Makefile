objects = build/main.o build/io.o build/logic.o
.PHONY: clean

hangman: $(objects)
	$(CC) -g -no-pie -o "$@" $^ -lncurses

build:
	mkdir build

build/%.o: src/%.s | build
	$(CC) -g -no-pie -c -o "$@" "$<"

clean:
	rm -rf hangman build
