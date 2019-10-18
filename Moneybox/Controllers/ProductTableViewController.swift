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
    var fullname: String?
    
    @IBOutlet weak var subheading: UILabel!
    
    // MARK: - Table view data source
    
    private func loadPageData() {
        if let productResponses = self.data?.productResponses {
            products = productResponses
        } else {
            fatalError("Couldn't load data")
        }
        
        if let userName = self.fullname {
            subheading.text = subheading.text?.replacingOccurrences(of: " Name", with: " \(userName)")
        } else {
            subheading.text = subheading.text?.replacingOccurrences(of: " Name", with: "")
        }
        
        if let planValue = self.data?.totalPlanValue {
            subheading.text = subheading.text?.replacingOccurrences(of: "0000", with: String(format: "%.2f", planValue))
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "productSegue", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productSegue" {
            let productVC = segue.destination as! ProductViewController
            let selectedRow = sender as? Int
            let product = self.products[selectedRow!]
            productVC.productText = product.product.friendlyName
            productVC.planText = "Plan Value: £\(String(product.planValue))"
            productVC.moneyText = "Moneybox: £\(String(product.moneybox))"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageData()
    }
}
