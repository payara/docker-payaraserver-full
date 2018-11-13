#!/bin/sh

# Run the generate deployments script if it exists
if [ -f scripts/generate_deploy_commands.sh ]
then
	scripts/generate_deploy_commands.sh
fi

export AS_ADMIN_PATH=appserver/bin/asadmin

scripts/startInForeground.sh --passwordfile=passwordFile --prebootcommandfile=scripts/pre-boot-commands.asadmin --postbootcommandfile=scripts/post-boot-commands.asadmin domain1