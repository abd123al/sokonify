# Todo

- Users may add duplicates products, you should have a feature to merge them all
- For easier import retail could create invoice and go to wholesalers and offer that invoice to be scanned, then map it and user could enjoy seamless import
- Find a way to check permission to perform action in that store. (Solutions: use directive)
- Create JWT when user switch store
- attach staff id in everything, so that we know who did what.
- Easy import
- marketplace for items like wholesalers where people could to orders
- In marketplace,QR code scanning when ordering user should map what they order to what correlates. This way we can
  easily update their stocks
- allow free port coming from android
- Transfer items between warehouse and store
- db types
- order status enum
- Don't over-fetch db https://gqlgen.com/reference/field-collection/
- Integrate Gin https://gqlgen.com/recipes/gin/
- separate table for customers??
- adding staff should be like adding manager on YouTube, one need to know email
- Don't deploy until you can manage access to other stores

```console

go run github.com/99designs/gqlgen init

```

go run server.go go run server.go -mod=mod go run ./server.go

go run -mod=mod github.com/99designs/gqlgen generate

go mod tidy go generate ./...

go get -d golang.org/x/mobile/cmd/gomobile gomobile bind -v -o ../client/packages/server/android/libs/server.aar
-target=android ./lib