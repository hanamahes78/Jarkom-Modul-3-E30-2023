# **Praktikum 3 Jaringan Komputer**
<div align=justify>

Berikut repository dari Kelompok E30 Praktikum Modul 3 Jaringan Komputer.

# **Anggota Kelompok**

| Nama                      | NRP        | Kelas                |
| ------------------------- | ---------- | ----------------     |
| Hana Maheswari            | 5025211182 | Jaringan Komputer E  |
| Meyroja Jovancha Firoos   | 5025211204 | Jaringan Komputer E  |

# **Dokumentasi dan Penjelasan Soal**
<div align=justify>

Berikut adalah topologi yang digunakan. 

![image](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/082ab90f-3581-42ea-b981-ae536220a78f)

### Konfigurasi
- Aura (DHCP Relay)
    ```
    auto eth0
    iface eth0 inet dhcp

    auto eth1
    iface eth1 inet static
        address 192.221.1.1
        netmask 255.255.255.0

    auto eth2
    iface eth2 inet static
        address 192.221.2.1
        netmask 255.255.255.0

    auto eth3
    iface eth3 inet static
        address 192.221.3.1
        netmask 255.255.255.0

    auto eth4
    iface eth4 inet static
        address 192.221.4.1
        netmask 255.255.255.0
    ```
- Himmel (DHCP Server)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.1.2
        netmask 255.255.255.0
        gateway 192.221.1.1
    ```
- Heiter (DNS Server)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.1.3
        netmask 255.255.255.0
        gateway 192.221.1.1
    ```
- Denken (Database Server)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.2.2
        netmask 255.255.255.0
        gateway 192.221.2.1
    ```
- Eisen (Load Balancer)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.2.3
        netmask 255.255.255.0
        gateway 192.221.2.1
    ```
- Lawine (PHP Worker)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.3.4
        netmask 255.255.255.0
        gateway 192.221.3.1
    
    hwaddress ether 4e:92:c2:68:92:e9
    ```
- Linie (PHP Worker)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.3.5
        netmask 255.255.255.0
        gateway 192.221.3.1

    hwaddress ether 7e:f9:4a:48:db:c3
    ```
- Lugner (PHP Worker)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.3.6
        netmask 255.255.255.0
        gateway 192.221.3.1

    hwaddress ether 02:ad:43:d2:b0:1d
    ```
- Frieren (Laravel Worker)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.4.4
        netmask 255.255.255.0
        gateway 192.221.4.1

    hwaddress ether c6:61:48:c2:2b:b5
    ```
- Flamme (Laravel Worker)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.4.5
        netmask 255.255.255.0
        gateway 192.221.4.1

    hwaddress ether 52:97:d4:bf:ce:ac
    ```
- Fern (Laravel Worker)
    ```
    auto eth0
    iface eth0 inet static
        address 192.221.4.6
        netmask 255.255.255.0
        gateway 192.221.4.1

    hwaddress ether d2:2a:fd:33:dc:68
    ```
- Revolte, Richter, Sein, Stark (Client)
    ```
    auto eth0
    iface eth0 inet dhcp
    ```

## **Soal Nomor 0**
Setelah mengalahkan Demon King, perjalanan berlanjut. Kali ini, kalian diminta untuk melakukan register domain berupa riegel.canyon.yyy.com untuk worker Laravel dan granz.channel.yyy.com untuk worker PHP (0) mengarah pada worker yang memiliki IP [prefix IP].x.1.
## **Penyelesaian Soal Nomor 0**
Dilakukan konfigurasi `/etc/bind/named.conf.local` pada Heiter dengan domain riegel.canyon.e30.com. Setelah itu dibuat direktori `/etc/bind/jarkom`. Kemudian dibuat file `riegel.canyon.e30.com` pada direktori tersebut dan file dilakukan konfigurasi. Hal yang sama dilakukan untuk domain granz.channel.e30.com. Selanjutnya dilakukan konfigurasi juga pada `/etc/bind/named.conf.options` dengan menambahkan `allow-query{any;};`. Setelah selesai bind9 distart menggunakan command `service bind9 start`.

### Testing
Pada node Heiter akan dilakukan setup.
> Script dijalankan pada **root node Heiter** dengan command `bash setup.sh`
- Heiter
```
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
```
Kemudian dicek node worker dengan melakukan test ping.
> Ping riegel.canyon.e30.com

![m 0 1](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/a76518c9-939a-4848-b339-5987765637ba)
> Ping granz.channel.e30.com

![m 0 2](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/6278583c-2d12-4f97-aecf-f760b3be5207)

## **Soal Nomor 1**
Lakukan konfigurasi sesuai dengan peta yang sudah diberikan.
## **Penyelesaian Soal Nomor 1**
Sudah terjawab pada [Konfigurasi](#konfigurasi).

## **Soal Nomor 2**
Semua CLIENT harus menggunakan konfigurasi dari DHCP Server.
Client yang melalui Switch3 mendapatkan range IP dari [prefix IP].3.16 - [prefix IP].3.32 dan [prefix IP].3.64 - [prefix IP].3.80.
## **Penyelesaian Soal Nomor 2**
Akan digunakan subnet pada DHCP Server melalui Switch3 dengan range `192.221.3.16 - 192.221.3.32` dan `192.221.3.64 - 192.221.3.80`.
```
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
}
```
Kemudian dilakukan konfigurasi pada DHCP Relay untuk meneruskan IP dari DHCP Server. Digunakan IP DHCP `192.221.1.2` untuk forward requests dan interfaces `eth1 eth2 eth3 eth4`.

### Testing
Pada node Himmel akan dilakukan setup.
> Script dijalankan pada **root node Himmel** dengan command `bash setup.sh`

Selanjutnya dilakukan konfigurasi pada Aura.
> Script dijalankan pada **root node Aura** dengan command `bash setup.sh`
- Aura
```
apt-get update
apt install isc-dhcp-relay -y

