# Todo

- in staff table add permissions separated by , only
- add expire date in all premium server. So that they must update every year
- Use built-in certificate for using ssl.
- offline apps should support only one store.
- have permissions table to assign users permission based on permission type.
- Option to merge brands/products which are duplicated
- option to disable every body to create store. This should be default.
- use `DESC` for all lists.
- add currency to store
- `return store, result.Error` this is bad idea because it returns object with zero values.
- if server is embedded use different jwt key
- brand cascade dont work
- Users may add duplicates products, you should have a feature to merge them all
- For easier import retail could create invoice and go to wholesalers and offer that invoice to be scanned, then map it
  and user could enjoy seamless import
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

## Types of app

### Offline

- Community Edition (For device powered by SQLite)
- Enterprise Edition (For multiple users powered by postgres)
- Dedicated Edition (Run on your own server)
- Cloud Edition (Everything on us)

```console

go run github.com/99designs/gqlgen init

```

go run server.go go run server.go -mod=mod go run ./server.go

go run -mod=mod github.com/99designs/gqlgen generate

go mod tidy go generate ./...

```bash
go get -d golang.org/x/mobile/cmd/gomobile 
gomobile bind -v -o ../client/packages/server/android/libs/server.aar -target=android ./lib
```

```bash
go build -o ../client/packages/server/windows/lib.dll -buildmode=c-shared lib.go
go build -o ../client/packages/server/android/libs/lib.so -buildmode=c-shared lib.go
```