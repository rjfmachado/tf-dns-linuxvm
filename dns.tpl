#cloud-config
runcmd:
  - curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
  - echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list
  - apt update
  - apt install --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" bind9 dnsutils ca-certificates curl apt-transport-https lsb-release gnupg
  - systemctl stop systemd-resolved
  - systemctl mask systemd-resolved
  - systemctl enable bind9
  - domain=$(grep cloudapp /etc/resolv.conf | awk '{print $2}'); echo "nameserver 127.0.0.1\noptions edns0\nsearch $domain" > /etc/resolv.conf.temp
  - rm /etc/resolv.conf
  - mv /etc/resolv.conf.temp /etc/resolv.conf
  - sed -i "s/127.0.0.1\ localhost/127.0.0.1\ localhost\ $(hostname)/g" /etc/hosts
  - sed '15 s/\///g' -i /etc/apt/apt.conf.d/50unattended-upgrades
  - sed '20 a Unattended-Upgrade::Automatic-Reboot "true";' -i /etc/apt/apt.conf.d/50unattended-upgrades
  - sed '20 a Unattended-Upgrade::Automatic-Reboot-Time "02:00";' -i /etc/apt/apt.conf.d/50unattended-upgrades
  - sed '20 a Unattended-Upgrade::Remove-Unused-Dependencies "true";' -i /etc/apt/apt.conf.d/50unattended-upgrades
write_files:
  - path: /etc/bind/named.conf.options
    content: |
      #managed by cloud-init
      #acl "all" {
      #  192.168.0.0/16;
      #  10.1.1.0/24;
      #  localhost;
      #  localnets;
      #};

      options {
              directory "/var/cache/bind";

              #allow-query { all; };
              #allow-recursion { all; };
              #recursion yes;
              forward only;

              forwarders {
                168.63.129.16;
              };

              dnssec-enable no;
              dnssec-validation auto;

              auth-nxdomain no;    # conform to RFC1035
              listen-on-v6 { none; };
      };
  - path: /etc/bind/named.conf.local
    content: |
      #managed by cloud-init
      #zone "internal.cloudapp.net" {
      #  type forward;
      #  forward only;
      #  forwarders { 168.63.129.16; };
      #};

      #zone "azmk8s.io" {
      #        type forward;
      #        forward only;
      #        forwarders { 168.63.129.16; };
      #};
  - path: /etc/default/bind9
    content: |
      #managed by cloud-init
      #
      # run resolvconf?
      RESOLVCONF=no

      # startup options for the server
      OPTIONS="-u bind -4"
