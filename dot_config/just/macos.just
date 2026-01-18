[macos]
flush-dns:
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder 

# https://apple.stackexchange.com/a/466029/460194
[macos]
enable-sudo-touchid:
  sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

[macos]
kill-ios-simulator:
  sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService

[macos]
launchctl-update-path:
  sudo launchctl config user path {{env("PATH")}}

[macos]
confetti:
  open raycast://confetti

[macos]
brew-diff:
  delta <(brew bundle dump --file=-) ~/.Brewfile

[macos]
dequarantine app="":
    #!/usr/bin/env zsh
    set -euo pipefail
    if [ -z "{{ app }}" ]; then
      APP=$(fd -d 1 -g "*.app" /Applications | fzf --prompt="Select app to dequarantine: " --preview='basename {}')
      if [ -z "$APP" ]; then
        echo "No app selected"
        exit 1
      fi
      sudo xattr -rd com.apple.quarantine "$APP"
    else
      sudo xattr -rd com.apple.quarantine "{{ app }}.app"
    fi
