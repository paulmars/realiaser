module Realiased
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
end
