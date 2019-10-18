//
//  ProductTableViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 16/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController, MyDataSendingDelegateProtocol {
    
    // MARK: - Properties
    var authToken: String?
    var data: InvestorProducts?
    var products = [InvestorProductResponse]()
    var fullname: String?
    
    @IBOutlet weak var subheading: UILabel!
    
    // MARK: - Table view data source
    
    func sendDataBack(myData: InvestorProducts) {
        loadPageData(withData: myData)
    }
    
    private func loadPageData(withData data: InvestorProducts?) {
        if let productResponses = data?.productResponses {
            products = productResponses
        } else {
            fatalError("Couldn't load data")
        }
        
        if let userName = self.fullname {
            subheading.text = subheading.text?.replacingOccurrences(of: " Name", with: " \(userName)")
        } else {
            subheading.text = subheading.text?.replacingOccurrences(of: " Name", with: "")
        }
        
        if let planValue = data?.totalPlanValue {
            subheading.text = subheading.text?.replacingOccurrences(of: "0000", with: String(format: "%.2f", planValue))
        }
        
        self.tableView.reloadData()
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
        cell.planValue.text = "Plan Value: £\(String(cellData.planValue))"
        cell.moneybox.text = "Moneybox: £\(String(cellData.moneybox))"

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
            productVC.productId = product.id
            productVC.authToken = self.authToken
            
            let secondVC: ProductViewController = segue.destination as! ProductViewController
            secondVC.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPageData(withData: self.data)
    }
}
