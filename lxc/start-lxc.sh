#!/bin/sh

lxc-start -n auth -d
lxc-start -n client -d
lxc-start -n server -d
