require "rake/extensiontask"

Rake::ExtensionTask.new "lcd" do |ext|
	ext.lib_dir = 'lib/lcdext'
end

task :install do 
	system "rake", "compile"
	system "gem", "build", "lcd"
	system "gem", "install", "lcd"
end
