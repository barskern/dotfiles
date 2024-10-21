#!/usr/bin/env bash
#
# Check if current connection is metered (aka. iPhone hotspot)
#

set -euo pipefail


network_status=$(networkctl --json=short)

# If on LAN, for now we assume always unmetered
ether_online=$(\
	echo "$network_status" \
	| jq -r '.Interfaces | map(select(.Type=="ether")) | any(.OnlineState=="online")'
)
if [[ "$ether_online" = "true" ]]; then
	echo "Found ether connection, assuming unmetered across the wire!";
	exit 0;
fi

# Check that the wireless connection is online before polling for ssid
wireless_online=$(\
	echo "$network_status" \
	| jq -r '.Interfaces | map(select(.Type=="wlan")) | any(.OnlineState=="online")'
)
if [[ "$wireless_online" = "false" ]]; then
	echo "Didnt find any wlan online, doesn't matter if we fail or not, network not online..";
	exit 0;
fi

ssid=$(wpa_cli status | grep '^ssid=' | sed 's/^ssid=//')
if [[ "$ssid" =~ "s iPhone" ]]; then
	echo "Connection through '$ssid' is metered!";
	exit 1;
else
	echo "Connection through '$ssid' is *NOT* metered!";
	exit 0;
fi
