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
            addGroup.leave()
        }
    }
    
    var updatedProductsData: InvestorProducts? {
        didSet {
            updateGroup.leave()
        }
    }
    
    let rest = RestService()
    let addGroup = DispatchGroup()
    let updateGroup = DispatchGroup()

    // MARK: - Functions
    
    func refreshPageData() {
        updateGroup.enter()
        guard let url = URL(string: "https://api-test01.moneyboxapp.com/investorproducts") else { self.updateGroup.leave(); return }
        
        rest.requestHttpHeaders.add(value: "3a97b932a9d449c981b595", forKey: "Appid")
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: "5.10.0", forKey: "appVersion")
        rest.requestHttpHeaders.add(value: "3.0.0", forKey: "apiVersion")
        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken!, forKey: "Authorization")
        rest.httpBodyParameters.clear()
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            
            if let response = results.response {
                if response.httpStatusCode != 200 {
                    print("\nRequest failed with HTTP status code", response.httpStatusCode, "\n")
                    guard let data = results.data else { return }
                    let decoder = JSONDecoder()
                    guard let authTimeout = try? decoder.decode(StandardErrorMessage.self, from: data) else { return }
                    print(authTimeout)
                    //TODO: show auth timeout error on UI
                    return
                }
            }

            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let updatedData = try? decoder.decode(InvestorProducts.self, from: data) else { return }
                self.updatedProductsData = updatedData
            }
        }
        return
    }

    @IBAction func addMoney(_ sender: UIButton) {
        oneOffPayment()
        addGroup.wait()
        updateUI(withNewMoneybox: moneyboxReturnData!)
    }
    
    func oneOffPayment() {
        addGroup.enter()
        guard let url = URL(string: "https://api-test01.moneyboxapp.com/oneoffpayments") else { return }
        
        rest.requestHttpHeaders.add(value: "3a97b932a9d449c981b595", forKey: "Appid")
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: "5.10.0", forKey: "appVersion")
        rest.requestHttpHeaders.add(value: "3.0.0", forKey: "apiVersion")
        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken!, forKey: "Authorization")
        
        rest.httpBodyParameters.add(value: "10", forKey: "Amount")
        rest.httpBodyParameters.add(value: String(productId!), forKey: "InvestorProductId")
        
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { self.addGroup.leave(); return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { self.addGroup.leave(); return }
                let decoder = JSONDecoder()
                if let moneyboxData = try? decoder.decode(Moneybox.self, from: data) {
                    self.moneyboxReturnData = moneyboxData
                    return
                }
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
            updateGroup.wait()
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
