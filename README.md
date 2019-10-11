# tf-custom-plugin-kitchen-test
TF : Using custom plugin + kitchen test of it

# Purpose
This repository provides demo code for running Terraform in Vagrant environment with custom plugin with KitchCI tests

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


# Technologies

1. **To download the content of this repository** you will need **git command-line tools**(recommended) or **Git UI Client**. To install official command-line Git tools please [find here instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for various operating systems. 
2. **For managing infrastructure** we using Terraform - open-source infrastructure as a code software tool created by HashiCorp. It enables users to define and provision a data center infrastructure using a high-level configuration language known as Hashicorp Configuration Language, or optionally JSON. More you encouraged to [learn here](https://www.terraform.io). 
3. **This project for virtualization** recommends **VirtualBox**, download the binaries for your [platform here](https://www.virtualbox.org/wiki/Downloads) and then follow [instructions for installation](https://www.virtualbox.org/manual/ch02.html)
4. **For managing VM** (virtual machines), we are going to use **Vagrant**. To install **Vagrant** , please follow instructions here : [official Vargant installation manual](https://www.vagrantup.com/docs/installation/)
5. **KitchenCI** - provides a test harness to execute infrastructure code on one or more platforms in isolation. For more details please check the product site : [KitchenCI](https://kitchen.ci/). There is a dedicated section in README on [How to install KitchenCI](#how-to-install-kitchenci)


# TODO
- [ ] Setup a Vagrantfile that installs golang
- [ ] Create a sample project, ie null provider
- [ ] Compile a custom plugin
- [ ] Copy the custom plugin to the required path
- [ ] Update main.tf to use the custom plugin
- [ ] Test it works.
- [ ] Setup KitchenCI
- [ ] Create test
- [ ] Run test
- [ ] Update instructions


# DONE



# Run logs
