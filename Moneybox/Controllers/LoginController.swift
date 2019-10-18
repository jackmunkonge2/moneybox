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
            fetchGroup.leave()
        }
    }
    
    let loginGroup = DispatchGroup()
    let fetchGroup = DispatchGroup()
    
    let rest = RestManager()
    
    var authToken = ""
    
    var loggedIn = false
        
    @IBOutlet weak var email: UITextField! { didSet { email.delegate = self } }
    
    @IBOutlet weak var password: UITextField! { didSet { password.delegate = self } }
    
    @IBOutlet weak var fullname: UITextField!
    
    @IBAction func unwindToGlobal(segue: UIStoryboardSegue) {
    }
    
    // MARK: - Rest Functions
    
    func attemptLogin(withEmail email: String!, withPassword password: String!) {
        guard let url = URL(string: "https://api-test01.moneyboxapp.com/users/login") else { return }
     
        rest.requestHttpHeaders.add(value: "3a97b932a9d449c981b595", forKey: "Appid")
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: "5.10.0", forKey: "appVersion")
        rest.requestHttpHeaders.add(value: "3.0.0", forKey: "apiVersion")
        
        rest.httpBodyParameters.add(value: email, forKey: "Email")
        rest.httpBodyParameters.add(value: password, forKey: "Password")
        rest.httpBodyParameters.add(value: "ANYTHING", forKey: "Idfa")
        
        self.loginGroup.enter()
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { self.loginGroup.leave(); return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { self.loginGroup.leave(); return }
                let decoder = JSONDecoder()
                guard let loginSuccess = try? decoder.decode(LoginSuccess.self, from: data) else { self.loginGroup.leave(); return }
                print("\n\nLogged in successfully!\nBearer Token: \(loginSuccess.session.bearerToken)\n")
                self.authToken = loginSuccess.session.bearerToken
                self.loggedIn = true;
                self.loginGroup.leave()
            } else {
                guard let data = results.data else { self.loginGroup.leave(); return }
                let decoder = JSONDecoder()
                guard let noAuthorization = try? decoder.decode(StandardErrorResponse.self, from: data) else {
                    let invalidCredentials = try! decoder.decode(ValidationErrorResponse.self, from: data)
                    print(invalidCredentials);
                    //TODO: show invalidcreds error on UI
                    self.loginGroup.leave()
                    return
                }
                print(noAuthorization)
                //TODO: show no auth error on UI
                self.loginGroup.leave()
                return
            }
        }
    }
    
    func getInvestorProducts() {
        self.fetchGroup.enter()
        
        guard let url = URL(string: "https://api-test01.moneyboxapp.com/investorproducts") else { self.fetchGroup.leave(); return }

        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken, forKey: "Authorization")
        rest.httpBodyParameters.clear()
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in

            if let response = results.response {
                if response.httpStatusCode != 200 {
                    print("\nRequest failed with HTTP status code", response.httpStatusCode, "\n")
                    guard let data = results.data else { return }
                    let decoder = JSONDecoder()
                    guard let authTimeout = try? decoder.decode(StandardErrorResponse.self, from: data) else { return }
                    print(authTimeout)
                    //TODO: show auth timeout error on UI
                    return
                }
            }

            if let data = results.data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let investorProductData = try? decoder.decode(InvestorProducts.self, from: data) else { return }
                self.outputData = investorProductData
            }
        }
        return
    }
    
    // MARK: - Navigation
    
    @IBAction func clickLogin(_ sender: UIButton) {
        email.resignFirstResponder()
        password.resignFirstResponder()
        
        if !email.hasText || !password.hasText {
            email.layer.borderWidth = 1
            email.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            password.layer.borderWidth = 1
            password.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        } else {
            attemptLogin(withEmail: email.text, withPassword: password.text)
            self.loginGroup.wait()
            if loggedIn {
                getInvestorProducts()
                self.fetchGroup.wait()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        email.layer.borderWidth = 0
        password.layer.borderWidth = 0
    }
}

