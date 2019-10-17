//
//  ProductTableViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 16/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    var products = [Product]()
    
    private func loadSampleProducts() {
        
        guard let product1 = Product(productName: "Stocks and Shares ISA", planValue: "£1000", moneybox: "£50") else {
            fatalError("Unable to instantiate product1")
        }
        
        guard let product2 = Product(productName: "General Investment Account", planValue: "£2000", moneybox: "£100") else {
            fatalError("Unable to instantiate product2")
        }
        
        guard let product3 = Product(productName: "Lifetime ISA", planValue: "£3000", moneybox: "£150") else {
            fatalError("Unable to instantiate product3")
        }
        
        products += [product1, product2, product3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleProducts()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ProductTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ProductTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProductTableViewCell.")
        }
        
        let product = products[indexPath.row]
        
        cell.productName.text = product.productName
        cell.planValue.text = product.planValue
        cell.moneybox.text = product.moneybox

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productSegue" {
             let productVC = segue.destination as! ProductViewController
            productVC.productText = "test"
            productVC.planText = "Plan Value: £999"
            productVC.moneyText = "Moneybox: £99"
        }
    }
}
