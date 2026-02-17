#!/usr/bin/env bash

## weather codes
#
# 0: Clear sky
# 1, 2, 3: Mainly clear, partly cloudy, and overcast
# 45, 48: Fog and depositing rime fog
# 51, 53, 55: Drizzle: Light, moderate, and dense intensity
# 56, 57: Freezing Drizzle: Light and dense intensity
# 61, 63, 65: Rain: Slight, moderate, and heavy intensity
# 66, 67: Freezing Rain: Light and heavy intensity
# 71, 73, 75: Snow fall: Slight, moderate, and heavy intensity
# 77: Snow grains
# 80, 81, 82: Rain showers: Slight, moderate, and violent
# 85, 86: Snow showers: Slight and heavy
# 95: Thunderstorm: Slight or moderate
# 96, 99: Thunderstorm with slight and heavy hail

## Query Open Meteo for current temperature and weather code

weather_json=`curl "https://api.open-meteo.com/v1/forecast?latitude=48.71&longitude=9.4195&current=temperature_2m,weather_code" 2>/dev/null`

## Extract temperature from JSON document

temperature=`echo $weather_json | jq '.current.temperature_2m'`
if [ "$temperature" = "null" ] ; then
	temperature_txt="no temperatue"
else
	temperature_txt="${temperature}°C"
fi

## Extract weather code from JSON document
weathercode=`echo $weather_json | jq '.current.weather_code'`
if [ "$weathercode" = "null" ] ; then
	weathercode_txt="no weather code"
else
	case "$weathercode" in
		0) weathercode_txt="clear sky" ;;
		1) weathercode_txt="mainly clear" ;;
		2) weathercode_txt="partialy cloudy" ;;
		3) weathercode_txt="overcast" ;;
		45) weathercode_txt="fog" ;;
		48) weathercode_txt="depositing rime fog" ;;
		51) weathercode_txt="light drizzle" ;;
		53) weathercode_txt="moderate drizzle" ;;
		55) weathercode_txt="dense drizzle" ;;
		56) weathercode_txt="light freezing drizzle" ;;
		57) weathercode_txt="dense freezing drizzle" ;;
		61) weathercode_txt="slight rain" ;;
		63) weathercode_txt="moderate rain" ;;
		65) weathercode_txt="heavy rain" ;;
		66) weathercode_txt="light freezing rain" ;;
		67) weathercode_txt="heavy freezing rain" ;;
		71) weathercode_txt="slight snow fall" ;;
		73) weathercode_txt="moderate snow fall" ;;
		75) weathercode_txt="heavy snow fall" ;;
		77) weathercode_txt="snow grains" ;;
		80) weathercode_txt="slight rain showers" ;;
		81) weathercode_txt="moderate rain showers" ;;
		82) weathercode_txt="violent rain showers" ;;
		85) weathercode_txt="slight snow showers" ;;
		86) weathercode_txt="heavy snow showers" ;;
		95) weathercode_txt="thunderstorm" ;;
		96) weathercode_txt="thunderstorm with slight hail" ;;
		99) weathercode_txt="thunderstorm with heavy hail" ;;
		*) weathercode_txt="unknown weather code" ;;
	esac
fi

## Add temperature icon
temperature_icon_txt="${temperature_txt}"

## Add weather code icon
case "$weathercode" in
	0) icon="󰖨" ;;
	1) icon="" ;;
	2) icon="" ;;
	3) icon="" ;;
	45) icon="󰱋" ;;
	48) icon="󰱋" ;;
	51) icon="" ;;
	53) icon="" ;;
	55) icon="" ;;
	56) icon="󰜗" ;;
	57) icon="󰜗" ;;
	61) icon="" ;;
	63) icon="" ;;
	65) icon="" ;;
	66) icon="󰜗" ;;
	67) icon="󰜗" ;;
	71) icon="" ;;
	73) icon="" ;;
	75) icon="" ;;
	77) icon="" ;;
	80) icon="" ;;
	81) icon="" ;;
	82) icon="" ;;
	85) icon="" ;;
	86) icon="" ;;
	95) icon="󱐋" ;;
	96) icon="󱐋" ;;
	99) icon="󱐋" ;;
	*) icon="" ;;
esac
weathercode_icon_txt="${icon}${weathercode_txt}"

## Build status line
statusline="${temperature_icon_txt} ${weathercode_icon_txt}"

echo "$statusline" > /tmp/weather_status_bar

