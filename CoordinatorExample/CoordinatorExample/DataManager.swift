//
//  DataManager.swift
//  CoordinatorExample
//
//  Created by Aleksandar Vacić on 14.5.17..
//  Copyright © 2017. Radiant Tap. All rights reserved.
//

import Foundation

protocol UsesDataManager {
	var dataManager: DataManager { get }
}


//	General Data handler
final class DataManager {

	fileprivate(set) var seasons: [Season] = []
	fileprivate(set) var promotedProducts: [Product] = []

	init() {
		loadProducts()
	}
}


fileprivate extension DataManager {
	func loadProducts() {
		//	populate data source, so there's something for the rest of the app to use

		let season = Season(name: "Spring/Summer 2017")

		let categoryNames = ["Coat", "Dress", "Long Jacket", "Blouse/Top", "Pants", "Cardigan", "Skirt", "Pullover", "Jacket", "Top", "Pullwarmer", "Scarf", "Tunic"]
		let categories: [Category] = categoryNames.map({ Category(name: $0) })

		let catDress = categories[1]
		let catCardigan = categories[5]
		let catJacket = categories[8]
		let catLongJacket = categories[2]

		let themeNames = ["Mad Huts", "The Power of Flowers", "Guatemala", "Balkan Fusion"]
		let themes: [Theme] = themeNames.map({ Theme(name: $0) })

		season.categories = categories
		season.themes = themes

		seasons = [season]

		//	products
		let p1: Product =  {
			let p = Product(name: "Cardigan Floral Embroidery", styleCode: "71616")
			p.category = catCardigan
			p.promoImagePath = "slide2"
			p.desc = "Slim-fit cardigan with floral embroidery and stripes, fastened by ribbons with wooden pendants. Fabric is designed so that it gently holds the shape after you model it."
			p.materials = ["95% Cotton", "5% Polyamide"]
			p.careInstructions = "Hand wash. Dry flat."
			p.colors = [Color.c18, Color.c40]
			p.imagePaths = ["71546-11a", "71546-11ab", "71546-11b", "71546-11c", "71546-18a", "71546-18b", "71546-18c"]
			p.gridImagePath = "71546-11b"
			return p
		}()
		promotedProducts.append(p1)
		catCardigan.products.append(p1)

		let p2: Product =  {
			let p = Product(name: "Shirt Dress with Print", styleCode: "71546")
			p.category = catDress
			p.promoImagePath = "slide5"
			p.desc = "Extraordinary versatile shirt dress. Try wearing it buttoned down and tied on the waist or let it flow open with your favourite summer trousers."
			p.materials = ["100% Viscose"]
			p.careInstructions = "Hand wash. Dry flat."
			p.colors = [Color.c18, Color.c11]
			return p
		}()
		promotedProducts.append(p2)
		catDress.products.append(p2)

		let p3: Product =  {
			let p = Product(name: "Jacquard Dress", styleCode: "71525")
			p.category = catDress
			p.promoImagePath = "slide1"
			p.desc = "Luxurious dress richly ornamented with jacquard pattern. A piece that will make you shine with graceful elegance whenever you wear it."
			p.materials = ["65% Viscose", "33% Cotton", "2% Polyamide"]
			p.careInstructions = "Hand wash. Dry flat."
			p.colors = [Color.c18, Color.c39]
			return p
		}()
		promotedProducts.append(p3)
		catDress.products.append(p3)

		let p4: Product =  {
			let p = Product(name: "V-Neck Jacket Floral Embroidery", styleCode: "71613")
			p.category = catJacket
			p.promoImagePath = "slide4"
			p.desc = "Luxurious light and soft V-neck jacket with elegant pleats and dashing floral embroidery. Notice the dainty embroidered stripe on the waist and single button fastening."
			p.materials = ["52% Viscose", "45% Cotton", "3% Polyester"]
			p.careInstructions = "Hand wash. Dry flat."
			p.colors = [Color.c19, Color.c11, Color.c35, Color.c40, Color.c72]
			return p
		}()
		promotedProducts.append(p4)
		catJacket.products.append(p4)

		let p5: Product =  {
			let p = Product(name: "Jacquard Long Jacket", styleCode: "71601")
			p.category = catLongJacket
			p.promoImagePath = "slide3"
			p.desc = "The luxurious design of this long jacket make it a signature piece that stands out in the most sophisticated crowd. Innovative knit technique makes colour dance throughout the fabric creating a great finale in vivid jacquard pattern that is flowing around button closure and asymmetric hems."
			p.materials = ["100% Cotton"]
			p.careInstructions = "Hand wash. Dry flat."
			p.colors = [Color.c18, Color.c11, Color.c35, Color.c72]
			return p
		}()
		promotedProducts.append(p5)
		catLongJacket.products.append(p5)
	}
}
