#
# Cookbook Name:: mailee-links
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

template = """
  # Mailee.me specific redirects
  # even with the paths below changed on maileed, we need this to
  # take care of the clients with custom urls

  # empty image for delivery count
  location /go/view/ {
    rewrite      ^ http://event-api.mailee.me$request_uri? permanent;
  }

  # external link
  location /go/click {
    rewrite      ^ http://event-api.mailee.me$request_uri? permanent;
  }

  # this is to keep the assets of old messages working
  location ~* /(clients|contacts|galleries|header_images|messages|templates|wireframes)/\d+/\w+/\w+/.*\.(gif|jpg|jpeg|png|bmp|tiff|svg)$ {
    rewrite      ^ http://assets.mailee.me$request_uri?;
  }

  location ~* /clients/\w+/\w+/.*\.(gif|jpg|jpeg|png|bmp|tiff|svg)$ {
    rewrite      ^ http://tassets.mailee.me$request_uri?;
  }

  location ~* /clients/\w+/\w+/\w+/.*\.(gif|jpg|jpeg|png|bmp|tiff|svg)$ {
    rewrite      ^ http://tassets.mailee.me$request_uri?;
  }
  location ~* /clients/\w+/\w+/\w+/\w+/.*\.(gif|jpg|jpeg|png|bmp|tiff|svg)$ {
    rewrite      ^ http://tassets.mailee.me$request_uri?;
  }

  error_page 500 502 503 504 /500.html;
"""

filename = Dir.entries("/etc/nginx/sites-available").find {|f| f.match(/mailee/)}

f = File.read("/etc/nginx/sites-available/#{filename}")
unless f.match("assets.mailee.me")
  file "/etc/nginx/sites-available/#{filename}" do
    owner "root"
    group "root"
    mode "0644"
    action :create
    content f.gsub(/error_page (.*);$/, template)
  end
  service 'nginx' do
    action [:reload]
    provider Chef::Provider::Service::Upstart
  end
end
