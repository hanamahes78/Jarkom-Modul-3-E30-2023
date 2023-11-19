echo 'nameserver 192.168.122.1' > /etc/resolv.conf
apt-get update
apt install bind9 -y

echo '
zone "riegel.canyon.e30.com" {
    type master;
    file "/etc/bind/jarkom/riegel.canyon.e30.com";
};

zone "granz.channel.e30.com" {
    type master;
    file "/etc/bind/jarkom/granz.channel.e30.com";
};

zone "1.221.192.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/1.221.192.in-addr.arpa";
};
' > /etc/bind/named.conf.local

mkdir -p /etc/bind/jarkom
cp /etc/bind/db.local /etc/bind/jarkom/riegel.canyon.e30.com
cp /etc/bind/db.local /etc/bind/jarkom/granz.channel.e30.com
cp /etc/bind/db.local /etc/bind/jarkom/1.221.192.in-addr.arpa

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     riegel.canyon.e30.com. root.riegel.canyon.e30.com. (
                      	      2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      riegel.canyon.e30.com.
@       IN      A       192.221.4.6	;	IP Fern
www     IN      CNAME   riegel.canyon.e30.com.
' > /etc/bind/jarkom/riegel.canyon.e30.com

echo '
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     granz.channel.e30.com. root.granz.channel.e30.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      granz.channel.e30.com.
@       IN      A       192.221.3.6	;	IP Lugner
www     IN      CNAME   granz.channel.e30.com.
' > /etc/bind/jarkom/granz.channel.e30.com

echo '
options {
      directory "/var/cache/bind";

      forwarders {
              192.168.122.1;
      };

      // dnssec-validation auto;
      allow-query{any;};
      auth-nxdomain no;    # conform to RFC1035
      listen-on-v6 { any; };
}; 
' >/etc/bind/named.conf.options

service bind9 start