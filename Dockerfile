FROM registry.access.redhat.com/ubi8-minimal
RUN microdnf -y install nodejs && microdnf clean all
COPY dist /srv/staticroot
COPY public/favicon.ico /srv/staticroot
COPY public/index.ejs /srv/staticroot
COPY deploy/main.js /srv
COPY node_modules /srv/node_modules
COPY scripts/entrypoint.sh /usr/bin/entrypoint.sh
ENTRYPOINT entrypoint.sh

