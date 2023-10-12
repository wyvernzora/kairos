<h1 align="center">
  <br>
     <img width="184" alt="kairos-white-column 5bc2fe34" src="https://user-images.githubusercontent.com/2420543/193010398-72d4ba6e-7efe-4c2e-b7ba-d3a826a55b7d.png">
    <br>
<br>
</h1>

<h3 align="center">My Opinionated Kairos Bundles</h3>
<p>
This repository builds and pushes Kairos image and bundles that I built for my home lab Kubernetes cluster. There are many like it, but this cluster is mine. While I make some effort to make these generally reusable, at the end of the day, these are specific to how my clusters are setup.
</p>

<hr>

- [Usage](#usage)
- [Bundles](#bundles)
  - [kube-vip](kube-vip/README.md)
## Usage

To use a community bundle, you can load it with the bundles block in the Kairos configuration file, like this:

```yaml
bundles:
- targets:
  - run://quay.io/kairos/community-bundles:<bundle-name>
```

Here is an example of how you might use a community bundle in a Kairos core image:

```yaml
#cloud-config
install:
 device: "auto"
 auto: true
 reboot: true
 image: "docker:quay.io/kairos/kairos-opensuse:v1.4.0-k3sv1.26.0-k3s1"

users:
- name: "kairos"
  passwd: "kairos"
  ssh_authorized_keys:
  - ...

bundles:
- targets:
  - run://quay.io/kairos/community-bundles:kubevirt

k3s:
  enabled: true
```
