echo 'nameserver 192.221.1.3' > /etc/resolv.conf
apt-get update
apt install isc-dhcp-server -y

echo '
subnet 192.221.1.0 netmask 255.255.255.0 {
    option routers 192.221.1.1;
}

subnet 192.221.2.0 netmask 255.255.255.0 {
    option routers 192.221.2.1;
}

subnet 192.221.3.0 netmask 255.255.255.0 {
    range 192.221.3.16 192.221.3.32;
    range 192.221.3.64 192.221.3.80;
    option routers 192.221.3.1;
    option broadcast-address 192.221.3.255;
    option domain-name-servers 192.221.1.3;
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 192.221.4.0 netmask 255.255.255.0 {
    range 192.221.4.12 192.221.4.20;
    range 192.221.4.160 192.221.4.168;
    option routers 192.221.4.1;
    option broadcast-address 192.221.4.255;
    option domain-name-servers 192.221.1.3;
    default-lease-time 720;
    max-lease-time 5760;
} 

host Lawine {
    hardware ethernet 4e:92:c2:68:92:e9;
    fixed-address 192.221.3.4;
}

host Linie {
    hardware ethernet 7e:f9:4a:48:db:c3;
    fixed-address 192.221.3.5;
}

host Lunger {
    hardware ethernet 02:ad:43:d2:b0:1d;
    fixed-address 192.221.3.6;
}

host Frieren {
    hardware ethernet c6:61:48:c2:2b:b5;
    fixed-address 192.221.4.4;
}

host Flamme {
    hardware ethernet 52:97:d4:bf:ce:ac;
    fixed-address 192.221.4.5;
}

host Fern {
    hardware ethernet d2:2a:fd:33:dc:68;
    fixed-address 192.221.4.6;
}
' > /etc/dhcp/dhcpd.conf

echo '
INTERFACESv4="eth0"
' > /etc/default/isc-dhcp-server

service isc-dhcp-server start