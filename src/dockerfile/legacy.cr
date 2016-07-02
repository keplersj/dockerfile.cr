# @author Nikolay Yurin <yurinnick@outlook.com>

require "./version"
require "./parser"

# DockerfileParser main class
class DockerfileParser
  COMMANDS = Dockerfile::Parser::COMMANDS

  # Parse Dockerfile from specified path
  # @return [Array<NameTuple>] parser Dockerfile
  def self.load(path)
    Dockerfile::Parser.from_file(path)
  end
end
