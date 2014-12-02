#!/bin/sh

client=$1
base=$2

if [ "$client" = "" ]; then
  echo "Usage: ./bin/validate-crt.sh <www.example.org> <directory-to-key>"
  exit 1
fi

if [ "$base" = "" ]; then
  echo "Error: the path to the key is missing."
  echo "Usage: ./bin/validate-crt.sh <www.example.org> <directory-to-key>"
  exit 1
fi

if [ ! -d "$base" ]; then
  echo "Error: the path to the key is not a valid directory."
  echo "Usage: ./bin/validate-crt.sh <www.example.org> <directory-to-key>"
  exit 1
fi

# TODO: make the CSR or CRT optional, so that we can check just one of them.
fail=0

keymod=`openssl rsa -noout -modulus -in "${base}/${client}.key" | openssl md5`
csrmod=`openssl req -noout -modulus -in "${base}/${client}.csr" | openssl md5`
crtmod=`openssl x509 -noout -modulus -in "${base}/${client}.crt" | openssl md5`

if [ "$keymod" != "$csrmod" ]; then
  echo "Error: the key and csr do not match."
fi

if [ "$keymod" != "$crtmod" ]; then
  echo "Error: the key and crt do not match."
fi

if [ "$fail" = "1" ]; then
  echo "Debug with:"
  echo "openssl rsa -in ${base}/${client}.key -text -noout"
  echo "openssl req -in ${base}/${client}.csr -text -noout"
  echo "openssl x509 -in ${base}/${client}.crt -text -noout"
  exit 1
fi

echo $keymod
echo $csrmod
echo $crtmod

echo ""
echo "ALL OK"
