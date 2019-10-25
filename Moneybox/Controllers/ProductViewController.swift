//
//  ProductViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 17/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

protocol MyDataSendingDelegateProtocol {
    func sendDataBack(myData: InvestorProducts)
}

class ProductViewController: UIViewController {
    
    // MARK: - Properties
    
    var delegate: MyDataSendingDelegateProtocol? = nil
        
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var money: UILabel!
    
    var productText: String?
    var planText: String?
    var moneyText: String?
    var productId: Int?
    var authToken: String?
    
    var moneyboxReturnData: Moneybox? {
        didSet {
            restThread.leave()
        }
    }
    
    var updatedProductsData: InvestorProducts? {
        didSet {
            restThread.leave()
        }
    }
    
    let rest = RestService()
    let restThread = DispatchGroup()

    // MARK: - Functions
    
    func refreshPageData() {
        restThread.enter()
        
        guard let url = URL(string: "/investorproducts", relativeTo: Constants.baseURL) else { self.restThread.leave(); return }
        
        rest.requestHttpHeaders.add(value: Constants.appId, forKey: "Appid")
        rest.requestHttpHeaders.add(value: Constants.contentType, forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: Constants.appVersion, forKey: "appVersion")
        rest.requestHttpHeaders.add(value: Constants.apiVersion, forKey: "apiVersion")
        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken!, forKey: "Authorization")
        rest.httpBodyParameters.clear()
        
        rest.makeRequest(toURL: url.absoluteURL, withHttpMethod: .get) { (results) in
            let decodedData: Any = DecodeUtil.decodeInvestorResults(using: results)
            
            if let data = decodedData as? InvestorProducts {
                self.updatedProductsData = data
            } else if let data = decodedData as? AuthErrorMessage {
                print(data)
                // TODO: Logout here
                self.restThread.leave()
            } else {
                let data = decodedData as? StandardErrorMessage
                print(data!);
                // TODO: Logout here
                self.restThread.leave()
            }
        }
        return
    }

    @IBAction func addMoney(_ sender: UIButton) {
        oneOffPayment()
        restThread.wait()
        updateUI(withNewMoneybox: moneyboxReturnData!)
    }
    
    func oneOffPayment() {
        restThread.enter()
        
        guard let url = URL(string: "/oneoffpayments", relativeTo: Constants.baseURL) else { return }
        
        rest.requestHttpHeaders.add(value: Constants.appId, forKey: "Appid")
        rest.requestHttpHeaders.add(value: Constants.contentType, forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: Constants.appVersion, forKey: "appVersion")
        rest.requestHttpHeaders.add(value: Constants.apiVersion, forKey: "apiVersion")
        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken!, forKey: "Authorization")
        
        rest.httpBodyParameters.add(value: Constants.moneybox, forKey: "Amount")
        rest.httpBodyParameters.add(value: String(productId!), forKey: "InvestorProductId")
        
        rest.makeRequest(toURL: url.absoluteURL, withHttpMethod: .post) { (results) in
            let decodedData: Any = DecodeUtil.decodeMoneyboxResults(using: results)
            
            if let data = decodedData as? Moneybox {
                self.moneyboxReturnData = data
            } else if let data = decodedData as? AuthErrorMessage {
                print(data)
                // TODO: Logout here
                self.restThread.leave()
            } else {
                let data = decodedData as? StandardErrorMessage
                print(data!);
                // TODO: Logout here
                self.restThread.leave()
            }
        }
        return
    }
    
    func updateUI(withNewMoneybox moneyboxResponse: Moneybox) {
        let newValue = Int(moneyboxResponse.moneybox)
        guard let previousValue = Int(money.text!.filter { "0"..."9" ~= $0 }) else { return }
        money.text = money.text?.replacingOccurrences(of: String(previousValue), with: String(newValue))
    }
    
    // MARK: - Navigation
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.delegate != nil {
            refreshPageData()
            restThread.wait()
            let dataToBeSent = self.updatedProductsData
            self.delegate?.sendDataBack(myData: dataToBeSent!)
        }
    }
    
    // MARK: - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        name.text = productText
        value.text = planText
        money.text = moneyText
    }
}
