#!/usr/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. /home/rhino/.config/suckless/dwm/scripts/bar_themes/dracula

cpu() {
   cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
   printf "^c$black^ ^b$yellow^ "
   printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  #updates=$(doas xbps-install -un | wc -l) # void
  get_updates=$(checkupdates 2>/dev/null | wc -l) # arch
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)
  printf "^c$black^ ^b$pink^ "
  printf "^c$white^ ^b$grey^ $get_updates"
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$black^ ^b$red^ "
  printf "^c$white^ ^b$grey^ $get_capacity"
}

brightness() {
  get_brightness="$(cat /sys/class/backlight/*/brightness)"
  printf "^c$black^ ^b$red^  "
  printf "^c$white^ ^b$grey^ $get_brightness"
  #printf "^c$white^ ^b$red^ %.0f\n $(cat /sys/class/backlight/*/brightness)"
}

volume() {
	printf "^c$black^ ^b$yellow^ "
	printf "^c$white^ ^b$grey^ $(pactl list sinks | grep '^[[:space:]]Volume:' | \
    head -n $(( $SINK + 1 )) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')
"
}

mem() {
  get_memory=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
#  printf "^c$green^^b$black^ 󰻠 " 
  printf "^c$black^ ^b$green^ "
  printf "^c$white^ ^b$grey^ $get_memory"
#  printf "^c$white^ ^b$grey^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$blue^ 󰤨 ^d^%s";;
	down) printf "^c$red^ 󰤭 ^d^%s";;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
  printf "^c$black^^b$blue^ $(date '+%a-%b/%d-%R') "

}

while true; do
  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "  $updates $(volume) $(mem) $(cpu) $(battery) $(clock)"
done
