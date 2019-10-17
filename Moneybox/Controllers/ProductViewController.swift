//
//  ProductViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 17/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var money: UILabel!
    
    var productText: String?
    var planText: String?
    var moneyText: String?
    
    @IBAction func addMoney(_ sender: UIButton) {
        print("Added £10")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = productText
        value.text = planText
        money.text = moneyText
    }
}
