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

        guard let url = URL(string: "/users/login", relativeTo: Constants.baseURL) else { return }
     
        rest.requestHttpHeaders.add(value: Constants.appId, forKey: "Appid")
        rest.requestHttpHeaders.add(value: Constants.contentType, forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: Constants.appVersion, forKey: "appVersion")
        rest.requestHttpHeaders.add(value: Constants.apiVersion, forKey: "apiVersion")
        
        rest.httpBodyParameters.add(value: email, forKey: "Email")
        rest.httpBodyParameters.add(value: password, forKey: "Password")
        rest.httpBodyParameters.add(value: Constants.idfa, forKey: "Idfa")
        
        self.restThread.enter()
        rest.makeRequest(toURL: url.absoluteURL, withHttpMethod: .post) { (results) in
            guard let response = results.response else { self.restThread.leave(); return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { self.restThread.leave(); return }
                let decoder = JSONDecoder()
                guard let loginSuccess = try? decoder.decode(LoginSuccess.self, from: data) else { self.restThread.leave(); return }
                print("\n\nLogged in successfully!\nBearer Token: \(loginSuccess.session.bearerToken)\n")
                self.authToken = loginSuccess.session.bearerToken
                self.loggedIn = true;
                self.restThread.leave()
            } else {
                guard let data = results.data else { self.restThread.leave(); return }
                let decoder = JSONDecoder()
                guard let authTimeout = try? decoder.decode(StandardErrorMessage.self, from: data) else {
                    let invalidCredentials = try! decoder.decode(ValidationErrorMessage.self, from: data)
                    print(invalidCredentials);
                    //TODO: show invalidcreds error on UI
                    self.restThread.leave()
                    return
                }
                print(authTimeout)
                self.loggedIn = false
                self.restThread.leave()
                return
            }
        }
    }
    
    func getInvestorProducts() {
        
        self.restThread.enter()
        guard let url = URL(string: "/investorproducts", relativeTo: Constants.baseURL) else { self.restThread.leave(); return }

        rest.requestHttpHeaders.add(value: "Bearer " + self.authToken, forKey: "Authorization")
        rest.httpBodyParameters.clear()
        
        rest.makeRequest(toURL: url.absoluteURL, withHttpMethod: .get) { (results) in

            if let response = results.response {
                if response.httpStatusCode != 200 {
                    print("\nRequest failed with HTTP status code", response.httpStatusCode, "\n")
                    guard let data = results.data else { return }
                    let decoder = JSONDecoder()
                    guard let authTimeout = try? decoder.decode(StandardErrorMessage.self, from: data) else { return }
                    print(authTimeout)
                    self.loggedIn = false
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

