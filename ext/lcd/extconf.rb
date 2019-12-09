require 'mkmf'

have_library "wiringPi" 
have_library "wiringPiDev"

$CFLAGS += " " + %q[-lm -lrc -lcrypt]
$CFLAGS += " " + "-std=c11"
$SRC = ['lcdwrap.c']

create_makefile('lcd')
