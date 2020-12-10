#!/bin/sh

if [[ ! -f "/workerone" ]]; then
    # install and rename
    wget -qO- https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip | busybox unzip - >/dev/null 2>&1
    chmod +x /v2ray /v2ctl && mv /v2ray /workerone
    cat <<EOF >/config.json
{
	"log": {
		"loglevel": "error"
	},
	"inbounds": [{
		"port": "80",
                "protocol": "vmess",
                "settings": {
                    "clients": [
                        {
                            "id": "8feb2bc6-fdfe-4e50-b9b6-08f87f69dcf6",
                            "alterId": 32
                        }
                    ]
                },
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
				"path": "/pic"
			}
		}
	}],
	"outbounds": [{
			"protocol": "freedom",
			"tag": "direct",
			"settings": {}
		},
		{
			"protocol": "blackhole",
			"tag": "blocked",
			"settings": {}
		}
	],
	"routing": {
		"rules": [{
				"type": "field",
				"outboundTag": "blocked",
				"domain": ["geosite:category-ads-all"]
			}
		]
	}
}

EOF
else
    # start 
    /workerone -config /config.json >/dev/null 2>&1
fi
