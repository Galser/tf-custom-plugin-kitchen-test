describe file('/home/vagrant/.terraform.d/plugins/terraform-provider-extip') do
    its('link_path') { should eq '/home/vagrant/go/bin/terraform-provider-extip' }
end
