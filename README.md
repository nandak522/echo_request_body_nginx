### To build
```sh
docker build -t nginx:custom .
```

### To run
```sh
docker run -v $PWD/nginx.conf:/etc/nginx/nginx.conf -p 8080:80 -it nginx:custom
```

### To fire calls to nginx using curl
```sh
curl http://0.0.0.0:8080/
curl http://0.0.0.0:8080/echo
curl -d "user=nanda&password=hi" http://0.0.0.0:8080/echo
```
