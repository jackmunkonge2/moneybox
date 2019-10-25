//
//  RestService.swift
//  Moneybox
//
//  Created by Jack Munkonge on 14/10/2019.
//  Copyright © 2019 Organisation. All rights reserved.
//

import Foundation

class RestService {
    
    var httpBody: Data?
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntity()
    

    func makeRequest(toURL url: URL,
                     withHttpMethod httpMethod: HttpRequestType,
                     completion: @escaping (_ result: HttpResults) -> Void) {
     
        let targetURL = self.addURLQueryParameters(toURL: url)
        let httpBody = self.getHttpBody()
        guard let request = self.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
            completion(HttpResults(withError: CustomError.failedToCreateRequest))
            return
        }

        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(HttpResults(withData: data,
                               response: HttpResponse(fromURLResponse: response),
                               error: error))
        }
        task.resume()
    }
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            
            var queryItems = [URLQueryItem]()
            
            for (key, value) in urlQueryParameters.allValues() {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
             
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
    
        return url
    }
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
     
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpRequestType) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
     
        for (header, value) in requestHttpHeaders.allValues() {
            request.setValue(value, forHTTPHeaderField: header)
        }
        if httpMethod == .get {
            request.httpBody = Data()
            return request
        }
        request.httpBody = httpBody
        return request
    }
}



