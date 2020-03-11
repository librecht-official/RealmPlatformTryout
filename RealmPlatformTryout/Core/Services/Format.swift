//
//  Format.swift
//  RealmPlatformTryout
//
//  Created by Vladislav Librecht on 05/12/2019.
//  Copyright © 2019 Vladislav Librekht. All rights reserved.
//

import Foundation

enum Format {
    static func price(product: Product) -> String {
        let p = product.price(currencyCode: Locale.current.currencyCode)
        return price(p.0, currencyCode: p.currencyCode)
    }
    
    static func price(_ value: Decimal, currencyCode: String) -> String {
        NumberFormatter.currency.currencyCode = currencyCode
        let number = NSNumber(value: (value as NSDecimalNumber).doubleValue)
        let formatted = NumberFormatter.currency.string(from: number)
        return formatted ?? String(format: "%s %.2f", arguments: [currencyCode, number])
    }
}

extension DateFormatter {
    static let defaultDateTime: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
}

extension NumberFormatter {
    static let currency: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        return formatter
    }()
}
