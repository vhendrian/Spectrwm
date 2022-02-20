#!/bin/bash

# Spectrwm autostart script

trayer                        \
    --monitor primary         \
    --edge bottom             \
    --widthtype pixel         \
    --width 100               \
    --heighttype pixel        \
    --height 20              \
    --align right             \
    --margin 0                \
    --transparent true        \
    --tint 0x000000           \
    --iconspacing 3           \
    --distance 1 &
