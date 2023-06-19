#!/bin/bash

#variables
package1=$(trivy image --vuln-type os --severity critical,high,medium --security-checks vuln --format json $HARBOR_REG | grep PkgName | cut -d " " -f 12 | sed -e 's|[",'\'']||g'|uniq > vuln-package1.txt)
package2=$(trivy image --vuln-type os --severity low --format json $HARBOR_REG  | grep PkgName | cut -d " " -f 12 | sed -e 's|[",'\'']||g'|uniq > vuln-package2.txt)
#Delete Vulnerable Package in Image
echo "DELETING VULNERABLE PACKAGE..."
eval $package1
eval $package2 

echo "RUN ls -lah" | tee -a Dockerfile
echo "RUN pip install --upgrade setuptools==65.5.1 || :" | tee -a Dockerfile
echo "RUN apt-get purge git -y || :" | tee -a Dockerfile
#echo "RUN apt-get autoremove -y || :" | tee -a Dockerfile
echo "RUN dpkg --purge --force-all \$(strings vuln-package1.txt) || :" | tee -a Dockerfile
echo "RUN dpkg --purge --force-all \$(strings vuln-package2.txt) || :" | tee -a Dockerfile
#echo "RUN apt-get purge -y git || :" | tee -a Dockerfile

