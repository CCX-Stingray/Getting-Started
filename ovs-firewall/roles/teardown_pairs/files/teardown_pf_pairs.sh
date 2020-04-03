#! /bin/sh

bnxt-ctl del-pair enP8p1s0f4 int-pair
sleep 1
bnxt-ctl del-pair enP8p1s0f5d1 ext-pair
sleep 1

exit