echo '
# Defaults for isc-dhcp-relay initscript
# sourced by /etc/init.d/isc-dhcp-relay
# installed at /etc/default/isc-dhcp-relay by the maintainer scripts

#
# This is a POSIX shell fragment
#

# What servers should the DHCP relay forward requests to?
SERVERS="192.221.1.2"

# On what interfaces should the DHCP relay (dhrelay) serve DHCP requests?
INTERFACES="eth1 eth2 eth3 eth4"

# Additional options that are passed to the DHCP relay daemon?
OPTIONS=""
' > /etc/default/isc-dhcp-relay

echo 'net.ipv4.ip_forward=1' > /etc/sysctl.conf

service isc-dhcp-relay start 
```
Dicek client apakah berhasil mendapatkan IP.

![m 2](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/f2805c90-fde7-4833-ad3a-f34f3588bcb1)

## **Soal Nomor 3**
Client yang melalui Switch4 mendapatkan range IP dari [prefix IP].4.12 - [prefix IP].4.20 dan [prefix IP].4.160 - [prefix IP].4.168.
## **Penyelesaian Soal Nomor 3**
Sama seperti penyelesaian sebelumya, ditambahkan subnet pada DHCP Server melalui Switch4 dengan range `192.221.4.12 - 192.221.4.20` dan `192.221.4.160 - 192.221.4.168`.
```
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
}

subnet 192.221.4.0 netmask 255.255.255.0 {
    range 192.221.4.12 192.221.4.20;
    range 192.221.4.160 192.221.4.168;
    option routers 192.221.4.1;
} 
```
Kemudian dilakukan konfigurasi pada DHCP Relay untuk meneruskan IP dari DHCP Server. Digunakan IP DHCP `192.221.1.2` untuk forward requests dan interfaces `eth1 eth2 eth3 eth4`.

### Testing
Pada node Himmel akan ditambahkan setup.
> Script dijalankan pada **root node Himmel** dengan command `bash setup.sh`

Selanjutnya dilakukan konfigurasi pada Aura.
> Script dijalankan pada **root node Aura** dengan command `bash setup.sh`

Dicek client apakah berhasil mendapatkan IP.

![m 3](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/d69d7fdb-d526-4218-ae94-bd751814a0ad)

## **Soal Nomor 4**
Client mendapatkan DNS dari Heiter dan dapat terhubung dengan internet melalui DNS tersebut.
## **Penyelesaian Soal Nomor 4**
Dilakukan dengan menambahkan `broadcast-address` dan `domain-name-servers` agar otomatis menginputkan pada `/etc/resolv.conf` ketika mendapat IP dari DHCP.
```
subnet 192.221.3.0 netmask 255.255.255.0 {
    ...
    option broadcast-address 192.221.3.255;
    option domain-name-servers 192.221.1.3;
    ...
}

subnet 192.221.4.0 netmask 255.255.255.0 {
    ...
    option broadcast-address 192.221.4.255;
    option domain-name-servers 192.221.1.3;
    ...
} 
```

### Testing
Pada node Himmel akan ditambahkan setup.
> Script dijalankan pada **root node Himmel** dengan command `bash setup.sh`

Selanjutnya dilakukan konfigurasi pada Aura.
> Script dijalankan pada **root node Aura** dengan command `bash setup.sh`

Dicek client apakah berhasil terhubung ke internet.
> Ping google.com

![m 4](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/98eb136e-12d0-40f7-80e2-6d2e49f64648)

## **Soal Nomor 5**
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch3 selama 3 menit sedangkan pada client yang melalui Switch4 selama 12 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 96 menit.
## **Penyelesaian Soal Nomor 5**
Dilakukan dengan menambahkan `default-lease-time` dan `max-lease-time` untuk mengalokasikan waktu peminjaman IP. Satuan yang digunakan adalah `Detik` sehingga default-lease-time pada Switch3 `180 s`, Switch4 `720 s`, dan max-lease-time menjadi `5760 s`.
```
subnet 192.221.3.0 netmask 255.255.255.0 {
    ...
    default-lease-time 180;
    max-lease-time 5760;
}

subnet 192.221.4.0 netmask 255.255.255.0 {
    ...
    default-lease-time 720;
    max-lease-time 5760;
} 
```

### Testing
Pada node Himmel akan ditambahkan setup.
> Script dijalankan pada **root node Himmel** dengan command `bash setup.sh`

Selanjutnya dilakukan konfigurasi pada Aura.
> Script dijalankan pada **root node Aura** dengan command `bash setup.sh`

Dicek client apakah lease time sesuai.

![m 5 1](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/4589b677-f314-49e6-93f9-ad74a5a8b3cb)
![m 5 2](https://github.com/hanamahes78/Jarkom-Modul-3-E30-2023/assets/108173681/f673af73-21e9-46bf-8b9f-0c1f0400a6e3)
