package bundles_test

import (
	"os"
	"path/filepath"

	. "github.com/onsi/ginkgo/v2"
	. "github.com/onsi/gomega"
)

var _ = Describe("kube-vip test", Label("kube-vip"), func() {

	BeforeEach(func() {
		prepareBundle()
	})
	AfterEach(func() {
		cleanBundle()
	})

	It("sets default version", func() {
		runBundle()
		dat, err := os.ReadFile(filepath.Join("/var/lib/rancher/k3s/server/manifests", "kube-vip.yaml"))
		content := string(dat)
		Expect(err).ToNot(HaveOccurred())
		// renovate: depName=kube-vip repoUrl=https://kube-vip.github.io/helm-charts
		Expect(content).To(MatchRegexp("version: \".*?\""))
		Expect(content).To(ContainSubstring("cp_enable: \"true\""))
	})

	It("sets default version", func() {
		err := os.WriteFile("/oem/foo.yaml", []byte(`#cloud-config
kubevip:
  version: 42`), 0655)
		runBundle()
		dat, err := os.ReadFile(filepath.Join("/var/lib/rancher/k3s/server/manifests", "kube-vip.yaml"))
		content := string(dat)
		Expect(err).ToNot(HaveOccurred())
		Expect(content).To(ContainSubstring("version: \"42\""))
	})

})
