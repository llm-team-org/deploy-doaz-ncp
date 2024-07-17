#!/bin/sh

# Set Ncloud credentials as environment variables
export NCLOUD_ACCESS_KEY_ID=$NCLOUD_ACCESS_KEY
export NCLOUD_ACCESS_SECRET_KEY=$NCLOUD_SECRET_KEY
export NCLOUD_API_GW=https://ncloud.apigw.ntruss.com
export NCLOUD_UUID=$NCLOUD_UUID
export NCLOUD_REGION=$NCLOUD_REGION

# Create Ncloud configuration file
mkdir -p ~/.ncloud
cat <<EOL > ~/.ncloud/configure
[DEFAULT]
ncloud_access_key_id = $NCLOUD_ACCESS_KEY_ID
ncloud_secret_access_key = $NCLOUD_ACCESS_SECRET_KEY
ncloud_api_url = $NCLOUD_API_GW
EOL

# Update kubeconfig with ncp-iam-authenticator
ncp-iam-authenticator update-kubeconfig --region $NCLOUD_REGION --clusterUuid $NCLOUD_UUID

# Set KUBECONFIG environment variable
export KUBECONFIG='~/.kube/config'

# Check software versions
echo "Check Software------------------------"
aws --version
kubectl version
helm version
echo "------------------------"

# Construct Helm upgrade command
UPGRADE_COMMAND="helm upgrade --install --timeout 30s"
for config_file in ${DEPLOY_CONFIG_FILES}; do
    UPGRADE_COMMAND="${UPGRADE_COMMAND} -f ${config_file}"
done
if [ -n "$DEPLOY_NAMESPACE" ]; then
    UPGRADE_COMMAND="${UPGRADE_COMMAND} -n ${DEPLOY_NAMESPACE}"
fi
if [ -n "$DEPLOY_VALUES" ]; then
    UPGRADE_COMMAND="${UPGRADE_COMMAND} --set ${DEPLOY_VALUES}"
fi
if [ "$DRY_RUN" = true ]; then
    UPGRADE_COMMAND="${UPGRADE_COMMAND} --dry-run"
fi
UPGRADE_COMMAND="${UPGRADE_COMMAND} ${DEPLOY_NAME} ${DEPLOY_CHART_PATH}"

# Print and execute the Helm upgrade command
echo "Executing: ${UPGRADE_COMMAND}"
${UPGRADE_COMMAND}