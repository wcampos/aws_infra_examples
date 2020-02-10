sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo yum clean all 
sudo yum repolist

sleep 5

wget https://pkg.jenkins.io/redhat/jenkins.io.key

#sudo rpm --import ./jenkins.io.key