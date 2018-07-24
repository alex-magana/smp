require 'rack'
require 'openssl'
require 'webrick'
require 'webrick/https'



class Application
  def call(env)
    [ 200, { "Content-Type" => "text/html" }, [fetch_av]]
  end

  def fetch_av
    path = File.join(File.dirname(__FILE__), '..')
    data = ''
    f = File.open("#{path}/smp_example_with_embed_url.html", "r") 
    f.each_line do |line|
      data += line
    end
    f.close
    data
  end
end

path = File.join(File.dirname(__FILE__), '..')

webrick_options = {
  :Port               => 9292,
  :Logger             => WEBrick::Log::new($stdout, WEBrick::Log::DEBUG),
  :DocumentRoot       => "./public",
  :SSLEnable          => true,
  :SSLCertificate     => OpenSSL::X509::Certificate.new(File.open("#{path}/certs/server.crt").read),
  :SSLPrivateKey      => OpenSSL::PKey::RSA.new(File.open("#{path}/certs/server.key").read),
  :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

Rack::Handler::WEBrick.run Application.new, webrick_options