SymbioTIC https/tls helper scripts
==================================

The scripts included in this repository are helper scripts for SSL/TLS
key/csr/certificate generation and validation.

They are by no means exhaustive. Use at your own risks.

Included scripts:

* ./bin/generate-csr.sh: generates a new RSA key and CSR.
* ./bin/validate-crt.sh: validates the certificate from the CA.
* ./bin/test-https.sh: do a few quick tests on the https server. (TODO)

Bundles for RapidSSL
--------------------

* RapidSSL intermediate CA SHA-2 (under SHA-1 Root)  
  https://knowledge.rapidssl.com/support/ssl-certificate-support/index?page=content&actp=CROSSLINK&id=SO26459

* RapidSSL intermediate CA SHA-1  
  https://knowledge.rapidssl.com/support/ssl-certificate-support/index?page=content&actp=CROSSLINK&id=SO26464

More information:  
https://knowledge.rapidssl.com/support/ssl-certificate-support/index?page=content&actp=CROSSLINK&id=AR1548

Bundle for Gandi.net
--------------------

https://wiki.gandi.net/fr/ssl/intermediate

Useful sites
------------

* https://www.ssllabs.com/ssltest

* https://shaaaaaaaaaaaaa.com/

Recommended cipher suite
------------------------

Apache:

    SSLProtocol all -SSLv2 -SSLv3
    SSLHonorCipherOrder on
    SSLCipherSuite "ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:kDHE:SHA256:EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:HIGH:!RC4:!MD5:!DSS:!SRP:!LOW:!3DESL:!EXP:!PSK:!SRP:!aNULL:!eNULL:!NULL"

Nginx:

    ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
    ssl_ciphers ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:kDHE:SHA256:EECDH+ECDSA+AESGCM:EECDH+aRSA+AESGCM:HIGH:!RC4:!MD5:!DSS:!SRP:!LOW:!3DESL:!EXP:!PSK:!SRP:!aNULL:!eNULL:!NULL;
    ssl_prefer_server_ciphers on;

This is by no means a complete guide. Use at your own risk.

Further readings:

* https://wiki.mozilla.org/Security/Server_Side_TLS
* https://community.qualys.com/blogs/securitylabs/2013/08/05/configuring-apache-nginx-and-openssl-for-forward-secrecy
* http://security.stackexchange.com/questions/51680/optimal-web-server-ssl-cipher-suite-configuration

Contact
-------

Coop SymbioTIC <https://www.symbiotic.coop/contact>

Copyright
---------

    Copyright (c) 2014 Mathieu Lutfy (Coop SymbioTIC)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
