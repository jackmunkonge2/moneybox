//
//  ProductViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 17/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var money: UILabel!
    
    var productText: String?
    var planText: String?
    var moneyText: String?
    var productId: Int?
    var authToken: String?
    
    var moneyboxReturnData: MoneyboxResponse? {
        didSet {
            addGroup.leave()
        }
    }
    
    let rest = RestManager()
    let addGroup = DispatchGroup()

    // MARK: - Functions

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
                if let moneyboxData = try? decoder.decode(MoneyboxResponse.self, from: data) {
                    self.moneyboxReturnData = moneyboxData
                    return
                }
            }
        }
        return
    }
    
    func updateUI(withNewMoneybox moneyboxResponse: MoneyboxResponse) {
        let newValue = Int(moneyboxResponse.moneybox)
        guard let previousValue = Int(money.text!.filter { "0"..."9" ~= $0 }) else { return }
        money.text = money.text?.replacingOccurrences(of: String(previousValue), with: String(newValue))
    }
    
    // MARK: - UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = productText
        value.text = planText
        money.text = moneyText
    }
}
