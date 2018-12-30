#!/bin/bash

set -eu

# Generate CA
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=KAIREN Cert Authority'

# Generate server certs
openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=*.k8s.ai/O=k8s.ai'
openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

# Generate client certs
openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=KAIREN'
openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt

kubectl create secret generic tls-certs --from-file=tls.crt=server.crt --from-file=tls.key=server.key --from-file=ca.crt=ca.crt