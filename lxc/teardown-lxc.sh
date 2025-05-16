#!/bin/sh

lxc-destroy -n auth
lxc-destroy -n client
lxc-destroy -n server

ip link set br-auth down
ip link set br-authwifi down
ip link set br-client down
ip link set br-server down

brctl delif br-auth tap-auth
brctl delif br-authwifi tap-authwifi
brctl delif br-client tap-client
brctl delif br-server tap-server

brctl delbr br-auth
brctl delbr br-authwifi
brctl delbr br-client
brctl delbr br-server

brctl show

ip link set tap-auth down
ip link set tap-authwifi down
ip link set tap-client down
ip link set tap-server down

ip link delete tap-auth
ip link delete tap-authwifi
ip link delete tap-client
ip link delete tap-server
