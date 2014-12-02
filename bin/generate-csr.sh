#!/bin/sh

# ------------------------------------------------------------------------------
# Script to create a new key and certificate signing request (CSR) for the
# certificate authority (CA) who will generate a certificate (CRT).
#
# This assumes that you have the following directory structure:
# ./bin/generate-csr.sh
# ./clients/
# ./clients/www.example.org/2014-12-01-1417479101/
# ./clients/wildcard.example.net/2014-12-01-1417479101/
# ./conf/www.example.org
# ./conf/wildcard.example.net
#
# Create config files with the form 'www.example.org' or 'wildcard.example.org'.
# Generated files will be saved in the 'clients' directory.
#
# For a single domain cert, config files must include:
# ssl_cn="www.example.org"
# ssl_req_name="/C=CA/ST=QC/L=Montreal/O=EXAMPLE/OU=IT"
#
# For a wildcard cert:
# ssl_cn="*.example.org"
# ssl_req_name="/C=CA/ST=QC/L=Montreal/O=EXAMPLE/OU=IT"
#
# This script is ridicusly strict about the syntax of config files, because I
# do not like the idea of config files that can include executable code.
# Comments can start with '#', empty lines are allowed. No useless spaces.
# ------------------------------------------------------------------------------

DATE=$(date +"%Y-%m-%d")
TIMESTAMP=$(date +"%s")
CLIENT=$1

# As of 2014, this is the safest, but in 2015 check if the CA supports 4096/512.
KEYLEN="2048"
SHA="sha256"

# Exit on any error (-e) or any unset variable (-u)
set -eu

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------

# The user must specify a client name
if [ "$CLIENT" == "" ]; then
  echo "Usage: ./bin/generate-csr.sh <clientname>"
  echo "  <clientmame>: short alphanumeric name without spaces, must match ./conf/<clientname>"
  exit 1
fi

if [ ! -f "conf/${CLIENT}" ]; then
  echo "Error: could not find ./conf/${CLIENT}."
  echo "This file includes the settings for the certificate request."
  exit 1
fi

# A bit of validation of the config file syntax, but by no means 100% safe.
if egrep -q -v '^#|^\s*$|^[a-z_]+="[^"$`]*"$' "conf/$CLIENT"; then
  echo "Error: syntax error in the config file."
  echo "Only variable declarations (foo_name=\"value\"), comments and empty lines are allowed."
  exit 1
fi

# Read the config variables and check that all required variables are there.
. "conf/${CLIENT}"

if [ "$ssl_cn" == "" ]; then
  echo "Error: missing ssl_cn variable in the config file."
  exit 1
fi

if [ "$ssl_req_name" == "" ]; then
  echo "Error: missing ssl_req_name variable in the config file."
  exit 1
fi

# Each new cert goes into, ex: ./clients/acmeorg/2014-12-01-1417475121
if [ ! -d "clients/${CLIENT}" ]; then
  mkdir "clients/${CLIENT}"
fi

mkdir "clients/${CLIENT}/${DATE}-${TIMESTAMP}"

# -----------------------------------------------------------------------------
# Generate the new key and csr
# -----------------------------------------------------------------------------

dest_csr_file="./clients/${CLIENT}/${DATE}-${TIMESTAMP}/${CLIENT}.csr"
dest_key_file="./clients/${CLIENT}/${DATE}-${TIMESTAMP}/${CLIENT}.key"

set -x
openssl req -new -newkey rsa:${KEYLEN} -nodes -out $dest_csr_file -keyout $dest_key_file -${SHA} -subj "${ssl_req_name}/CN=${ssl_cn}"
set +x

# -----------------------------------------------------------------------------
# Display the CSR
# -----------------------------------------------------------------------------

echo ""
echo "Verify the details below, especially the Subject CN:"
echo ""

openssl req -in $dest_csr_file -noout -text

echo ""
echo "Here is the CSR to send to the CA:"
echo ""

cat $dest_csr_file

echo ""
echo "CSR: $dest_csr_file"
echo "Key: $dest_key_file"
echo ""
echo "All done. Don't forget to double-check the above Subject CN in the CSR output."
