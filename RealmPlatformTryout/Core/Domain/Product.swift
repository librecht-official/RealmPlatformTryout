//
//  Product.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 23/10/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation


struct Product {
    let id: String
    let name: String
    let desc: String
    let priceUSD: Decimal
    let priceRUB: Decimal
    
    func price(currencyCode: String?) -> (Decimal, currencyCode: String) {
        switch currencyCode {
        case "RUB": return (priceRUB, "RUB")
        default: return (priceUSD, "USD")
        }
    }
}
