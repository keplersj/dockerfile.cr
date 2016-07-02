require "./spec_helper"

describe Dockerfile do
  describe "parsing the example file" do
    dockerfile = Dockerfile.from_file("#{__DIR__}/fixture/Dockerfile.example")
  end
end
