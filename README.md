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
uses: llm-team-org/deploy-doaz-ncp@master
with:
  ncloud-access-key: ${{ secrets.NCLOUD_ACCESS_KEY }}
  ncloud-secret-key: ${{ secrets.NCLOUD_SECRET_KEY }}
  ncloud-region: KR
  cluster-uuid: abc12345-6789-0123-4567-890123456789
  cluster-cert: ${{ secrets.NCP_CLUSTER_CERT }}
  server: example-server
  env: production
  name: my-helm-release
  chart-path: ./charts/my-chart
  namespace: default
  config-files: values.yaml,secrets.yaml
```

This GitHub action uses NCP CLI to login to EKS and deploy a helm chart.
