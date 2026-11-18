# Written by the splitroute release workflow (scripts/update-cask.sh).
cask "splitroute" do
  version "0.9.1"
  sha256 "d0a0bf5c1c360ed8da109ab8a7b5318c8165d9c0b786d62fea3c81dfa0fd77eb"

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
