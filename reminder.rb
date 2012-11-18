directory_name = File.dirname(__FILE__)

require File.join(directory_name, 'lib/alias_line.rb')
require File.join(directory_name, 'lib/alias_suggestor.rb')
require File.join(directory_name, 'lib/command_success_counter.rb')

csc = CommandSuccessCounter.new

path = File.expand_path("~/.alias.cache")
reader = AliasSuggestor.new(path)

input = ARGF.read.strip
suggested = reader.suggest(input)

if suggested.nil?
  csc.increment(input)
  puts "#{csc.count}"
else
  csc.mistake!(input)
  puts "#{suggested} (#{csc.count})"
end
