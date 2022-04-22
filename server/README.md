# Todo
- marketplace for items like wholesalers
- allow free port coming from android
- Transfer items between warehouse and store
- db types
- order status enum
- Don't over-fetch db https://gqlgen.com/reference/field-collection/
- Integrate Gin https://gqlgen.com/recipes/gin/
- separate table for customers??
- adding staff should be like adding manager on YouTube, one need to know email

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