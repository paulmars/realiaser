module Realiased

class CommandSuccessCounter

  require 'fileutils'
  require 'yaml'

  @@default_file_location = "~/.realiaser_success_metrics"
  @@history_file = "~/.realiaser_history"

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

  def increment(last_line)
    if self.data[:last_line] != last_line
      self.data[:last_line] = last_line
      self.data[:count] = self.data[:count] + @@positive_points
      mark_high_score
      self.write
    end
  end

  def mistake!(input)
    self.data[:mistaken_command] = input
    self.data[:count] = [self.data[:count] - @@negative_points, 0].max
    self.write
  end

  def append_command(command, increment)
    if increment
      history_file << "#{command}:#{@@positive_points}\n"
    else
      history_file << "#{command}:#{@@negative_points}\n"
    end
    history_file.close
  end

protected

  def mark_high_score
    return unless high_score?
    self.data[:high_score] = count
    self.data[:high_score_at] = Time.now
  end

  def high_score?
    count > high_score
  end

  def set_defaults!
    @data[:count] ||= 0
    @data[:high_score] ||= 0
    @data[:high_score_at] ||= Time.now
  end

  def history_file
    File.new(history_path, 'a')
  end

  def load
    self.data = YAML.load(File.new(path, 'r').read)
  end

  def write
    file = File.new(path, 'w')
    file << data.to_yaml
    file.close
  end

  def history_path
    File.expand_path(@@history_file)
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

end