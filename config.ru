
require 'connector'

app = proc do |env|
 memcached_persistent_connector(env)
end

run app