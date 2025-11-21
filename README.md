# ACME Balloon Helm Chart

ACME Balloon is a Kubernetes deployment designed to manage cluster resources by creating low-priority pods that can be preempted when higher-priority workloads need resources. This Helm chart provides a complete deployment solution for ACME Balloon.

## Overview

ACME Balloon creates lightweight pods that:
- Run with low priority (can be preempted)
- Are scheduled on spot/preemptible nodes
- Help maintain cluster resource availability
- Can be easily scaled up or down based on cluster needs

## Prerequisites

- Kubernetes 1.19+
- Helm 3.0+
- A Kubernetes cluster with spot/preemptible nodes (optional but recommended)

## Installation

### Basic Installation

```bash
helm install acme-balloon . --namespace acme-balloon --create-namespace
```

### Installation with Custom Values

```bash
helm install acme-balloon . -f custom-values.yaml --namespace acme-balloon --create-namespace
```

## Configuration

The following table lists the configurable parameters and their default values:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `name` | Name of the deployment | `acme-balloon` |
| `namespace` | Kubernetes namespace | `acme-balloon` |
| `replicas` | Number of pod replicas | `10` |
| `priorityClass.balloon.value` | Priority class value for balloon pods | `-10` |
| `container.name` | Container name | `acme-balloon` |
| `container.image` | Container image | `debian:12-slim` |
| `container.command` | Container command | `["sleep"]` |
| `container.args` | Container arguments | `["infinity"]` |
| `container.resources.requests.cpu` | CPU request | `1m` |
| `container.resources.requests.memory` | Memory request | `8Mi` |
| `terminationGracePeriodSeconds` | Grace period for pod termination | `0` |
| `priorityClassName` | Override PriorityClass name (if using existing) | `acme-balloon-priority` |
| `tolerations` | Pod tolerations | See values.yaml |
| `affinity` | Pod affinity rules | See values.yaml |
| `topologySpreadConstraints` | Topology spread constraints | See values.yaml |

### Example: Custom Configuration

```yaml
name: "acme-balloon"
namespace: "acme-balloon"
replicas: 20

container:
  image: "debian:12-slim"
  resources:
    requests:
      cpu: "1m"
      memory: "8Mi"

tolerations:
  - key: "gke_node_type"
    operator: "Equal"
    value: "spot-default"
    effect: "NoSchedule"

affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: "gke_node_type"
              operator: "In"
              values: ["spot-default"]
```

## Resources Created

This chart creates the following Kubernetes resources:

1. **PriorityClass**: Creates a low-priority class for balloon pods (if it doesn't already exist)
2. **Deployment**: Creates the deployment with configurable replicas

**Note**: The namespace is created automatically by Helm using the `--create-namespace` flag during installation.

## Priority Class

The chart creates a PriorityClass named `acme-balloon-priority` with:
- Value: `-10` (configurable)
- PreemptionPolicy: `Never` (balloon pods will not preempt other pods)
- GlobalDefault: `false`

**Important**: If a PriorityClass with the same name already exists in your cluster (e.g., from a previous deployment), Helm will fail during installation. In this case, you have two options:

1. **Use the existing PriorityClass**: Set `priorityClassName` in values.yaml to match the existing PriorityClass name
2. **Skip PriorityClass creation**: The chart will attempt to create it, and if it fails, you can manually apply the deployment template without the PriorityClass

To use an existing PriorityClass, add to your values.yaml:
```yaml
priorityClassName: existing-priority-class-name
```

## Scaling

You can scale the deployment using:

```bash
# Scale using kubectl
kubectl scale deployment acme-balloon -n acme-balloon --replicas=20

# Or update values and upgrade
helm upgrade acme-balloon . --set replicas=20
```

## Uninstallation

To uninstall the chart:

```bash
helm uninstall acme-balloon --namespace acme-balloon
```

**Note**: 
- This will remove the deployment and priority class (if created by this Helm release)
- The namespace will remain. To remove the namespace as well:
  ```bash
  kubectl delete namespace acme-balloon
  ```
- If the PriorityClass was created by another Helm release or manually, it will not be removed

## Advanced Configuration

### Custom Environment Variables

```yaml
container:
  env:
    - name: CUSTOM_VAR
      value: "custom-value"
```

### Volume Mounts

```yaml
container:
  volumeMounts:
    - name: config-volume
      mountPath: /etc/config

volumes:
  - name: config-volume
    configMap:
      name: my-config
```

### Security Context

```yaml
securityContext:
  runAsNonRoot: true
  runAsUser: 1000
  fsGroup: 1000
```

### Image Pull Secrets

```yaml
imagePullSecrets:
  - name: registry-secret
```

### Service Account

```yaml
serviceAccountName: acme-balloon-sa
```

## Troubleshooting

### Pods Not Starting

1. Check if the namespace exists:
   ```bash
   kubectl get namespace acme-balloon
   ```

2. Check pod events:
   ```bash
   kubectl describe pod -n acme-balloon
   ```

3. Verify node affinity and tolerations match your cluster configuration

### Priority Class Issues

1. **PriorityClass already exists**: If you get an error about PriorityClass already existing:
   ```bash
   # Check existing PriorityClass
   kubectl get priorityclass acme-balloon-priority
   
   # Option 1: Use existing PriorityClass by setting priorityClassName in values.yaml
   # Option 2: Apply template without PriorityClass
   helm template acme-balloon . | grep -v "kind: PriorityClass" -A 20 | kubectl apply -f -
   ```

2. **Verify the priority class exists**:
   ```bash
   kubectl get priorityclass acme-balloon-priority
   ```

3. **Check if pods are using the PriorityClass**:
   ```bash
   kubectl get pods -n acme-balloon -o jsonpath='{.items[*].spec.priorityClassName}'
   ```

## Contributing

This chart is maintained by the AppSpace Cloud Team. For issues or contributions, please contact the team.

## License

Copyright (c) AppSpace. All rights reserved.

