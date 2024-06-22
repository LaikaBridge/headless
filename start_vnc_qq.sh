#!/usr/bin/env bash
WLR_BACKENDS=headless WLR_RENDERER=pixman WLR_HEADLESS_OUTPUTS=1 WLR_LIBINPUT_NO_DEVICES=1 SWAYSOCK=./sway.sock sway -c ./sway.cfg