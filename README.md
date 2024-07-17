# EKS Helm Deploy GitHub Action

# NCP Helm Deploy GitHub Action

This GitHub action deploys a helm chart to a Kubernetes cluster on Naver Cloud Platform (NCP).

## Inputs

Input parameters allow you to specify data that the action expects to use during runtime.

- `ncloud-access-key`: Naver Cloud Platform (NCP) access key. Used for authentication. (required)
- `ncloud-secret-key`: Naver Cloud Platform (NCP) secret key. Used for authentication. (required)
- `ncloud-region`: Naver Cloud Platform (NCP) region to use. (required)
- `cluster-uuid`: The UUID of the Kubernetes cluster on Naver Cloud Platform (NCP). (required)
- `cluster-cert`: Certificate for cluster authentication.
- `server`: Server for linking.
- `env`: Environment name.
- `name`: Helm release name. (required)
- `chart-path`: The path to the Helm chart. (required)
- `namespace`: Kubernetes namespace to use. (required)
- `config-files`: Comma-separated list of Helm values files. (required)
- `timeout`: Timeout for the deployment. (default: 30s)
- `values`: Comma-separated list of values for Helm, e.g., key1=value1,key2=value2
- `dry-run`: Simulate an upgrade.

## Example usage

```yaml
uses: ar-rehman135/ncp-helm-deploy-action@master
with:
  ncloud-access-key: ${{ secrets.NCLOUD_ACCESS_KEY }}
  ncloud-secret-key: ${{ secrets.NCLOUD_SECRET_KEY }}
  ncloud-region: ap-northeast-2
  cluster-uuid: abc12345-6789-0123-4567-890123456789
  cluster-cert: ${{ secrets.NCP_CLUSTER_CERT }}
  server: example-server
  env: production
  name: my-helm-release
  chart-path: ./charts/my-chart
  namespace: default
  config-files: values.yaml,secrets.yaml
```

This GitHub action uses AWS CLI to login to EKS and deploy a helm chart.

## Inputs

Input parameters allow you to specify data that the action expects to use during runtime.

- `aws-secret-access-key`: AWS secret access key part of the aws credentials. This is used to login to EKS. (required)
- `aws-access-key-id`: AWS access key id part of the aws credentials. This is used to login to EKS. (required)
- `aws-region`: AWS region to use. This must match the region your desired cluster lies in. (default: us-east2)
- `cluster-name`: The name of the desired cluster. (required)
- `cluster-role-arn`: If you wish to assume an admin role, provide the role arn here to login as.
- `config-files`: Comma separated list of helm values files.
- `debug`: Enable verbose output.
- `dry-run`: Simulate an upgrade.
- `namespace`: Kubernetes namespace to use.
- `chart-path`: The path to the chart. (defaults to `helm/`)

## Example usage

```yaml
uses: ar-rehman135/eks-helm-deploy-ic@master
with:
  aws-access-key-id: ${{ secrets.events.input.AWS_ACCESS__KEY_ID }}
  aws-secret-access-key: ${{ secrets.events.input.AWS_SECRET_ACCESS_KEY }}
  aws-region: us-east-2
  cluster-name: ic-b4d-aws-ps-east-2
  config-files: ""
  namespace: ""
```
