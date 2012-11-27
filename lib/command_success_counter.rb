module Realiased

class CommandSuccessCounter

  require 'fileutils'
  require 'yaml'

  @@default_file_location = "~/.realiaser_success_metrics"
  @@history_file = "~/.realiaser_history"

  @@positive_points = 1
  @@negative_points = 50

  def initialize
    if !file_exists?
      @data = {}
      self.write
    else
      self.load
    end
    set_defaults!
  end

  def score
    @data[:score]
  end

  def high_score
    @data[:high_score]
  end

  def high_score_at
    @data[:high_score_at]
  end

  def increment(last_line)
    if @data[:last_line] != last_line
      @data[:last_line] = last_line
      @data[:score] = @data[:score] + @@positive_points
      mark_high_score
      self.write
    end
  end

  def mistake!(input)
    @data[:mistaken_command] = input
    @data[:score] = [@data[:score] - @@negative_points, 0].max
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
    @data[:high_score] = score
    @data[:high_score_at] = Time.now
  end

  def high_score?
    score > high_score
  end

  def set_defaults!
    @data[:score] ||= 1
    @data[:high_score] ||= 1
  end

  def history_file
    File.new(history_path, 'a')
  end

  def load
    @data = YAML.load(File.new(path, 'r').read)
  end

  def write
    file = File.new(path, 'w')
    file << @data.to_yaml
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