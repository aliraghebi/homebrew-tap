# Written by the splitroute release workflow (scripts/update-cask.sh).
cask "splitroute" do
  version "0.2.0"
  sha256 "653a01d664ac10b366caddf4a6db9aa250db1846869b2cf45b1e13314690f82c"

  url "https://github.com/aliraghebi/splitroute/releases/download/v#{version}/Splitroute_#{version}_macos.zip"
  name "splitroute"
  desc "Route chosen IP lists outside a VPN (direct) or drop them (block)"
  homepage "https://github.com/aliraghebi/splitroute"

  depends_on macos: ">= :ventura"

  app "Splitroute.app"
  binary "#{appdir}/Splitroute.app/Contents/Resources/splitroute"

  # Not notarized: without this macOS refuses to open it.
  postflight do
    system_command "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "#{appdir}/Splitroute.app"]
  end

  uninstall quit: "io.github.aliraghebi.splitroute.app"

  # Not in `uninstall`: that also runs on every upgrade and would remove the service.
  zap launchctl: "io.github.aliraghebi.splitroute",
      delete:    [
        "/Library/LaunchDaemons/io.github.aliraghebi.splitroute.plist",
        "/etc/splitroute.conf",
        "/var/db/splitroute",
      ]
end
