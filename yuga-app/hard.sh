# Remove other programs that could be dangerous.
find $sysdirs -xdev \( \
  -name hexdump -o \
  -name chgrp -o \
  -name chmod -o \
  -name chown -o \
  -name ln -o \
  -name od -o \
  -name strings -o \
  -name su \
  \) -delete

# Remove init scripts since we do not use them.
rm -fr /etc/init.d
rm -fr /lib/rc
rm -fr /etc/conf.d
rm -fr /etc/inittab
rm -fr /etc/runlevels
rm -fr /etc/rc.conf

# Remove all non usable package
rm -fr /var/cache/apt/archives

# Remove all installed packages
apt-get remove --purge $(dpkg -l | awk '{print $2}' | grep -v ^un) || :

# Clean up the package cache
apt-get autoremove || :
apt-get clean || :
 
