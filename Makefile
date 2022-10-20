PROJECT=libprint_func.so

CC?=gcc

SOURCES=$(wildcard src/*.c)

OBJECTS=$(patsubst %.c,%.o,$(SOURCES))

.PHONY:clean

CFLAG = -Iinclude -fPIC -shared
LD_FLAG = -fPIC -s -Wl,-z,relro,-z,now,-z,noexecstack -fstack-protector-all

$(PROJECT): $(OBJECTS)
	mkdir -p lib
	$(CC)  -shared -o lib/$@ $(patsubst %.o,obj/%.o,$(notdir $(OBJECTS))) $(LD_FLAG)
	@echo "finish $(PROJECT)"

.c.o:
	@mkdir -p obj
	$(CC) -c $< $(CFLAG) -o obj/$(patsubst %.c,%.o,$(notdir $<))

clean:
	-rm -rf obj lib
	@echo "clean up"

