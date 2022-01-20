# Instabug Challenge

## List of commands to test the app
### Please keep in mind that messages_count and chats_count are cached in redis, It expires after 1 hour and recalculcated

I exposed rails api on port `3001`

#### Run the system using
```
docker-compose up
```

#### Get Applications

```sh
$ curl -X GET \
    http://localhost:3001/applications \
    -H 'content-type: application/json'
```

#### New Application

```sh
$ curl -X POST \
    http://localhost:3001/applications \
    -H 'content-type: application/json' \
    -d '{
  	"name":"Application",
    }'
```

It returns Application token you can use for example: _notPr3aL9xdrKzIoQmV0A

#### Delete Application

```sh
$ curl -X DELETE \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A \
    -H 'content-type: application/json' \
    -d '{
  	"name":"Application",
    }'
```

#### Update Application

```sh
$ curl -X PUT \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A \
    -H 'content-type: application/json' \
    -d '{
  	"name":"Another Application",
    }'
```

#### Get Chats

```sh
$ curl -X GET \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A/chats \
    -H 'content-type: application/json' \
  }'
```

#### New Chat

```sh
$ curl -X POST \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A/chats \
    -H 'content-type: application/json' \
  }'
```
It will return number - 1

#### Another New Chat

```sh
$ curl -X POST \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A/chats \
    -H 'content-type: application/json' \
  }'
```
It will return number - 2

#### Delete Chat

```sh
$ curl -X DELETE \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A/chats/2 \
    -H 'content-type: application/json'
```

#### Get Messages

```sh
$ curl -X GET \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A/chats/1/messages \
    -H 'content-type: application/json'
```

#### New Message

```sh
$ curl -X POST \
    http://localhost:3001/applications/_notPr3aL9xdrKzIoQmV0A/chats/1/messages \
    -H 'content-type: application/json' \
    -d '{
  	"content":"Hello World",
    }'
```
it will return message number: 1

#### Another New Message

```sh
$ curl -X POST \
    http://localhost:3001/applications/xxxxxxxx/chats/1/messages \
    -H 'content-type: application/json' \
    -d '{
  	"content":"Hello Omar",
    }'
```
it will return message number: 2

#### Update Message

```sh
$ curl -X PUT \
    http://localhost:3001/applications/xxxxxxxx/chats/1/messages/2 \
    -H 'content-type: application/json' \
    -d '{
  	"content":"Hello OmarZZZ",
    }'
```
it will return message number: 2 again

#### Delete Message

```sh
$ curl -X DELETE \
    http://localhost:3001/applications/xxxxxxxx/chats/1/messages/2 \
    -H 'content-type: application/json'
```
it will return message number: 2 again
