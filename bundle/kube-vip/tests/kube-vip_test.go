package bundles_test

import (
	"fmt"
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
		err := os.WriteFile("/oem/foo.yaml", []byte(`#cloud-config
kubevip:
  eip: 10.10.10.10`), 0655)
		runBundle()
		dat, err := os.ReadFile(filepath.Join("/var/lib/rancher/k3s/server/manifests", "kube-vip.yaml"))
		content := string(dat)
		Expect(err).ToNot(HaveOccurred())
		fmt.Println(content)
		Expect(content).To(MatchRegexp("version: \".*?\""))
		Expect(content).To(ContainSubstring("cp_enable: \"true\""))
	})

	It("sets version from config", func() {
		err := os.WriteFile("/oem/foo.yaml", []byte(`#cloud-config
kubevip:
  eip: 10.10.10.10
  version: 42`), 0655)
		runBundle()
		dat, err := os.ReadFile(filepath.Join("/var/lib/rancher/k3s/server/manifests", "kube-vip.yaml"))
		content := string(dat)
		Expect(err).ToNot(HaveOccurred())
		Expect(content).To(ContainSubstring("version: \"42\""))
	})

})
