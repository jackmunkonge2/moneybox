//
//  LoginController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 14/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var outputData: InvestorProducts? {
        didSet {
            restThread.leave()
        }
    }
    
    let restThread = DispatchGroup()
    let rest = RestService()
    var authToken = ""
    var loggedIn = false
        
    @IBOutlet weak var email: UITextField! { didSet { email.delegate = self } }
    @IBOutlet weak var password: UITextField! { didSet { password.delegate = self } }
    @IBOutlet weak var fullname: UITextField! { didSet {fullname.delegate = self } }
    
    // MARK: - Rest Functions
    
    func attemptLogin(withEmail email: String!, withPassword password: String!) {
        self.restThread.enter()

        guard let url = URL(string: "/users/login", relativeTo: Constants.baseURL) else { return }
     
        rest.requestHttpHeaders.add(value: Constants.appId, forKey: "Appid")
        rest.requestHttpHeaders.add(value: Constants.contentType, forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: Constants.appVersion, forKey: "appVersion")
        rest.requestHttpHeaders.add(value: Constants.apiVersion, forKey: "apiVersion")
        
        rest.httpBodyParameters.add(value: email, forKey: "Email")
        rest.httpBodyParameters.add(value: password, forKey: "Password")
        rest.httpBodyParameters.add(value: Constants.idfa, forKey: "Idfa")
        
        rest.makeRequest(toURL: url.absoluteURL, withHttpMethod: .post) { (results) in
            let decodedData: Any = DecodeUtil.decodeLoginResults(using: results)
            
            if let data = decodedData as? LoginSuccess {
                self.authToken = data.session.bearerToken
                self.loggedIn = true
            } else if let data = decodedData as? ValidationErrorMessage {
                print(data);
            } else if let data = decodedData as? AuthErrorMessage {
                print(data);
            } else {
                let data = decodedData as? StandardErrorMessage
                print(data!);
            }
            self.restThread.leave()
        }
    }
    
    func getInvestorProducts() {
        self.restThread.enter()
        
        guard let url = URL(string: "/investorproducts", relativeTo: Constants.baseURL) else { self.restThread.leave(); return }

        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken, forKey: "Authorization")
        rest.httpBodyParameters.clear()
        
        rest.makeRequest(toURL: url.absoluteURL, withHttpMethod: .get) { (results) in
            let decodedData: Any = DecodeUtil.decodeInvestorResults(using: results)
            
            if let data = decodedData as? InvestorProducts {
                self.outputData = data
            } else if let data = decodedData as? AuthErrorMessage {
                print(data)
                self.loggedIn = false
                self.restThread.leave()
            } else {
                let data = decodedData as? StandardErrorMessage
                print(data!);
                self.loggedIn = false
                self.restThread.leave()
            }
        }
        return
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {
    }
    
    @IBAction func clickLogin(_ sender: UIButton) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        fullname.resignFirstResponder()
        
        if !email.hasText || !password.hasText {
            email.layer.borderWidth = 2
            email.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            password.layer.borderWidth = 2
            password.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            attemptLogin(withEmail: email.text, withPassword: password.text)
            self.restThread.wait()
            if loggedIn {
                getInvestorProducts()
                self.restThread.wait()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let productListVC = segue.destination as! ProductTableViewController
            productListVC.data = self.outputData
            productListVC.authToken = self.authToken
            if self.fullname.hasText {
                productListVC.fullname = self.fullname.text
            }
        }
    }
    
    // MARK: - UI

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.loggedIn = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        email.layer.borderWidth = 0
        password.layer.borderWidth = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

