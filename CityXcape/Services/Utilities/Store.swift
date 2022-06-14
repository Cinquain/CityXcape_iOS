//
//  Store.swift
//  CityXcape
//
//  Created by James Allan on 6/11/22.
//

import StoreKit


typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)
class Store: NSObject, ObservableObject {
    
    
    private let allProductsIdentifiers = Set([
        "com.cityportal.CityXcape.streetcred"
    ])
    
    
    private var productsRequest: SKProductsRequest?
    private var fetchedProducts: [SKProduct] = []
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var completedPurchases = [String]()
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    override init() {
        super.init()
        startObservingPaymentQueue()
        fetchProducts { products in
            print(products)
        }
    }
    
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productsRequest == nil else {return}
        
        fetchCompletionHandler = completion
        productsRequest = SKProductsRequest(productIdentifiers: allProductsIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    
    private func buy(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        purchaseCompletionHandler = completion
    }
    
}


extension Store  {
    
    func product(for Identifier: String) -> SKProduct? {
        return fetchedProducts.first(where: {$0.productIdentifier == Identifier})
    }
    
    func purchaseProduct(_ product: SKProduct, completion: @escaping (Result<Bool, PurchaseError>) -> Void) {
        startObservingPaymentQueue()
        buy(product) { transaction in
            //Add StreetCred to the buyers wallet
            if transaction?.transactionState == .purchased  {
                print("Product was successfully purchased")
                completion(.success(true))
            } else {
                print("Transaction Failed!")
                completion(.failure(.failed))
            }
            
        }
    }
}

extension Store: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
            switch transaction.transactionState {
            case .purchased, .restored:
                //Save to purchase memory
                completedPurchases.append(transaction.payment.productIdentifier)
                //Signal end of transaction
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
            
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
}


extension Store: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        
        guard !loadedProducts.isEmpty else {
            //Unsuccess block
            print("Could not load products")
            if !invalidProducts.isEmpty {
                print("Found invalid products: \(invalidProducts)")
            }
            productsRequest = nil
            return
        }
        
        //Success block
        fetchedProducts = loadedProducts
        
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequest = nil
        }
        
    }
    
    
}
