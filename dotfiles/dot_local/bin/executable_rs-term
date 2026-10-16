#!/usr/bin/env bash

full_terminal_reset() {
    # 关闭所有鼠标跟踪模式
    for mode in 9 1000 1001 1002 1003 1004 1005 1006 1007 1015; do
        printf "\x1b[?${mode}l"
    done
    
    # 退出所有屏幕模式
    for mode in 47 1047 1049; do
        printf "\x1b[?${mode}l"
    done
    
    # 恢复标准设置
    stty echoctl  # 恢复控制字符显示
    tput cnorm     # 显示光标
    tput rmcup     # 退出备用屏幕
    tput rs1       # 重置终端
    
    # 刷新显示
    # clear
}

full_terminal_reset
