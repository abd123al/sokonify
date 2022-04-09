```console

go run github.com/99designs/gqlgen init

```

go run server.go
go run server.go -mod=mod
go run ./server.go

go run -mod=mod github.com/99designs/gqlgen generate

go mod tidy
go generate ./...

go get -d golang.org/x/mobile/cmd/gomobile
gomobile bind -v -o ../client/packages/server/android/libs/server.aar -target=android ./lib

# Todo
- Transfer items between warehouse and store
- db types
- order status enum