dockerfile.cr
=============

Dockerfile parser library, ported from [@yurinnick](https://github.com/yurinnick)'s [Ruby library](https://github.com/yurinnick/ruby-dockerfile-parser).

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  dockerfile:
    github: keplersj/dockerfile.cr
```

## Usage

example.cr

```crystal

require 'dockerfile'

puts DockerfileParser.load('Dockerfile')
```

Dockerfile

```Dockerfile

FROM debian:jessie
MAINTAINER Nikolay Yurin <yurinnick@outlook.com>

RUN apt-get update && \
    apt-get install -y nginx

RUN rm -rf /var/lib/apt/lists/* && \
    chown -R www-data:www-data /var/lib/nginx

VOLUME /var/www/html
WORKDIR /etc/nginx
COPY site-example.conf /etc/nginx/sites-available/site-example.conf
COPY index.html.tmpl /var/www/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

output

```crystal
[
    {:command=>"FROM",       :params=>["debian", "jessie"]}
    {:command=>"MAINTAINER", :params=>"Nikolay Yurin <yurinnick@outlook.com>"}
    {:command=>"RUN",        :params=>["apt-get update",
                                       "apt-get install -y nginx"]}
    {:command=>"RUN",        :params=>["rm -rf /var/lib/apt/lists/*",
                                       "chown -R www-data:www-data /var/lib/nginx"]}
    {:command=>"VOLUME",     :params=>"/var/www/html"}
    {:command=>"WORKDIR",    :params=>"/etc/nginx"}
    {:command=>"COPY",       :params=>{:src=>"site-example.conf",
                                       :dst=>"/etc/nginx/sites-available/site-example.conf"}}
    {:command=>"COPY",       :params=>{:src=>"index.html",
                                       :dst=>"/var/www/html/index.html"}}
    {:command=>"EXPOSE",     :params=>80}
    {:command=>"CMD",        :params=>["nginx", "-g", "daemon off;"]}
]
```

## Contributing

1. Fork it (https://github.com/keplersj/dockerfile.cr/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [@yurinnick](https://github.com/yurinnick) Nikolay Yurin - creator
- [@keplersj](https://github.com/keplersj) Kepler Sticka-Jones - maintainer, ported to Crystal
