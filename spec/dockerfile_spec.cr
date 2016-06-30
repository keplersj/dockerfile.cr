require "./spec_helper"

describe DockerfileParser do
  dockerfile = DockerfileParser.load("#{__DIR__}/fixture/Dockerfile")

  it "follows the example" do
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
