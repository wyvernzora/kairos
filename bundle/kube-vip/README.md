<h1 align="center">
    <br>
    <img width="184" src="https://kube-vip.io/images/compose.svg">
    <br>
    <br>
</h1>

<h3 align="center">kube-vip</h3>
<hr>

This is a kube-vip bundle that can be dropped into a Kairos deployment when P2P is not configured. It uses the same configuration format as the built-in kube-vip, but instead sets up control plane VIP.

### Usage
```yaml
#cloud-config

bundles:
  - targets:
    - run://ghcr.io/wyvernzora/kairos-kubevip:latest

kubevip:
    eip: 192.168.1.1
    interface: eth0
    enable: true
```

### Configuration
| Option | Description |
| ------ | ----- |
| `version` | kube-vip Helm chart version to deploy |
| `enable` | Set to `false` to disable control plane VIP |
| `eip` | IP address of the control plane VIP |
| `interface` | Network interface to advertise for VIP |

When `enable` is set to `false`, the kube-vip is still deployed, but with control plane load balancing disabled.
