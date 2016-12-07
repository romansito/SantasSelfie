
//  StoreViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 12/6/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import StoreKit

class StoreViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var list = [SKProduct]()
    var myProduct = SKProduct()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set IAPS (1)
        if(SKPaymentQueue.canMakePayments()) {
            print("iAP is enabled, loading")
            let productID : NSSet = NSSet(objects: "01")
            let request : SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            
            request.delegate = self
            request.start()
        } else {
            print("Please enable IAPS")
        }
    }
    // 2
    @IBAction func buyButtonPressed(_ sender: Any) {
        for product in list {
            let productID = product.productIdentifier
            if(productID == "01") {
                myProduct = product
                buyProduct()
                break;
            }
        }
    }
    
    // 3
    func buyProduct() {
        print("buy " + myProduct.productIdentifier)
        let pay = SKPayment(product: myProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }

    func addExtendSantaPackage() {
        // let the choose view controller know that he needs to show 4 extra images.
    }
    
    // 6 Create a button action that will restore the purchases. 
    
    func restorePurchase(sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let requestedProduct = response.products
        
        for product in requestedProduct {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            
            list.append(product)
        }
        
        // Do something here
        
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restores")
        
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction
            let productID = t.payment.productIdentifier as String
            
            switch productID {
            case "01":
            // execute code here for what ever is going to happen.
                print("do something to add 4 more images.")
            default:
                print("IAP not setup")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction: AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
//            print(trans.error!)
            
            switch trans.transactionState {
                
            case .purchased:
                print("buy, ok unlock iap here")
                print(myProduct.productIdentifier)
                
                let prodID = myProduct.productIdentifier as String
                switch prodID {
                case "01":
                    print("remove ads")
//                    removeAds()
                case "seemu.iap.addcoins":
                    print("add coins to account")
//                    addCoins()
                default:
                    print("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                print("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction) {
        print("finish trans")
        SKPaymentQueue.default().finishTransaction(trans)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans");
    }
    
    
}

