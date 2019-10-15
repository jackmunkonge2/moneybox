//
//  ViewController.swift
//  Moneybox
//
//  Created by Jack Munkonge on 14/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField! { didSet { email.delegate = self } }
    
    @IBOutlet weak var password: UITextField! { didSet { password.delegate = self } }
    
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
        }
    }
    
    let rest = RestManager()
    
    func attemptLogin(withEmail email: String!, withPassword password: String!) {
        guard let url = URL(string: "https://api-test01.moneyboxapp.com/users/login") else { return }
     
        rest.requestHttpHeaders.add(value: "3a97b932a9d449c981b595", forKey: "Appid")
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.requestHttpHeaders.add(value: "5.10.0", forKey: "appVersion")
        rest.requestHttpHeaders.add(value: "3.0.0", forKey: "apiVersion")
        
        rest.httpBodyParameters.add(value: email, forKey: "Email")
        rest.httpBodyParameters.add(value: password, forKey: "Password")
        rest.httpBodyParameters.add(value: "ANYTHING", forKey: "Idfa")
     
        rest.makeRequest(toURL: url, withHttpMethod: .post) { (results) in
            guard let response = results.response else { return }
            if response.httpStatusCode == 200 {
                guard let data = results.data else { return }
                let decoder = JSONDecoder()
                guard let loginSuccess = try? decoder.decode(LoginSuccess.self, from: data) else { return }
                print(loginSuccess)
                //TODO: use/store bearer token
            } else {
                guard let data = results.data else { return }
                let decoder = JSONDecoder()
                guard let noAuthorization = try? decoder.decode(NoAuthorization.self, from: data) else {
                    let invalidCredentials = try! decoder.decode(InvalidCredentials.self, from: data)
                    print(invalidCredentials);
                    //TODO: show invalidcreds error
                    return
                }
                print(noAuthorization)
                //TODO: show no auth error
            }
        }
    }
    
//    func getUsersList() {
//        guard let url = URL(string: "https://reqres.in/api/users") else { return }
//
//        // The following will make RestManager create the following URL:
//        // https://reqres.in/api/users?page=2
//        // rest.urlQueryParameters.add(value: "2", forKey: "page")
//
//        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
//            print("\n\nResponse HTTP Headers:\n")
//
//            if let response = results.response {
//                if response.httpStatusCode != 200 {
//                    print("\nRequest failed with HTTP status code", response.httpStatusCode, "\n")
//                    return
//                }
//
//                for (key, value) in response.headers.allValues() {
//                   print(key, value)
//                }
//            }
//
//            print("\n\nData:\n")
//
//            if let data = results.data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                guard let userData = try? decoder.decode(LoginSuccess.self, from: data) else { return }
//                print(userData.description)
//            }
//
//
//        }
//    }
//
//    func getSingleUser() {
//        guard let url = URL(string: "https://reqres.in/api/users/1") else { return }
//
//        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
//            if let data = results.data {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                guard let singleUserData = try? decoder.decode(LoginSuccess.self, from: data),
//                    let user = singleUserData.data,
//                    let avatar = user.avatar,
//                    let url = URL(string: avatar) else { return }
//
//                self.rest.getData(fromURL: url, completion: { (avatarData) in
//                    guard let avatarData = avatarData else { return }
//                    let desktopDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0]
//                    let saveURL = desktopDirectory.appendingPathComponent("avatar.jpg")
//                    try? avatarData.write(to: saveURL)
//                    print("\nSaved Avatar URL:\n\(saveURL)\n")
//                })
//
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        email.layer.borderWidth = 0
        password.layer.borderWidth = 0
    }
}

