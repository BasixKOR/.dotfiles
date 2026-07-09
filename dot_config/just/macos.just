flush-dns:
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder 

# https://apple.stackexchange.com/a/466029/460194
enable-sudo-touchid:
  sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

kill-ios-simulator:
  sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService

launchctl-update-path:
  sudo launchctl config user path {{env("PATH")}}

confetti:
  open raycast://confetti

brew-diff:
  delta <(brew bundle dump --file=-) ~/.Brewfile

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
