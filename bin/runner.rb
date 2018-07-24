require 'bundler'
Bundler.require

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')

require 'application'

path = File.join(File.dirname(__FILE__), '..')
template_name = ARGV.first

webrick_options = {
  :Port               => 9292,
  :Logger             => WEBrick::Log::new($stdout, WEBrick::Log::DEBUG),
  :DocumentRoot       => "./public",
  :SSLEnable          => true,
  :SSLCertificate     => OpenSSL::X509::Certificate.new(File.open("#{path}/certs/server.crt").read),
  :SSLPrivateKey      => OpenSSL::PKey::RSA.new(File.open("#{path}/certs/server.key").read),
  :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

Rack::Handler::WEBrick.run Application.new(path, template_name), webrick_options