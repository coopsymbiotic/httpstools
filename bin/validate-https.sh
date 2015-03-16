#!/bin/bash

url=$1

if [ "$url" = "" ]; then
  echo "Runs a few basic https checks on a server."
  echo "Usage: ./bin/validate-https.sh <www.example.org>"
  exit 1
fi

myprint() { 
  printf "\033[1;34m$1\033[m\n"
}

# Basic connection
myprint "Testing a basic https connection..."
myprint "-> keep an eye open to make sure that the certificate chain looks valid."
echo QUIT | openssl s_client -connect ${url}:443 2>/dev/null | grep -A 5 'Certificate chain' | grep '^ '

# Check ciphers (make sure sslv3 is disabled)
nmap=`which nmap`
if [ -x "$nmap" ]; then
  myprint "Checking enabled ciphers..."
  myprint "-> make sure SSLv3 is disabled."
  myprint "-> make sure only strong ciphers are enabled."
  nmap --script ssl-enum-ciphers ${url} -p 443
else
  myprint "WARNING: nmap not found. apt-get install nmap"
fi

# OCSP
# https://www.digitalocean.com/community/tutorials/how-to-configure-ocsp-stapling-on-apache-and-nginx
myprint "Testing OCSP stapling..."
myprint "-> if there is nothing below, OCSP stapling was not detected."
echo QUIT | openssl s_client -connect ${url}:443 -status 2>/dev/null | grep -A 17 'OCSP response:' | grep -B 17 'Next Update'

# Run testssl
myprint "Running testssl.sh, this might take time..."
./lib/testssl.sh $url
