
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lcd/version"

Gem::Specification.new do |spec|
  spec.name          = "lcd"
  spec.version       = Lcd::VERSION
  spec.authors       = ["Kaidong Hu"]
  spec.summary       = %q{LCD controller}
	spec.files				 = %w"lib/lcd.rb lib/lcd/version.rb lib/lcdext/lcd.so"
	spec.extensions    = ["ext/lcd/extconf.rb"]
end
