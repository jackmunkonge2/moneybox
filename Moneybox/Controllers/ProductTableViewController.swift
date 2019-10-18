//
//  ProductTableViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 16/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    // MARK: - Properties
    var authToken: String?
    var data: InvestorProducts?
    var products = [InvestorProductResponse]()
    
    // MARK: - Table view data source
    
    private func loadProducts() {
        if let productResponses = self.data?.productResponses {
            products = productResponses
        } else {
            fatalError("Couldn't load data")
        }
    }

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
        
        let cellData = products[indexPath.row]
        
        cell.productName.text = cellData.product.friendlyName
        cell.planValue.text = "£\(String(cellData.planValue))"
        cell.moneybox.text = "£\(String(cellData.moneybox))"

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
        print(data!)
        print("\n")
        print(authToken!)
    }
}
