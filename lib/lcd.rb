require "lcd/version"
require "lcdext/lcd"

module LCD

	class LCD
		attr_reader :fd
		attr_reader :cols
		attr_reader :rows

		def initialize(&block) 
			if block_given?
				config = LCD_CONFIG.new
				config.instance_eval &block
				config._update self
			else
				raise "en?"
			end

			@scrline = ''
			@wrap = false
			@scroll = true

			self.cursor = [0, 0]
		end

		def screen_clear
			LcdProto.lcdClear(@fd)
			scrline = ''
		end

		alias :clear :screen_clear
		alias :clean :screen_clear

		# cursor will be defined follow 'row / col'
		# as tty conventions
		def cursor=(cur)
			LcdProto.lcdPosition(@fd, cur[1], cur[0])
			@cursor = cur
		end
		
		def _lcd_puts(str)
			LcdProto.lcdPuts(@fd, str)
		end

		def puts(str)
			str = str.ljust(@cols)
			str = str[0..@cols] unless @wrap
			if @cursor[0] == 0
				_lcd_puts str 
				self.cursor = [1, 0]
			else
				self.cursor = [0, 0]
				_lcd_puts @scrline
				self.cursor = [1, 0]
				_lcd_puts str
			end
			@scrline = str
		end

		def nolive 
			LcdProto.lcdCursor(@fd, 0)
			LcdProto.lcdCursorBlink(@fd, 0)
		end

		def live 
			LcdProto.lcdCursor(@fd, 1)
			LcdProto.lcdCursorBlink(@fd, 1)
		end

	end

	class LCD_CONFIG
		def row_num num
			@rowp = num
		end

		def col_num num
			@colp = num
		end

		def data_pins nums
			unless [4, 8].include? nums.size
				raise "Only 4 pin or 8 pin controller would be configured"
			end
			@datap = nums
		end

		def rst_pin num
			@rstp = num
		end

		def en_pin num
			@enp = num
		end

		def _update lcd
			args = [@rowp, @colp, @datap.size, @rstp, @enp, *@datap]

			if args.size == 9
				args << [0, 0, 0, 0]
				args.flatten!
			end

			if args.size != 13 || args.any?(&:nil?)
				STDERR.puts args, args.size
				STDERR.puts args.any?(&:nil?)
				raise "Configure error"
			end

			lcd.instance_exec(@colp, @rowp) do |c,r|
				@fd = LcdProto.lcdInit *args
				@cols = c
				@rows = r
			end
		end
	end
end
