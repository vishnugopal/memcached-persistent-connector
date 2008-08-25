#
# This is a memcached persistent connector for applications and instances
# that cannot maintain a persistent connection to memcache.
# (for e.g. Ruby and PHP CLI scripts.)
#
# Currently it only works with GET queries.
# It installs by default at port 11212 and works over the HTTP interface
# like this: http://localhost:11212/get/:key:
# and outputs the stored value as text/plain or nothing if the key doesn't exist.
#
# Dependencies:
# * Ebb web server (and all its dependencies: ruby, rubygems etc.)
# * The memcached gem for Ruby
#

require 'rubygems'
require 'memcached'

$memcached = Memcached.new("localhost:11211")

def translate_to_memcached(key)
  $memcached.get(key).to_s
rescue Memcached::NotFound
  ""
end

def memcached_persistent_connector(env)
  path = env['PATH_INFO']
  pass, method, key = path.split('/')
  response_hash = { "Content-Type" => "text/plain", "Content-Length" => '0' }
  
  if(method.downcase == 'get')
    data = translate_to_memcached(key).to_s
    [200, response_hash.merge({"Content-Length" => data.length.to_s}), [data]] 
  else
    #Not implemented
    [501, response_hash, []]
  end
end 



