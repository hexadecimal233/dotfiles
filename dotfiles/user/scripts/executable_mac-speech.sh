#!/bin/bash
# the script simply restarts the dictation service
# see: https://lists.gnu.org/archive/html/bug-gnu-emacs/2025-07/msg01154.html
#
# TODO: zed terminal does not respond to speech, investigate later
killall corespeechd
