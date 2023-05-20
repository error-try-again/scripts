#!/bin/bash 
CONFIG="vpn.ovpn"
openvpn3 session-start --config $CONFIG
