Vagrant.configure("2") do |config|
  config.vm.provider :virtualbox do |v|
    v.memory = 2048
    v.cpus = 1
  end


  config.vm.define :master do |master|
    master.vm.box = "centos/7"
    master.vm.hostname = "master"
    master.vm.network :private_network, ip: "10.0.0.10"
    config.vm.synced_folder "master/", "/vagrant/master"
  end

  %w{worker1 worker2 worker3}.each_with_index do |name, i|
    config.vm.define name do |worker|
      worker.vm.box = "centos/7"
      worker.vm.hostname = name
      worker.vm.network :private_network, ip: "10.0.0.#{i + 11}"
      config.vm.synced_folder "worker/", "/vagrant/worker"
      worker.vm.provision :shell, privileged: false, inline: <<-SHELL
sudo yum install git wget curl epel-release -y
SHELL
    end
  end
end
