# base-astrodb : base database image for astyronomy database

This creates an image with the minimal database server software for development/testing work

* PostgreSQL 10
* pgsphere-1.x 

NOTE: The pgsphere package is expected to be found in a CADC yum repository that is currently private so this
won't work out of the box but should illustrate what is required to build the base image (e.g. for use by other
images in this git repository).

TODO: provide a usable way to install the current pgsphere library

