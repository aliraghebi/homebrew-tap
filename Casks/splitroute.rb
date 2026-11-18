# Written by the splitroute release workflow (scripts/update-cask.sh).
cask "splitroute" do
  version "0.8.0"
  sha256 "7119da1145866884c971b3f4678134f36ec3a3ef0d0cc1827d99b1f0203866b6"

  url "https://github.com/aliraghebi/splitroute/releases/download/v#{version}/Splitroute_#{version}_macos.dmg"
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
