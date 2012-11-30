directory_name = File.dirname(__FILE__)

require File.join(directory_name, 'alias_line.rb')
require File.join(directory_name, 'alias_suggestor.rb')
require File.join(directory_name, 'command_success_counter.rb')

csc = Realiased::CommandSuccessCounter.new

path = File.expand_path("~/.alias.cache")
suggestor = Realiased::AliasSuggestor.new(path)

input = ARGF.read.strip
suggested = suggestor.suggest(input)

if suggested.nil?
  csc.correct!(input)
  csc.append_command(input, true)
  puts "#{csc.score}"
else
  csc.mistake!(input)
  csc.append_command(input, false)
  puts "#{suggested} (#{csc.score})"
end
