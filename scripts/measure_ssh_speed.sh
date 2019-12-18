#!/bin/bash

# PV needs to be installed | get an estimation of the SSH transfer speed

yes | pv | ssh remote_host "cat >/dev/null"

