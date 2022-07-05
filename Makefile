# Nginxの設定を反映する
reload-nginx:
	cat settings/nginx/nginx.conf | sudo tee /etc/nginx/nginx.conf > /dev/null
	sudo nginx -s reload

# MySQLの設定を反映する
reload-mysql:
	cat settings/mysql/mariadb.conf.d/50-server.cnf | sudo tee /etc/mysql/mariadb.conf.d/50-server.cnf > /dev/null
	sudo systemctl restart mysql.service

bench:
	echo '' | sudo tee /var/log/nginx/access.log > /dev/null
	cd ../bench && ./bench -all-addresses 127.0.0.11 -target 127.0.0.11:443 -tls -jia-service-url http://127.0.0.1:4999
	@make alp

ALPSORT=sum
ALPM="/api/isu/.+/icon,/api/isu/.+/graph,/api/isu/.+/condition,/api/isu/[-a-z0-9]+,/api/condition/[-a-z0-9]+,/api/catalog/.+,/api/condition\?,/isu/........-....-.+"
OUTFORMAT=count,method,uri,min,max,sum,avg,p99
.PHONY: alp
alp:
	sudo alp ltsv --file=/var/log/nginx/access.log --sort $(ALPSORT) --reverse -o $(OUTFORMAT) -m $(ALPM) > alp.log
