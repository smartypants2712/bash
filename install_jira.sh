#/bin/bash

# curl https://raw.githubusercontent.com/sosimon/bash/master/install_jira.sh | bash

JIRA_BIN=atlassian-jira-software-8.1.0-x64.bin

sudo yum update -y

# download JIRA binary
curl -L -O https://www.atlassian.com/software/jira/downloads/binary/$JIRA_BIN
chmod a+x $JIRA_BIN

# write response.varfile for unattended JIRA install
cat <<EOF > response.varfile
#install4j response file for JIRA Software 8.1.0
#Thu Apr 18 22:13:23 UTC 2019
executeLauncherAction$Boolean=true
app.install.service$Boolean=true
sys.confirmedUpdateInstallationString=false
app.jiraHome=/var/atlassian/application-data/jira
launch.application$Boolean=true
existingInstallationDir=/usr/local/JIRA Software
sys.languageId=en
sys.installationDir=/opt/atlassian/jira
EOF

# install JIRA
sudo ./atlassian-jira-software-8.1.0-x64.bin -q -varfile response.varfile