#! /bin/sh

ip link set dev enP8p1s0f4 up
ip link set dev enP8p1s0f5d1 up

# Pair PF8-PF4, PF9-PF5
bnxt-ctl add-pf-pair enP8p1s0f4 int-pair host 1 pf 8
bnxt-ctl add-pf-pair enP8p1s0f5d1 ext-pair host 1 pf 9

