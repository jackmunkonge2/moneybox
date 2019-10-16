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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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

}
