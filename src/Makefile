TARGET = bs2bconvert
LIBS = -Wl,-Bstatic -lsndfile -lFLAC -lvorbis -lvorbisenc -logg -Wl,-Bdynamic -lm 
CC = gcc
CFLAGS = -g -O2 -Wall

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -no-pie -Wall $(LIBS) -o $@

clean:
	-rm -f *.o
	-rm -f $(TARGET)
