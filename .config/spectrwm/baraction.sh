#!/bin/bash
# baraction.sh script for spectrwm status bar

## DISK HDD
hddroot(){
	hddroot="$(df -h | awk 'NR==4{print $3, $5}')"
	echo -e "ROOT : $hddroot"
}

hddhome(){
	hddhome="$(df -h | awk 'NR==9{print $3, $5}')"
	echo -e "HOME : $hddhome"
}

## RAM MEM
mem() {
  mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 /1024.0 }'`
  echo -e "mem: $mem"
}

## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "cpu: $cpu%"
}


##TEMPRATURE
temp() {
    temp="$(sensors | awk '/Core 0/ {print $3+0}'
)"  
    echo -e "temp: $temp°C"
}

## VOLUME
vol(){
	x="$(pamixer --get-mute)"
	if [ $x = "true" ]
	then
		vol="MUTE"
	else
		vol="$(pamixer --get-volume)"
	fi
	echo -e "vol: $vol"
}


## BRIGHTNESS
bri(){
	x=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
	y=$(cat /sys/class/backlight/intel_backlight/max_brightness)
	brightness="$(echo "$x $y" | awk '{printf "%0.1f %\n",$1/$2 * 100}')"
	echo -e "BRI : $brightness"
}

## BATTERY
bat() {
	
# Loop through all attached batteries.
for battery in /sys/class/power_supply/BAT?
do
	# Get its remaining capacity and charge status.
	capacity=$(cat "$battery"/capacity) || break
	status=$(sed "s/Discharging/bat: D/;s/Not charging/bat: N/;s/Charging/bat: C/;s/Unknown/U/;s/Full/bat: F/" "$battery"/status)

	# If it is discharging and 25% or less, we will add a ! as a warning.
	 [ "$capacity" -le 25 ] && [ "$status" = "D" ] && warn="!"

	printf "%s%s%s%% " "$status" "$warn" "$capacity"
	unset warn
done | sed 's/ *$//'

}


##DATE TIME
dte() {
  dte="$(date '+%A, %d/%m/%y %I:%M %p')"
  echo -e "$dte"
}

## UPTIME
up_time() {
  echo "uptime: $(uptime --pretty | sed -e 's/up //g' -e 's/ days/d/g' -e 's/ day/d/g' -e 's/ hours/h/g' -e 's/ hour/h/g' -e 's/ minutes/m /g' -e 's/, / /g')"
}
SLEEP_SEC=3
#loops forever outputting a line every SLEEP_SEC secs

# It seems that we are limited to how many characters can be displayed via
# the baraction script output. And the the markup tags count in that limit.
# So I would love to add more functions to this script but it makes the 
# echo output too long to display correctly.
while :; do
    echo "+@fg=1;[$(temp)]+@fg=0; +@fg=2;[$(cpu)]+@fg=0; +@fg=3;[$(mem)]+@fg=0; +@fg=4;[$(bat)]+@fg=0; +@fg=5;[$(up_time)]+@fg=0; +@fg=6;[$(dte)]+@fg=0;"
	sleep $SLEEP_SEC
done

