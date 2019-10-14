default: tfcustom-bionic.box

all: kitchen

tfcustom-bionic.box: Vagrantfile scripts/bootstrap.sh scripts/init_tf.sh scripts/setup_custom_plugin.sh scripts/setup_tf.sh scripts/setup_go.sh scripts/test_tf.sh
	vagrant validate Vagrantfile 
	vagrant up
	vagrant package --base tfcustom-bionic --output tfcustom-bionic.box
	vagrant box add --name tfcustom-bionic --provider virtualbox tfcustom-bionic.box -f

kitchen-vbox: tfcustom-bionic.box
	bundle exec kitchen test

kitchen: kitchen-vbox

.PHONY: clean
clean:
	-vagrant box remove -f tfcustom-bionic --provider virtualbox
	-rm -fr output-*/ *.box