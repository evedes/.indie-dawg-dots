#!/bin/bash

# Get location from IP
loc=$(curl -s --max-time 5 "https://ipinfo.io/json" 2>/dev/null)
lat=$(echo "$loc" | grep -oP '"loc": "\K[^,]+')
lon=$(echo "$loc" | grep -oP '"loc": "[^,]+,\K[^"]+')
city=$(echo "$loc" | grep -oP '"city": "\K[^"]+')

if [ -z "$lat" ] || [ -z "$lon" ]; then
    echo "ERROR|Could not determine location"
    exit 1
fi

echo "LOCATION|$city"

# Fetch weather
weather=$(curl -s --max-time 5 "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,precipitation&hourly=precipitation_probability,temperature_2m,weather_code&timezone=auto&forecast_hours=12" 2>/dev/null)

if [ -z "$weather" ]; then
    echo "ERROR|Could not fetch weather"
    exit 1
fi

# Parse current conditions
temp=$(echo "$weather" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current']['temperature_2m'])" 2>/dev/null)
feels=$(echo "$weather" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current']['apparent_temperature'])" 2>/dev/null)
humidity=$(echo "$weather" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current']['relative_humidity_2m'])" 2>/dev/null)
wind=$(echo "$weather" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current']['wind_speed_10m'])" 2>/dev/null)
code=$(echo "$weather" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current']['weather_code'])" 2>/dev/null)
precip=$(echo "$weather" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['current']['precipitation'])" 2>/dev/null)

echo "CURRENT|$temp|$feels|$humidity|$wind|$code|$precip"

# Parse hourly forecast (next 12 hours)
echo "$weather" | python3 -c "
import sys, json
d = json.load(sys.stdin)
times = d['hourly']['time']
temps = d['hourly']['temperature_2m']
probs = d['hourly']['precipitation_probability']
codes = d['hourly']['weather_code']
for i in range(len(times)):
    t = times[i].split('T')[1][:5]
    print(f'HOUR|{t}|{temps[i]}|{probs[i]}|{codes[i]}')
" 2>/dev/null
