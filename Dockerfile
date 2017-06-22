FROM resin/raspberrypi3-debian:latest

# Add openldap user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r openldap && useradd -r -g openldap -u 999 openldap

# Install OpenLDAP, ldap-utils and ssl-tools from baseimage and clean apt-get files
RUN apt-get -y update \
    && LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes --no-install-recommends \
       ldap-utils \
       openssl \
       slapd \
#       ca-certificates \
#       curl \
#       patch \
#       php5-ldap \
#       php5-readline \
#    && curl -o phpldapadmin.tgz -SL https://downloads.sourceforge.net/project/phpldapadmin/phpldapadmin-php5/${PHPLDAPADMIN_VERSION}/phpldapadmin-${PHPLDAPADMIN_VERSION}.tgz \
#    && echo "$PHPLDAPADMIN_SHA1 *phpldapadmin.tgz" | sha1sum -c - \
#    && mkdir -p /var/www/phpldapadmin_bootstrap /var/www/phpldapadmin \
#    && tar -xzf phpldapadmin.tgz --strip 1 -C /var/www/phpldapadmin_bootstrap \
#    && apt-get remove -y --purge --auto-remove curl ca-certificates \
#    && rm phpldapadmin.tgz \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY data /tmp/data/
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# Set phpLDAPadmin data directory in a data volume
# VOLUME ["/var/www/phpldapadmin"]
VOLUME ["/etc/ldap"]

#CMD ["/usr/sbin/slapd", "-g", "openldap", "-u", "openldap", "-F", "/etc/ldap/slapd.d", "-d0"]
#CMD ["/usr/sbin/slapd", "-h", "ldap:/// ldapi:///", "-g", "openldap", "-u", "openldap", "-F", "/etc/ldap/slapd.d", "-d7"]
#CMD ["/bin/bash"]
CMD ["/usr/local/bin/startup.sh"]

EXPOSE 389 636
#80 443