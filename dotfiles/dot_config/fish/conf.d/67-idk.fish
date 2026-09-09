# silence fish

set -g fish_greeting ""

# set paths

alias cd="z"
alias ls="eza"
alias ll="eza -l"
alias la="eza -la"
alias lt="eza --tree"
alias top="btop"
alias tokscale="bunx tokscale@latest"
alias maleme="bunx maleme@latest"
alias parrot-live="curl parrot.live"
alias oc="opencode"
alias ff="fastfetch"
alias hy="hyfetch"
alias cz="chezmoi"

# paths

# Darwin: official Homebrew shell env (PATH + HOMEBREW_PREFIX/CELLAR/REPOSITORY
# + MANPATH/INFOPATH). `brew shellenv fish` emits fish-native commands.
if test (uname) = Darwin
    if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv fish | source
    end
end

set -gx PATH $PATH ~/user/scripts
set -gx PATH $PATH ~/.bun/bin
set -gx PATH $PATH ~/.local/share/pnpm/bin
set -gx PATH $PATH ~/.npm-global/bin
set -gx PATH $PATH ~/Library/pnpm/bin # macos pnpm
set -gx PATH $PATH ~/.cargo/bin
set -gx PATH $PATH ~/go/bin

# env vars

# telemetries
set -x OMO_DISABLE_POSTHOG "1"        # oh-my-openagent
set -x OMO_SEND_ANONYMOUS_TELEMETRY "0"
set -x WRANGLER_SEND_METRICS "false"
set -x ASTRO_TELEMETRY_DISABLED "1"   # astro


# TODO: only for linux
# https://github.com/cloudflare/workers-sdk/issues/8158, fix workerd untrusted certificate
# NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt"
