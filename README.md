SMP For AMP

This is a sample implementation of SMP. The purpose for this work is to provide a POC on a local environment.
The application provides SMP via a web server implemented using Rack.

Setting Up Certificates

amp-iframe requires that the requested resource is served via HTTPS. These steps enable serving of SMP
via HTTPS on localhost.

1. Create a key for use in generating the root certificate.

            `openssl genrsa -des3 -out rootCA.key 2048`

      Enter the password when prompted for one. This password shall be used whenever this key is used.

2. Create the root certificate.

            `openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem`

3. Enable trust for the root certificate.
    - Open Keychain Access
    - Select `Certificates`
    - Go to `Files > Import Items`
    - Select the rootCA.pem from where it's stored and click `Open`.
    - Double click the certificate and click `Trust` to expand the options.
    - Under `When using this certificate`, select `Always Trust` and close the window.
4. Create a certificate key for the domain certificate.

            `openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout server.key -config <( cat server.csr.cnf )`

5. Create a certificate for the `localhost.bbc.co.uk` domain

            `openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out server.crt -days 500 -sha256 -extfile v3.ext`

6. Move the `server.key` and `server.crt` to directory `certs`

Adding the Whitelisted Domain

Add `localhost.bbc.co.uk` to `/etc/hosts`

    This is required by SMP to access it on local env via the whitelisted domain

Running The Application

      bundle install
      ruby bin/runner.rb template_name e.g ruby bin/runner.rb smp_example_with_embed_url

Example Usage

      <amp-iframe width=300 height=300
            layout="responsive"
            sandbox="allow-scripts allow-same-origin"
            src="https://localhost.bbc.co.uk:9292">
      </amp-iframe>

