require "./spec_helper"

describe DockerfileParser do
  describe "parsing the example file" do
    dockerfile = DockerfileParser.load("#{__DIR__}/fixture/Dockerfile.example")

    it "has a predictable output" do
      dockerfile.should eq([
          {command: "FROM",       params: ["debian", "jessie"]},
          {command: "MAINTAINER", params: "Nikolay Yurin <yurinnick@outlook.com>"},
          {command: "RUN",        params: [
                                    ["apt-get", "update"],["&"],
                                    ["apt-get", "install", "-y", "nginx"]]},
          {command: "RUN",        params: [
                                    ["rm", "-rf", "/var/lib/apt/lists/*"],
                                    ["&"],
                                    ["chown", "-R", "www-data:www-data", "/var/lib/nginx"]]},
          {command: "VOLUME",     params: "/var/www/html"},
          {command: "WORKDIR",    params: "/etc/nginx"},
          {command: "COPY",       params: {src: "site-example.conf",
                                             dst: "/etc/nginx/sites-available/site-example.conf"}},
          {command: "COPY",       params: {src: "index.html.tmpl",
                                             dst: "/var/www/html/index.html"}},
          {command: "EXPOSE",     params: "80"},
          {command: "CMD",        params: ["nginx", "-g", "daemon off;"]}
      ])
    end
  end

  describe "parsing an empty Dockerfile" do
    dockerfile = DockerfileParser.load("#{__DIR__}/fixture/Dockerfile.empty")

    it "has a predictable output" do
      dockerfile.should eq([] of NamedTuple(command: String))
    end
  end

  describe "parsing nginx example" do
    dockerfile = DockerfileParser.load("#{__DIR__}/fixture/Dockerfile.nginx_example")

    it "has a predictable output" do
      dockerfile.should eq([
        {command: "FROM", params: ["ubuntu"]},
        {command: "MAINTAINER", params: "Victor Vieux <victor@docker.com>"},
        {command: "LABEL", params: "Description=\"This image is used to start the foobar executable\" Vendor=\"ACME Products\" Version=\"1.0\""},
        {command: "RUN", params: [
            ["apt-get", "update"],
            ["&"],
            ["apt-get", "install", "-y", "inotify-tools", "nginx", "apache2", "openssh-server"]
          ]
        }
      ])
    end
  end

  describe "parsing Firefox over VNC example" do
    dockerfile = DockerfileParser.load("#{__DIR__}/fixture/Dockerfile.firefox_over_vnc_example")

    it "has a predictable output" do
      dockerfile.should eq([
        {command: "FROM", params: ["ubuntu"]},
        {command: "RUN", params: [
          ["apt-get", "update"], ["&"], ["apt-get", "install", "-y", "x11vnc", "xvfb", "firefox"]
        ]},
        {command: "RUN", params: [
          ["mkdir", "~/.vnc"]
        ]},
        {command: "RUN", params: [
          ["x11vnc", "-storepasswd", "1234", "~/.vnc/passwd"]
        ]},
        {command: "RUN", params: [
          ["bash", "-c", "'echo", "\"firefox\"", ">>", "/.bashrc'"]
        ]}, {command: "EXPOSE", params: "5900"},
        {command: "CMD", params: ["x11vnc", "-forever", "-usepw", "-create"]}
      ])
    end
  end

  describe "parsing multiple images example" do
    dockerfile = DockerfileParser.load("#{__DIR__}/fixture/Dockerfile.multiple_images_example")

    it "has a predictable output" do
      dockerfile.should eq([
        {command: "FROM", params: ["ubuntu"]},
        {command: "RUN", params: [
          ["echo", "foo", ">", "bar"]
        ]},
        {command: "FROM", params: ["ubuntu"]},
        {command: "RUN", params: [
          ["echo", "moo", ">", "oink"]
        ]}
      ])
    end
  end
end
