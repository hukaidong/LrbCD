#include <ruby.h>
#include <lcd.h>
#include <wiringPi.h>

#ifdef __cplusplus
extern "C" {
#endif

#define _checkAndFillInt(src, dest) do {\
	FIXNUM_P(src);\
	dest = FIX2INT(src);\
} while(0)

VALUE 
_wrap_lcd_init(int argc, VALUE *argv, VALUE _) {
	int s[13];            // Values feed into lcdInit(*)

	if ((argc < 13) || (argc > 13)) {
    rb_raise(rb_eArgError, "wrong # of arguments(%d for 13)",argc);
  }

	for (int i=0; i<13; i++) {
		_checkAndFillInt(argv[i], s[i]);
	}

	int fd = lcdInit(s[0], s[1], s[2], s[3], s[4],
									 s[5], s[6], s[7], s[8], s[9],
									 s[10], s[11], s[12]);

	if (fd < 0) {
		rb_raise(rb_eRuntimeError, "LCD initialize failed with error code %d", fd);
	}

	return INT2FIX(fd);
}

VALUE _wrap_lcd_position(VALUE _, VALUE fd_val, VALUE x_val, VALUE y_val) { 
	FIXNUM_P(fd_val); int fd = FIX2INT(fd_val);
	FIXNUM_P(x_val);  int x = FIX2INT(x_val);
	FIXNUM_P(y_val);  int y = FIX2INT(y_val);
	lcdPosition(fd, x, y);
	return Qnil;
}

VALUE
_wrap_lcd_puts(VALUE _, VALUE fd_val, VALUE chr_val) {
	FIXNUM_P(fd_val); int fd = FIX2INT(fd_val);
	char *chr = StringValuePtr(chr_val);
	lcdPuts(fd, chr);
	return Qnil;
}

VALUE
_wrap_lcd_putchar(VALUE _, VALUE fd_val, VALUE chr_val) {
	_wrap_lcd_puts(_, fd_val, chr_val);
	return Qnil;
}

VALUE
_wrap_lcd_clear(VALUE _, VALUE fd_val) {
	FIXNUM_P(fd_val); int fd = FIX2INT(fd_val);
	lcdClear(fd);
	return Qnil;
}

VALUE
_wrap_lcd_display(VALUE _, VALUE fd_val, VALUE st_val) {
	FIXNUM_P(fd_val); int fd = FIX2INT(fd_val);
	FIXNUM_P(st_val); int st = FIX2INT(st_val);
	lcdDisplay(fd, st);
	return Qnil;
}

VALUE
_wrap_lcd_cursor(VALUE _, VALUE fd_val, VALUE st_val) {
	FIXNUM_P(fd_val); int fd = FIX2INT(fd_val);
	FIXNUM_P(st_val); int st = FIX2INT(st_val);
	lcdCursor(fd, st);
	return Qnil;
}

VALUE
_wrap_lcd_cursor_blink(VALUE _, VALUE fd_val, VALUE st_val) {
	FIXNUM_P(fd_val); int fd = FIX2INT(fd_val);
	FIXNUM_P(st_val); int st = FIX2INT(st_val);
	lcdCursorBlink(fd, st);
	return Qnil;
}

void 
Init_lcd(void) {
	wiringPiSetup();

	VALUE lcd = rb_define_module("LCD");
	lcd = rb_define_module_under(lcd, "LcdProto");
	rb_define_singleton_method(lcd, "lcdInit", _wrap_lcd_init, -1);
	rb_define_singleton_method(lcd, "lcdClear", _wrap_lcd_clear, 1);
	rb_define_singleton_method(lcd, "lcdDisplay", _wrap_lcd_display, 2);
	rb_define_singleton_method(lcd, "lcdCursor", _wrap_lcd_cursor, 2);
	rb_define_singleton_method(lcd, "lcdCursorBilnk", _wrap_lcd_cursor_blink, 2);
	rb_define_singleton_method(lcd, "lcdPuts", _wrap_lcd_puts, 2);
	rb_define_singleton_method(lcd, "lcdPutchar", _wrap_lcd_putchar, 2);
	rb_define_singleton_method(lcd, "lcdPosition", _wrap_lcd_position, 3);
}

#ifdef __cplusplus
}
#endif
