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

  def increment(last_line)
    if self.data[:last_line] != last_line
      self.data[:last_line] = last_line
      self.data[:count] = self.data[:count] + @@positive_points
      mark_high_score
      self.write
    end
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
