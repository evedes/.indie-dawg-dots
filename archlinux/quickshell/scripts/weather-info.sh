#!/bin/bash

# Location: São Brás de Alportel, Portugal
lat="37.17941"
lon="-7.90739"
city="São Brás de Alportel"

echo "LOCATION|$city"

# Fetch weather (current + hourly + daily)
weather=$(curl -s --max-time 5 "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m,precipitation&hourly=precipitation_probability,temperature_2m,weather_code&daily=temperature_2m_max,temperature_2m_min,weather_code,precipitation_probability_max&timezone=auto&forecast_hours=14&forecast_days=7" 2>/dev/null)

if [ -z "$weather" ]; then
    echo "ERROR|Could not fetch weather"
    exit 1
fi

# Parse all data with a single python3 call
echo "$weather" | python3 -c "
import sys, json
from datetime import datetime

d = json.load(sys.stdin)

# Current
c = d['current']
print(f\"CURRENT|{c['temperature_2m']}|{c['apparent_temperature']}|{c['relative_humidity_2m']}|{c['wind_speed_10m']}|{c['weather_code']}|{c['precipitation']}\")

# Hourly
h = d['hourly']
for i in range(len(h['time'])):
    t = h['time'][i].split('T')[1][:5]
    print(f\"HOUR|{t}|{h['temperature_2m'][i]}|{h['precipitation_probability'][i]}|{h['weather_code'][i]}\")

# Daily
dy = d['daily']
days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
for i in range(len(dy['time'])):
    dt = datetime.strptime(dy['time'][i], '%Y-%m-%d')
    day_name = days[dt.weekday()]
    if i == 0:
        day_name = 'Today'
    elif i == 1:
        day_name = 'Tmrw'
    print(f\"DAY|{day_name}|{dy['temperature_2m_min'][i]}|{dy['temperature_2m_max'][i]}|{dy['precipitation_probability_max'][i]}|{dy['weather_code'][i]}\")
" 2>/dev/null
