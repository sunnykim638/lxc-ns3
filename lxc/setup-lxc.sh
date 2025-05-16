#!/bin/sh

#clean up
if ip link show br-auth > /dev/null 2>&1; then ip link set br-auth down; brctl delbr br-auth; fi
if ip link show tap-auth > /dev/null 2>&1; then ip link delete tap-auth; fi
if ip link show br-authwifi > /dev/null 2>&1; then ip link set br-authwifi down; brctl delbr br-authwifi; fi
if ip link show tap-authwifi > /dev/null 2>&1; then ip link delete tap-authwifi; fi
if ip link show br-client > /dev/null 2>&1; then ip link set br-client down; brctl delbr br-client; fi
if ip link show tap-client > /dev/null 2>&1; then ip link delete tap-client; fi
if ip link show br-server > /dev/null 2>&1; then ip link set br-server down; brctl delbr br-server; fi
if ip link show tap-server > /dev/null 2>&1; then ip link delete tap-server; fi

#add bridges
brctl addbr br-auth	
brctl addbr br-client
brctl addbr br-server
brctl addbr br-authwifi

#create TAP devices
tunctl -t tap-auth
tunctl -t tap-authwifi
tunctl -t tap-client
tunctl -t tap-server

#set TAP devices persistence, assign IP addresses
ip link set tap-auth up promisc on
ip link set tap-client up promisc on
ip link set tap-server up promisc on
ip link set tap-authwifi up promisc on

#add bridge interfaces to TAP devices, and bring bridges up
brctl addif br-auth tap-auth
ip link set br-auth up
brctl addif br-authwifi tap-authwifi
ip link set br-authwifi up
brctl addif br-client tap-client
ip link set br-client up
brctl addif br-server tap-server
ip link set br-server up

brctl show

lxc-create -n auth -f lxc-auth.conf -t download -- -d ubuntu -r jammy -a amd64
lxc-create -n client -f lxc-client.conf -t download -- -d ubuntu -r jammy -a amd64
lxc-create -n server -f lxc-server.conf -t download -- -d ubuntu -r jammy -a amd64

lxc-ls --fancy
