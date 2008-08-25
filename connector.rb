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
require 'ebb'

class MemCachedPersistentConnector 
  def call(env)
    path = env['PATH_INFO']
    pass, method, key = path.split('/')
    response_hash = {"Content-Type" => "text/plain", "Transfer-Encoding" => "chunked"}
    
    if(method.downcase == 'get')
      [200, response_hash, [translate_to_memcached(key)]] 
    else
      #Not implemented
      [501, response_hash, []]
    end
  end 
  
  def translate_to_memcached(key)
    "Hello"
  end
  
  private :translate_to_memcached
  
end 
Ebb.start_server(MemCachedPersistentConnector.new, :port => 11212)