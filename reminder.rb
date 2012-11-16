# require 'rub  ygems'
# require 'awesome_print'

class AliasLine

  attr_accessor :shell_alias, :shell_command, :alias_line

  def initialize(alias_line)
    @alias_line = alias_line
    splits = @alias_line.split('=')
    @shell_command = splits.first.strip
    @shell_alias = splits.last.strip.gsub("'",'')
  end

  def valid?
    !nocorrect? && !transpose?
  end

  def to_s
    "#{@shell_command}: #{@shell_alias}"
  end

private

  def transpose?
    ["ls"].include?(@shell_alias)
  end

  def nocorrect?
    @alias_line.scan("nocorrect") != []
  end
end

class AliasSuggestor
  attr_accessor :alias_lines

  def initialize(path)
    @alias_lines = {}
    File.new(path,'r').each do |line|
      alias_line = AliasLine.new(line)
      next unless alias_line.valid?
      @alias_lines[alias_line.shell_alias] = alias_line.shell_command
    end
  end

  def suggest(command)
    @alias_lines[command]
  end
end

path = File.expand_path("~/.alias.cache")
reader = AliasSuggestor.new(path)

# exit if ARGF.nil?

input = ARGF.read.strip
suggested = reader.suggest(input)
if suggested.nil?
  # puts "Can't improve! '#{input}' '#{suggested}'"
else
  # puts "Needs work! '#{input}' '#{suggested}'"
  puts suggested
end
