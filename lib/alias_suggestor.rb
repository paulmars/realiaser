module Realiased

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

end
