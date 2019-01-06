# gem install rack
# ruby rack_demo.rb 
require 'rack'

class RackApplication
    def self.call(env) #localhost:3000
        ['200', {'Content-Type' => 'text/html'}, ['Hey There']] 
    end 
end

class SimpleApp
    def self.call(env)
        req = Rack::Request.new(env)
        res = Rack::Response.new

        name = req.params['name']

        res.write("Hello #{name}")
        res.finish
    end 
end

require 'json'

class CookieApp
    def self.call(env)
        req = Rack::Request.new(env)
        res = Rack::Response.new 

        food = req.params['food']
        if food 
            res.set_cookie(
                '_my_cookie_app',
                {
                    path: '/',
                    value: {food: food}.to_json
                }
            )
        else 
            cookie = req.cookies['_my_cookie_app']
            cookie_val = JSON.parse(cookie)
            food = cookie_val['food']
            res.write("Your favorte food is #{food}")
        end 
    res.finish
    end 
end 

Rack::Server.start({
    app: CookieApp,
    Port:3000
})