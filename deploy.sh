#!/bin/sh

export NCLOUD_API_GW=https://ncloud.apigw.ntruss.com

cat <<EOF >  /root/.ncloud/configure
[DEFAULT]
ncloud_access_key_id = $NCLOUD_ACCESS_KEY
ncloud_secret_access_key = $NCLOUD_SECRET_KEY
ncloud_api_url = $NCLOUD_API_GW

[project]
ncloud_access_key_id = $NCLOUD_ACCESS_KEY
ncloud_secret_access_key = $NCLOUD_SECRET_KEY
ncloud_api_url = $NCLOUD_API_GW
EOF

# Save Inital Path
initial_path=$(pwd)


# Create folder in home directory
mkdir -p /home/kube
echo "Kube DIR : " "/home/kube/config"
cd /home/kube

# Delete Config file if it exits
file='config'
if [ -f $file ]
then 
	echo "Removing $file"
    	rm $file
fi

config=""
echo "apiVersion: v1" > config
echo "clusters:" >> config  
echo "- cluster:" >> config
echo "    certificate-authority-data: ${NCLOUD_CERT}" >> config
echo "    server: ${NCLOUD_SERVER}" >> config 
echo "  name: ${NCLOUD_NAME}" >> config  
echo "contexts:" >> config  
echo "- context:" >> config  
echo "    cluster: ${NCLOUD_NAME}" >> config  
echo "    user: ${NCLOUD_NAME}" >> config  
echo "  name: ${NCLOUD_NAME}" >> config  
echo "current-context: ${NCLOUD_NAME}" >> config  
echo "kind: Config" >> config  
echo "preferences: {}" >> config  
echo "users:" >> config  
echo "- name: ${NCLOUD_NAME}" >> config  
echo "  user:" >> config  
echo "    exec:" >> config  
echo "      apiVersion: client.authentication.k8s.io/v1beta1" >> config  
echo "      args:" >> config   
echo "      - token" >> config  
echo "      - --clusterUuid" >> config  
echo "      - ${NCLOUD_UUID}" >> config
echo "      - --region" >> config
echo "      - ${NCLOUD_REGION}" >> config
echo "      command: ncp-iam-authenticator" >> config  
echo "      env: null" >> config   
echo "      provideClusterInfo: false" >> config  

chmod g-r config
chmod o-r config
cd ${initial_path}
ls -al ${initial_path}

echo "Check KUBECONFIG------------------------"
export KUBECONFIG='/home/kube/config' 
echo "Check Software------------------------"
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
rm -r /home/kube 