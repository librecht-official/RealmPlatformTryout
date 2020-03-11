//
//  EditorAlert.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 31/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import UIKit


func editorAlert(env: ProductsAPIEnvironment, product: Product?) -> UIViewController {
    let title = product == nil ? "New product" : "Edit product"
    
    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
    alert.addTextField { textField in
        textField.placeholder = "Product name"
        textField.text = product?.name
    }
    alert.addTextField { textField in
        textField.placeholder = "Description"
        textField.text = product?.desc
    }
    let submit = UIAlertAction(title: "Submit", style: .default) { [unowned alert] action in
        let newName = alert.textFields![0].text ?? ""
        let newDescription = alert.textFields![1].text ?? ""
        if let product = product {
            _ = env.productsDAO.update(product.id, properties: [
                .name(newName),
                .desc(newDescription)
            ])
        } else {
            let newProduct = Product(
                id: UUID().uuidString,
                name: newName,
                desc: newDescription,
                priceUSD: 0,
                priceRUB: 0
            )
            _ = env.productsDAO.add(newProduct, update: false)
        }
    }
    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(submit)
    alert.addAction(cancel)
    
    return alert
}
