################################################################################
#
# A script to generate the $POSTBOOT_COMMANDS file with asadmin commands to deploy 
# all applications in $DEPLOY_DIR (either files or folders). 
# The $POSTBOOT_COMMANDS file can then be used with the start-domain using the
#  --postbootcommandfile parameter to deploy applications on startup.
#
# Usage:
# ./generate_deploy_commands.sh [deploy command parameters]
#
# Optionally, any number of parameters of the asadmin deploy command can be 
# specified as parameters to this script. 
# E.g., to deploy applications with implicit CDI scanning disabled:
#
# ./generate_deploy_commands.sh --properties=implicitCdiEnabled=false
#
# Note that many parameters to the deploy command can be safely used only when 
# a single application exists in the $DEPLOY_DIR directory.
################################################################################

if [ x$1 != x ]
  then
    DEPLOY_OPTS="$DEPLOY_OPTS $*"
fi

# Create pre and post boot command files if they don't exist
touch scripts/pre-boot-commands.asadmin
touch scripts/post-boot-commands.asadmin

# RAR files first
for deployment in $(find deployments/ -name "*.rar");
do
	echo "Adding deployment target $deployment to post boot commands";
	echo "deploy $DEPLOY_OPTS $deployment" >> scripts/post-boot-commands.asadmin;
done

# Then everything else
for deployment in $(find deployments/ -name "*.war" -o -name "*.ear" -o -name "*.jar");
do
	echo "Adding deployment target $deployment to post boot commands";
	echo "deploy $DEPLOY_OPTS $deployment" >> scripts/post-boot-commands.asadmin;
done