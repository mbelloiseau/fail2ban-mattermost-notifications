#!/bin/bash

mattermost_webhook_url="<your webhook url>"
mattermost_username="$(hostname -f)"
mattermost_message=${1}

if [ ! -z ${2} ] ; then
	origin=$(geoiplookup ${2} | sed 's/GeoIP Country Edition: //' | grep -v "IP Address not found") 
	mattermost_message="${mattermost_message}\n${origin}"
fi

if echo ${mattermost_message} | egrep -qwi '(banned|stopped)' ; then
	mattermost_color="#ff3333"
elif echo ${mattermost_message} | egrep -qwi '(unbanned|started)' ; then
	mattermost_color="#339933"
else
	mattermost_color="#808080"
fi

payload="payload={\"attachments\": [ {\"color\": \"${mattermost_color}\", \"text\": \"${mattermost_message}\"} ],
	\"username\": \"${mattermost_username}\"}"

curl --data-urlencode "${payload}" ${mattermost_web_hook_url}

exit 0 
