
//  StoreViewController.swift
//  Santa'sSelfie
//
//  Created by Roman Salazar on 12/6/16.
//  Copyright © 2016 Roman Salazar. All rights reserved.
//

import UIKit
import StoreKit

let notificationsConstantName = "NotificationName"

class StoreViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var restoreButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var list = [SKProduct]()
    var myProduct = SKProduct()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barTintColor = .white
 
        
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
    @IBAction func buyButtonFired(_ sender: Any) {
        for product in list {
            let productID = product.productIdentifier
            if(productID == "01") {
                myProduct = product
                buyProduct()
                break;
            }
        }

    }

    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }

    // 3
    func buyProduct() {
        print("buy " + myProduct.productIdentifier)
        let pay = SKPayment(product: myProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    // 6 Create a button action that will restore the purchases. 
    @IBAction func restoredButtonPressed(_ sender: Any) {
        print("if fired... please print this message.")
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
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationsConstantName), object: nil)
                self.dismiss(animated: true, completion: nil)
                print("restored purchased here!")
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
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationsConstantName), object: nil)
                    self.dismiss(animated: true, completion: nil)
                    print("is should have been purchased now")
                default:
                    print("IAP not setup")
                }
                queue.finishTransaction(trans)
//                break;
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

