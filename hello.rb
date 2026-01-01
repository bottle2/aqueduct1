require 'openssl'
require 'acme-client'

# I never programmed in Ruby before.
# Prepare yourself to see all the power of XGH.

# I don't know how scoping works in Ruby
private_key = nil
a_different_private_key = nil
kid = nil
client = nil

# directory = 'https://acme-v02.api.letsencrypt.org/directory'
directory = 'https://acme-staging-v02.api.letsencrypt.org/directory'

begin
  private_key = OpenSSL::PKey::RSA.new(File.read('private_key.pem'))
  begin
    kid = File.read('kid')
    a_different_private_key = File.read('a_different_private_key.pem')
  rescue
    puts 'something went really wrong'
    exit 1
  end
  client = Acme::Client.new(private_key: private_key, directory: directory, kid: kid)
rescue
  private_key = OpenSSL::PKey::RSA.new(4096)
  a_different_private_key = OpenSSL::PKey::RSA.new(4096)
  File.write('private_key.pem', private_key.to_pem)
  File.write('a_different_private_key.pem', a_different_private_key.to_pem)
  client = Acme::Client.new(private_key: private_key, directory: directory)
  File.write('kid', client.new_account(contact: 'mailto:bento.schirmer@gmail.com',
                                       terms_of_service_agreed: true).kid)
end

order = client.new_order(identifiers: ['www.aqueduct1.horse'])
authorization = order.authorizations.first
challenge = authorization.http

puts challenge.token
puts challenge.file_content

gets

challenge.request_validation

while 'pending' == challenge.status
  sleep(2)
  challenge.reload
end

if 'valid' == challenge.status
  csr = Acme::Client::CertificateRequest.new(private_key: a_different_private_key,
                                             subject: { common_name: 'www.aqueduct1.horse' })

  while 'processing' == order.status
    sleep(2)
    order.reload
  end
  File.write('certificate.pem', order.certificate)
else
  exit 2
end

exit 0
