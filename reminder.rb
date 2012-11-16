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

class CommandSuccessCounter

  require 'fileutils'
  require 'yaml'

  @@default_file_location = "~/.realias_success_metrics"

  @@positive_points = 1
  @@negative_points = 50

  attr_accessor :count, :data, :path

  def initialize
    if !file_exists?
      @data = {}
      self.write
    else
      self.load
    end
    set_defaults!
  end

  def count
    self.data[:count]
  end

  def high_score
    self.data[:high_score]
  end

  def increment!
    self.data[:count] = self.data[:count] + @@positive_points
    mark_high_score
    self.write
  end

  def mistake!
    self.data[:count] = [self.data[:count] - @@negative_points, 0].max
    self.write
  end

  def mark_high_score
    return unless high_score?
    self.data[:high_score] = count
    self.data[:high_score_at] = Time.now
  end

protected

  def high_score?
    count > high_score
  end

  def set_defaults!
    @data[:count] ||= 0
    @data[:high_score] ||= 0
    @data[:high_score_at] ||= Time.now
  end

  def load
    self.data = YAML.load(File.new(path, 'r').read)
  end

  def write
    file = File.new(path, 'w')
    file << data.to_yaml
    file.close
  end

  def path
    File.expand_path(@@default_file_location)
  end

  def touch
    FileUtils.touch(path)
  end

  def file_exists?
    File.exists?(path)
  end

end

csc = CommandSuccessCounter.new

path = File.expand_path("~/.alias.cache")
reader = AliasSuggestor.new(path)

input = ARGF.read.strip
suggested = reader.suggest(input)
if suggested.nil?
  csc.increment!
  puts "#{csc.count}"
else
  csc.mistake!
  puts "#{suggested} (#{csc.count})"
end
