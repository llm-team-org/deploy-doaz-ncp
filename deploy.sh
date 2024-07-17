#!/bin/sh

# Export environment variables
export NCLOUD_ACCESS_KEY=$NCLOUD_ACCESS_KEY
export NCLOUD_SECRET_KEY=$NCLOUD_SECRET_KEY
export NCLOUD_API_GW=https://ncloud.apigw.ntruss.com
export NCLOUD_UUID=$NCLOUD_UUID
export NCLOUD_REGION=$NCLOUD_REGION

# Write configuration to ~/.ncloud/configure
mkdir -p ~/.ncloud
cat <<EOL > ~/.ncloud/configure
[DEFAULT]
ncloud_access_key_id = $NCLOUD_ACCESS_KEY
ncloud_secret_access_key = $NCLOUD_SECRET_KEY
ncloud_api_url = $NCLOUD_API_GW
EOL

# Update kubeconfig with ncp-iam-authenticator
ncp-iam-authenticator update-kubeconfig --region $NCLOUD_REGION --clusterUuid $NCLOUD_UUID

echo "Check KUBECONFIG---------------------a---"
export KUBECONFIG='~/.kube/config'

echo "Check Software------------------------"
aws --version
kubectl version
helm version
echo "------------------------"

# Helm Deployment
UPGRADE_COMMAND="helm upgrade --install --timeout 30s"
for config_file in ${DEPLOY_CONFIG_FILES}
do
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
echo "Executing: ${UPGRADE_COMMAND}"
${UPGRADE_COMMAND}