#!env ruby

require 'lcd'

drv = LCD::LCD.new do 
	col_num 16
	row_num 2
	rst_pin 25
	en_pin 24
	data_pins [23, 22, 21, 30]
end

loop do
	drv.puts "hello"
	sleep(1)
	drv.puts "world"
	sleep(1)
end
