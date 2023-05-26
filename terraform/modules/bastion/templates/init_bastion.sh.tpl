sudo apt update -y && sudo apt upgrade -y
sudo apt install -y build-essential apache2-utils mlocate
sudo apt install -y nginx

sudo systemctl start nginx
sudo systemctl enable nginx

# Nginx Setup
echo 'user nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log;
events {
    worker_connections  10240;
}

http {
    include    conf/mime.types;
    include    /etc/nginx/proxy.conf;
    include    /etc/nginx/fastcgi.conf;
    index    index.html index.htm index.php;

    default_type application/octet-stream;
    access_log off;
    sendfile     on;
    tcp_nopush   on;
    server_names_hash_bucket_size 128; # this seems to be required for some vhosts

    upstream vault-servers {
        server ${vault_server_primary_address}:8200;           # Vault1 서버 내부 IP
        server ${vault_server_secondary_address}:8200 backup;  # Vault2 서버 내부 IP
    }

    server {
        listen       80 backlog=4096;
        listen       443;
        default_type application/json;
        server_name  _;
        proxy_connect_timeout 7d;
        proxy_send_timeout 7d;
        proxy_read_timeout 7d;
        proxy_set_header Accept-Encoding "";

        location / {
            proxy_connect_timeout       120;
            proxy_send_timeout          120;
            proxy_read_timeout          120;
            send_timeout                120;
            proxy_pass http://vault-servers;
        }
        location /healthz {
            return 200 "ok\n";
        }

        location /stub_status {
            stub_status   on;
            access_log    off;
        }

        error_page 423 /error ;
        error_page 500 /error ;
        error_page 502 /error ;
        error_page 503 /error ;
        error_page 504 /error ;

        location = /error {
            default_type application/json;
            return 500 "{ \"error\": \"internal error\", \"jsonrpc\": \"2.0\", \"id\": 1 }";
        }
    }
}' sudo tee /etc/nginx/nginx.conf

sudo systemctl restart nginx