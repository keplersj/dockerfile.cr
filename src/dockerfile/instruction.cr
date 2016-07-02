require "yaml"

class Dockerfile
  alias Param = Array(NamedTuple(command: String, params: Array(Array(String)) |
    Array(String) |
    NamedTuple(name: String, value: String) |
    NamedTuple(src: String, dst: String) |
    YAML::Any))

  abstract struct Instruction
    property params

    def initialize(@params : Param)
    end
  end
end
