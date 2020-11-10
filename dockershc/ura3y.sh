#!/bin/sh
## 用于https://github.com/mixool/dockershc项目安装运行v2ray的脚本

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
		"port": "8080",
		"protocol": "vless",
		"settings": {
			"clients": [{
				"id": "8f91b6a0-e8ee-11ea-adc1-0242ac120002"
			}],
			"decryption": "none"
		},
		"streamSettings": {
			"network": "ws",
			"wsSettings": {
				"path": "pic"
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
