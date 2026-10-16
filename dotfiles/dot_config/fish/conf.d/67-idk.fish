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

set -gx PATH $PATH ~/.local/bin
set -gx PATH $PATH ~/.bun/bin
set -gx PATH $PATH ~/.local/share/pnpm/bin
set -gx PATH $PATH ~/.npm-global/bin
set -gx PATH $PATH ~/Library/pnpm/bin # macos pnpm
set -gx PATH $PATH ~/.cargo/bin
set -gx PATH $PATH ~/go/bin


