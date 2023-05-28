{{- define "namespace" -}}
app
{{- end -}}

{{- define "name" -}}
{{ .Release.Name }}
{{- end -}}

{{- define "common.labels"}}
app.kubernetes.io/name: {{ template "name" . }}
{{- end }}


{{- define "configmap.name" -}}
{{ template "name" . }}-nginx-conf
{{- end }}

{{- define "configmap.data" -}}
user nginx;
worker_processes  2;
events {
  worker_connections  1024;
}
env FOO1;
http {
  include mime.types;
  server {
    listen {{ .Values.service.targetPort }} default_server;
    index index.html;
    server_name  _;
    root /usr/share/nginx/html/;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    location / {
      set_by_lua $FOO1 'return os.getenv("FOO1")';
      set_by_lua $FOO2 'return os.getenv("FOO2")';
      return 200 $FOO1\n$FOO2;
      #root   /usr/share/nginx/html;
      #autoindex on;
      #try_files $uri $uri/ /index.html;
    }

    # Media: images, icons, video, audio, HTC
    location ~* \.(?:jpg|jpeg|gif|png|ico|cur|gz|svg|svgz|mp4|ogg|ogv|webm|htc)$ {
      root   /usr/share/nginx/html;
      expires 1M;
      access_log off;
      add_header Cache-Control "public";
    }

    location ~* \.(?:css|js)$ {
      root   /usr/share/nginx/html;
      try_files $uri =404;
      expires 1y;
      access_log off;
      add_header Cache-Control "public";
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
}
{{- end }}