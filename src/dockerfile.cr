# Encoding: utf-8
# @author Nikolay Yurin <yurinnick@outlook.com>
# Ported to Crystal by Kepler Sticka-Jones <kepler@stickajones.org>

require "yaml"

# DockerfileParser main class
class DockerfileParser
  COMMANDS = %w(FROM MAINTAINER RUN CMD EXPOSE ENV ADD COPY ENTRYPOINT
                 VOLUME USER WORKDIR ONBUILD)

  # Parse Dockerfile from specified path
  # @return [Array<Hash>] parser Dockerfile
  def self.load(path)
    dockerfile_array = split_dockerfile(File.read(path))
    parse_commands(dockerfile_array).each_cons(2).map do |item|
      process_steps(dockerfile_array, item[0], item[1][:index])
    end.to_a
  end

  private def self.split_dockerfile(str)
    str.gsub(/(\s\\\s)+/i, "").gsub("\n", " ").squeeze(" ").split(" ")
  end

  private def self.parse_commands(dockerfile_array)
    dockerfile_array.map_with_index do |cmd, index|
      { index: index, command: cmd } if COMMANDS.includes?(cmd)
    end.compact << { index: dockerfile_array.size, command: "EOF" }
  end

  private def self.process_steps(dockerfile_array, step, next_cmd_index)
    { command: step[:command],
      params: split_params(
        step[:command],
        dockerfile_array[step[:index] + 1..next_cmd_index - 1]
      )
    }
  end

  private def self.split_params(cmd, params)
    case cmd
    when "FROM" then params.join("").split(":")
    when "RUN" then params.join(" ").split(/\s(\&|\;)+\s/).map do |param|
      param.split
    end
    when "ENV" then
      { name: params[0], value: params[1..-1].join(" ") }
    when "COPY", "ADD" then { src: params[0], dst: params[1] }
    else
      params = params.join(' ') if params.is_a?(Array)
      YAML.parse(params.to_s)
    end
  end
end
