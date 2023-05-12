#!/usr/bin/sh
xrdb merge /home/rhino/.config/x11/xresources &
setbg &
xrander -s 1920x1080 &
xset r rate 350 50 &
#The first number is after how many ms the key will start repeating and the second number is the repetitions per second, so after 190ms of pressing 'R' the OS will put out 35 'R's a second
xset mouse 1.3 &
fcitx5 -d &
picom &
mpd &
pulseaudio &
#syncthing &
dunst &
#play-with-mpv &

# mpv --no-video ~/.local/share/sound_effect/Start_up.mp3 &

/home/rhino/.local/bin/cron/cleaner &
/home/rhino/.config/suckless/dwm/scripts/bar.sh &

while type dwm >/dev/null; do dwm && continue || break; done
