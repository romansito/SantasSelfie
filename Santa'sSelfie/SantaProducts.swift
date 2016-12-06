//
//  SantaProducts.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 12/6/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import Foundation

public struct SantaProducts {
    
    public static let ExtendedSantaSelfiesPack = "01"
    fileprivate static let productIdentifiers: Set<ProductIdentifier> = [SantaProducts.ExtendedSantaSelfiesPack]
    public static let store = IAPHelper(productIds: SantaProducts.productIdentifiers)

}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
