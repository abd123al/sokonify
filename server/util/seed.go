package util

import "strings"

/// Drug name | Drug code | Brands
var drugs = `
Paracetamol Syrup 100ml | pcm_tab | Prinadol,Zenadol
Paracetamol Tablet 500mg | pcm_syrup |
`

type SeedItem struct {
	name   string
	code   string
	brands []string
}

func Seed() []SeedItem {
	var items []SeedItem

	raw := strings.Split(drugs, "\n")

	for _, v := range raw {
		if len(strings.Trim(v, "")) > 1 {
			var brands []string

			array := strings.Split(v, "|")

			title := strings.Trim(array[0], "")
			code := strings.Trim(array[1], "")
			rawBrands := strings.Trim(array[2], "")

			if strings.Contains(rawBrands, ",") {
				sub := strings.Split(rawBrands, ",")

				for _, brand := range sub {
					//We don't need an empty string
					if len(v) > 1 {
						brands = append(brands, strings.Trim(brand, ""))
					}
				}
			} else {
				if len(rawBrands) > 1 {
					brands = append(brands, rawBrands)
				}
			}

			items = append(items, SeedItem{
				name:   title,
				code:   code,
				brands: brands,
			})
		}
	}

	return items
}
