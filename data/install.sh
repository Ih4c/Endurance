# installation commands for the vulnerable machine endurance
# do not run this machine in your local network without monitoring it


echo -e "\e[1;31m updating repos \e[0m" 
apt update

echo -e "\e[1;31m installing apache \e[0m" 
apt install -y apache2

echo -e "\e[1;31m [+] installing and configuring ftp \e[0m"
apt install -y vsftpd
sudo ufw allow 20
sudo ufw allow 21
mkdir /var/ftp
chown nobody:nogroup /var/ftp
sudo cp /etc/vsfpd.conf /etc/vsftpd.conf.bak
sed -i 's/anonymous_enable=NO/anonymous_enable=Yes/' /etc/vsftpd.conf
echo "anon_root=/var/ftp/" >> /etc/vsftpd.conf
systemctl restart vsftpd

echo -e "\e[1;31m [+] installing and configuring ssh \e[0m"
apt install openssh-server -y
ufw allow ssh

echo -e "\e[1;31m [+] moving the binary to ftp \e[0m"
mv /root/data/Note.txt /var/ftp/
mv /root/data/pass.txt /var/ftp/
chown nobody:nogroup /var/ftp/Note.txt
chown nobody:nogroup /var/ftp/pass.txt


# priv esc
echo -e "\e[1;31m [+] adding privilege escalation vector \e[0m"
echo 'int main() {setgid(0);setuid(0);system("wget http:/\/localhost:80");return 0;}' > /usr/local/bin/rinnegan.c
gcc /usr/local/bin/kakashi.c -o /usr/local/bin/kakashi
chmod 644 /usr/local/bin/kakashi.c
chmod u+s /usr/local/bin/kakashi

# add user endurance
echo -e "\e[1;31m [+] adding user endurance \e[0m"
useradd -m endurance
echo endurance:'secrete' | sudo chpasswd
usermod -s /bin/bash -d /home/endurance endurance


# cleanup
echo -e "\e[1;31m [+] CLEANING UP \e[0m"

echo "[+] Disabling IPv6"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"/' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
update-grub

echo "[+] Configuring hostname"
hostnamectl set-hostname endurance
cat << EOF > /etc/hosts
127.0.0.1 localhost
127.0.0.1 endurance
EOF

echo "[+] Disabling history files"
ln -sf /dev/null /root/.bash_history
ln -sf /dev/null /home/endurance/.bash_history

echo "[+] Enabling root SSH login"
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

echo "[+] Setting passwords"
echo "root:Sasukeisthegoatnotgonnalienocapforreal" | sudo chpasswd

echo "[+] Dropping flags"
echo "ca742c7ad27d517527f49531c02f76b8" > /root/root.txt
echo "9f1642b69b2a23aca3c5863e3f1ffd92" > /home/endurance/local.txt
chmod 0600 /root/root.txt
chmod 0644 /home/n/local.txt
chown endurance:endurance /home/endurance/local.txt 

echo "[+] Cleaning up"
rm -rf /root/install.sh
rm -rf /root/.cache
rm -rf /root/.viminfo
rm -rf /home/endurance/.sudo_as_admin_successful
rm -rf /home/endurance/.cache
rm -rf /home/endurance/.viminfo
find /var/log -type f -exec sh -c "cat /dev/null > {}" \;