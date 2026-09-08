# 只对交互式 shell 注入工具 init，跨平台一致
if status is-interactive
    type -q zoxide;   and zoxide init fish | source
    type -q starship; and starship init fish | source
    type -q direnv;   and direnv hook fish | source
    type -q mise;     and mise activate fish | source
end
