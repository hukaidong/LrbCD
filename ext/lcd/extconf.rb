require 'mkmf'

have_library "wiringPi" 
have_library "wiringPiDev"

$CFLAGS += " " + "-std=c11 -pedantic"
$CFLAGS += " " + %q[-lm -lrc -lcrypt]
$SRC = ['lcdwrap.c']

create_makefile('lcd')
