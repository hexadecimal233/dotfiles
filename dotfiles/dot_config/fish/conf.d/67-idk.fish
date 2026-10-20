# 只对交互式 shell 注入工具 init，跨平台一致
if status is-interactive
    type -q zoxide;   and zoxide init fish | source
    type -q starship; and starship init fish | source
    type -q direnv;   and direnv hook fish | source
    type -q mise;     and mise activate fish | source
end

if test (uname) = Darwin
    if test -x /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv fish | source
    end
end

set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source

set -g fish_greeting "" # silence fish

alias cd="z"
alias ls="eza"
alias ll="eza -l"
alias la="eza -la"
alias lt="eza --tree"
alias oc="opencode"
alias ff="fastfetch"
alias hy="hyfetch"
alias cz="chezmoi"