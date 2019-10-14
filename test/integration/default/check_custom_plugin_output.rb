describe command('bash scripts/test_tf.sh') do
  its('stdout') { should match /external_ip = (?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/ }
end