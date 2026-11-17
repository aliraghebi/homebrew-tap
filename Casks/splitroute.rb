# Written by the splitroute release workflow (scripts/update-cask.sh).
cask "splitroute" do
  version "0.4.0"
  sha256 "72754f282fdecbb5f0eeaaacc479045457338f01b1feb3324edbba068202a1a8"

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
