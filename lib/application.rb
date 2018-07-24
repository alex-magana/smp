require 'rack'
require 'openssl'
require 'webrick'
require 'webrick/https'

class Application
  def initialize(path, template_name)
    @path = path
    @template = template_name
  end

  def call(env)
    [ 200, { "Content-Type" => "text/html" }, [fetch_av]]
  end

  def fetch_av
    path = File.join(File.dirname(__FILE__), '..')
    data = ''
    f = File.open("#{@path}/#{@template}.html", "r") 
    f.each_line do |line|
      data += line
    end
    f.close
    data
  end
end