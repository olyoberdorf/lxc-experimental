# caom2-tapdb : create an image that can be used as a CAOM-2.x with TAP database backend

This uses the base-astrodb image for software (postgresql + pgsphere) and adds a systemd unit that runs
on first boot to initialise a database, add accounts, and create schema(s) for use by the TAP service.

TODO: While the config here adds a caom2 schema for content, the first-boot pg-init *does not* create schema(s) 
for arbitrary content to be served by the TAP service. This could be done via first-boot init but requires 
extending the pg-init unit (e.g. to support multiple "init-content" scripts).

