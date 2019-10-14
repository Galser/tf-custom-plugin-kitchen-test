# tf-custom-plugin-kitchen-test
TF : Using custom plugin + kitchen test of it
Based on : https://github.com/Galser/tf-custom-plugin

# Purpose
This repository provides demo code for running Terraform in Vagrant environment with custom plugin with KitchenCI tests

# Requirements

This repository assumes general knowledge about Terraform, if not, please get yourself accustomed first by going through [getting started guide for Terraform](https://learn.hashicorp.com/terraform?track=getting-started#getting-started). We also going to use Vagrant with VirtualBox and KitchenCI.

To learn more about the mentioned above tools and technologies -  please check section [Technologies near the end of the README](#technologies)

# How to use
- Download copy of the code (*clone* in Git terminology) - go to the location of your choice (normally some place in home folder) and run in terminal; in case you are using alternative Git Client - please follow appropriate instruction for it and download(*clone*) [this repo](https://github.com/Galser/tf-custom-plugin-kitchen-test.git). 
```
git clone https://github.com/Galser/tf-custom-plugin-kitchen-test.git
```

- Previous step should create the folder that contains a copy of the repository. Default name is going to be the same as the name of repository e.g. `tf-custom-plugin-kitchen-test`. Locate and open it.
    ```
    cd tf-custom-plugin-kitchen-test
    ```
- The next step is to install KitchenCI, the task includes multiple steps so it is been provided in a separate section. Please follow instructions in [How to install KitchenCI](#how-to-install-kitchenci)

## How to test 

- In order to test we need to have Vagrant Box with Terraform and custom plugin created and everything that required provisioned. To do it run in command line : 
    ```
    make
    ```
    > Note : This will utilize [Makefile](Makefile) with all instructions that is prepared in this repo. Generally in the modern distributions you already have make command by default, if it is missing, you will need to check you OS documentation on the instructions how to install make. Often it will just require simple one or two commands.

    The process will take quit some time, be patient, the new VM going to be provisioned, GoLang installed, custom plugin compiled and Terraform initialized, then machine late repacked as ready to use box. The output should start with :
    ```
    vagrant validate Vagrantfile 
    Vagrantfile validated successfully.
    vagrant up
    Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Checking if box 'galser/ubuntu-1804-vbox' version '0.0.1' is up to date...
    ```
    In a 3-4 minutes (depending from your connection and computer CPU power) the last part of the output should be : 
    ```
    ==> box: Box file was not detected as metadata. Adding it directly...
    ==> box: Adding box 'tfcustom-bionic' (v0) for provider: virtualbox
        box: Unpacking necessary files from: file:///Users/.../tf-custom-plugin-kitchen-test/tfcustom-bionic.box
    ==> box: Successfully added box 'tfcustom-bionic' (v0) for 'virtualbox'!
    ```
    And that means that we have now image of VM to power-up.
- To prepare tests (run the VM), execute :
    ```
    bundle exec kitchen converge
    ```
    Output going to start with :
    ```
    -----> Starting Kitchen (v2.3.3)
    -----> Creating <default-tfcustom-bionic>...
        Bringing machine 'default' up with 'virtualbox' provider...
    ==> default: Importing base box 'tfcustom-bionic'...
    ==> default: Matching MAC address for NAT networking...
    ```
    and should end with : 
    ```
        Downloading files from <default-tfcustom-bionic>
        Finished converging <default-tfcustom-bionic> (0m0.01s).
    -----> Kitchen is finished. (0m48.37s)
    ```
- Now to run the test execute : 
    ```
    bundle exec kitchen verify
    ```
    Output should looks like ths : 
    ```
    bundle exec kitchen verify
    -----> Starting Kitchen (v2.3.3)
    -----> Verifying <default-tfcustom-bionic>...
    verify_host_key: false is deprecated, use :never
        Loaded tests from {:path=>".Users.andrii.labs.skills.tf-custom-plugin-kitchen-test.test.integration.default"} 

    Profile: tests from {:path=>"/Users/.../tf-custom-plugin-kitchen-test/test/integration/default"} (tests from {:path=>".Users.andrii.labs.skills.tf-custom-plugin-kitchen-test.test.integration.default"})
    Version: (not specified)
    Target:  ssh://vagrant@127.0.0.1:2222

    File /home/vagrant/.terraform.d/plugins/terraform-provider-extip
        ✔  link_path is expected to eq "/home/vagrant/go/bin/terraform-provider-extip"
    Command: `bash scripts/test_tf.sh`
        ✔  stdout is expected to match /external_ip = (?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/

    Test Summary: 2 successful, 0 failures, 0 skipped
        Finished verifying <default-tfcustom-bionic> (0m1.07s).
    ```       
    As you can see ,there 2 tests, both passing. First is - there should bne a link to custom plugin,. and link should lead to a specific path.
    And the second test is that when we running `terraform apply` with custom plugin the output should much our regular expression. e.g. the last line of output should something like this :
    ```
    external_ip = 77.162.119.9
    ```
- You can make test fail by editing file [test/integration/default/check_custom_plugin_output.rb](test/integration/default/check_custom_plugin_output.rb). For example let's change 
**external_ip** to **internal_ip**, now the content of that test control file should look like this : 
    ```ruby
    describe command('bash scripts/test_tf.sh') do
    its('stdout') { should match /internal_ip = (?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/ }
    end
    ```
- And now let's re-run our tests : 
    ```
    bundle exec kitchen verify
    ```
    Output should looks like ths : 
    ```
    -----> Starting Kitchen (v2.3.3)
    -----> Verifying <default-tfcustom-bionic>...
    verify_host_key: false is deprecated, use :never
        Loaded tests from {:path=>".Users.andrii.labs.skills.tf-custom-plugin-kitchen-test.test.integration.default"} 

    Profile: tests from {:path=>"/Users/.../tf-custom-plugin-kitchen-test/test/integration/default"} (tests from {:path=>".Users.andrii.labs.skills.tf-custom-plugin-kitchen-test.test.integration.default"})
    Version: (not specified)
    Target:  ssh://vagrant@127.0.0.1:2222

    File /home/vagrant/.terraform.d/plugins/terraform-provider-extip
        ✔  link_path is expected to eq "/home/vagrant/go/bin/terraform-provider-extip"
    Command: `bash scripts/test_tf.sh`
        ×  stdout is expected to match /internal_ip = (?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/
        expected "\e[0m\e[1mnull_resource.example: Refreshing state... (ID: 3806188658547787759)\e[0m\n\e[0m\e[1mdata....ded, 0 changed, 0 destroyed.\e[0m\n\e[0m\e[1m\e[32m\nOutputs:\n\nexternal_ip = 77.162.119.95\e[0m\n" to match /internal_ip = (?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/
        Diff:
        @@ -1,2 +1,9 @@
        -/internal_ip = (?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))/
        +null_resource.example: Refreshing state... (ID: 3806188658547787759)
        +data.extip.external_ip: Refreshing state...
        +
        +Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
        +
        +Outputs:
        +
        +external_ip = 77.162.119.95
        Test Summary: 1 successful, 1 failure, 0 skipped
    ```
    Well, this time first test is passing, but the test of the actual plugin output fails as we expecting it to be **"internal_ip = 77.162.119.95"** and the output that passes the value from plugin has **"external_ip"**.
- Whne you've done with tests - to destroy the VM and free resources, run "
    ```
    bundle exec kitchen destroy
    ```
    Output :
    ```
    -----> Starting Kitchen (v2.3.3)
    -----> Destroying <default-tfcustom-bionic>...
        ==> default: Forcing shutdown of VM...
        ==> default: Destroying VM and associated drives...
        Vagrant instance <default-tfcustom-bionic> destroyed.
        Finished destroying <default-tfcustom-bionic> (0m4.62s).
    -----> Kitchen is finished. (0m6.66s)    
    ```
This ends up the instructions, thank you. 



# How to install KitchenCI

In order to run our tests we need an isolated Ruby environment, for this purpose we are going to install and use rbenv - tool that lets you install and run multiple versions of Ruby side-by-side. 
- **On macOS use HomeBrew** (check [Technologies section](#technologies) for more details) to install rbenv.  Execute from command-line :
    ```
    brew install rbenv
    ```
   To succesfully utilize rbenv you will need also to make appropiate env changes :
   - macOs with BASH as the default  shell, run the commands
   ```
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
   source ~/.bash_profile
   rbenv init
   echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
   source ~/.bash_profile
   ```
   - macOS with ZSH as default shell (credits to :  [Rod Wilhelmy](https://coderwall.com/wilhelmbot) ), run the commands :
   ```
   echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshenv
   echo 'eval "$(rbenv init -)"' >> ~/.zshenv
   echo 'source $HOME/.zshenv' >> ~/.zshrc
   exec $SHELL
   ```
- **On Linux (Debian flavored)**:

 > Note: On Graphical environments, when you open a shell, sometimes ~/.bash_profile doesn't get loaded You may need to source ~/.bash_profile manually or use ~/.bashrc
 ```
 apt update
 apt install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
 wget -q https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer -O- | bash
 echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
 source ~/.bash_profile
 rbenv init
 echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
 source ~/.bash_profile
 ```
For other distributions please refer to your system's appropriate manuals 

- Install the required Ruby version and choose it as default local. Run from the command line : 
```
rbenv install 2.3.1
rbenv local 2.3.1
```
- Check that your settings are correct by executing :
```
rbenv versions
```
Output should like something like this : 
```
 system
* 2.3.1 (set by /Users/.../kitchen-vagrant/.ruby-version)
  2.6.0
```
Your output can list other versions also, due to the difference in environments, but the important part is that you should have that asterisk (*) symbol in front of the Ruby version 2.3.1 marking it as active at the current moment
- To simplify our life and to install required Ruby packages we are going to use **Ruby bundler** (See: https://bundler.io/ ). Let's install it. Execute : 
```
gem install bundler
```
- We going to use KitchenCI for our test, to install it and other required **Ruby Gems**, the repository comes with the [Gemfile](Gemfile) that list all that required. Run :
```
bundle install
```
Output going to span several pages, but the last part should be : 
```
Fetching test-kitchen 2.3.3
Installing test-kitchen 2.3.3
Fetching kitchen-inspec 1.2.0
Installing kitchen-inspec 1.2.0
Fetching kitchen-vagrant 1.6.0
Installing kitchen-vagrant 1.6.0
Bundle complete! 4 Gemfile dependencies, 107 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```
Now KitchenCI is ready for usage, you can go back and continue with tests from [this section](#how-to-test). 


# Technologies

1. **To download the content of this repository** you will need **git command-line tools**(recommended) or **Git UI Client**. To install official command-line Git tools please [find here instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for various operating systems. 
2. **For managing infrastructure** we using Terraform - open-source infrastructure as a code software tool created by HashiCorp. It enables users to define and provision a data center infrastructure using a high-level configuration language known as Hashicorp Configuration Language, or optionally JSON. More you encouraged to [learn here](https://www.terraform.io). 
3. **This project for virtualization** recommends **VirtualBox**, download the binaries for your [platform here](https://www.virtualbox.org/wiki/Downloads) and then follow [instructions for installation](https://www.virtualbox.org/manual/ch02.html)
4. **For managing VM** (virtual machines), we are going to use **Vagrant**. To install **Vagrant** , please follow instructions here : [official Vargant installation manual](https://www.vagrantup.com/docs/installation/)
5. **KitchenCI** - provides a test harness to execute infrastructure code on one or more platforms in isolation. For more details please check the product site : [KitchenCI](https://kitchen.ci/). There is a dedicated section in README on [How to install KitchenCI](#how-to-install-kitchenci)


# TODO
- [ ] Update instructions


# DONE
- [x] Setup a Vagrantfile that installs golang
- [x] Create a sample project, ie null provider
- [x] Compile a custom plugin
- [x] Copy the custom plugin to the required path
- [x] Update main.tf to use the custom plugin
- [x] Test it works.
- [x] Setup KitchenCI
- [x] Create test
- [x] Run test

