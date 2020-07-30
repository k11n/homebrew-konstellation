class Konstellation < Formula
  desc "Manages Apps on Kubernetes"
  homepage "https://github.com/k11n/konstellation"
  url "https://github.com/k11n/konstellation.git",
    :tag => "v0.4.3"
  head "https://github.com/k11n/konstellation.git"
  version "0.4.3"

  depends_on "go" => :build
  depends_on "kubernetes-cli"
  depends_on "terraform"

  def install
    gopath = buildpath/"gopath"
    mkdir gopath
    ENV["GOPATH"] = gopath
    bin_dir = gopath/"bin"
    mkdir bin_dir
    ENV["PATH"] = "#{ENV["PATH"]}:#{bin_dir}"
    kon_dir = "cmd/kon"

    cd kon_dir do
      system "go", "get", "github.com/GeertJohan/go.rice/rice"
      system "rice", "embed-go", "--import-path", "github.com/k11n/konstellation/cmd/kon/utils"
      system "go", "build", "-o", "kon"
      bin.install "kon"
    end
  end

  test do
    assert_match "kon - Konstellation CLI", shell_output("#{bin}/kon 2>&1")
  end
end
