require "./instruction"
require "./instructions/*"
require "./parser"

class Dockerfile
  include Enumerable(Instruction)

  @instructions : Param

  def initialize(dockerfile_text)
    @instructions = Parser.parse(dockerfile_text)
  end

  def each
    @instructions.each do |instruction|
      case instruction[:command]
      when "FROM"
        yield Instruction::From.new(instruction[:params])
      when "MAINTAINER"
      when "RUN"
      when "CMD"
      when "LABEL"
      when "EXPOSE"
      when "ENV"
      when "ADD"
      when "COPY"
      when "ENTRYPOINT"
      when "VOLUME"
      when "USER"
      when "WORKDIR"
      when "ARG"
      when "ONBUILD"
      when "STOPSIGNAL"
      when "HEALTHCHECK"
      when "SHELL"
      end
    end
  end

  def self.from_file(path)
    parse(File.read(path))
  end

  def self.parse(text)
    new text
  end
end
