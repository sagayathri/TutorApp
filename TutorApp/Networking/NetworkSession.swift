//
//  FetchAddress.swift
//  TutorApp
//

import Foundation

class NetworkSession {
    
    //MARK:- Creates a shared instance for NetworkSession class
    static let sharedInstance = NetworkSession()
    var sessionDelegate: NetworkSessionDelegate? = nil
    let constant = Constant.shared
    let checkInternet = CheckInternet()
    let toast = Toast()
    var getAddress: GetAddress? = nil
    
    var statusCode = 0
    var addresses: [String] = []
    
    func fetchHouseFromAPI(postcode: String) {
        let escapedPostcode = postcode.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let urlString = constant.GetAddressURL+String(describing: escapedPostcode!)+"?api-key=\(constant.GetAddress_ApiKey)"
        //MARK:- Create the url with NSURL
        let url = URL(string: urlString)
        //MARK:- Create a Request object using the url object
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        if checkInternet.Connection() {
            let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                guard let data = data, error == nil else {
                    return
                }
                
                //MARK:- Gets status code
                if let httpResponse = response as? HTTPURLResponse {
                    self.statusCode = httpResponse.statusCode
                }
                
                do {
                    if self.statusCode == 200 {
                        self.getAddress = try JSONDecoder().decode(GetAddress.self, from: data)
                        self.addresses = self.getAddress!.addresses
                        self.loadMessages()
                    }
                    else if self.statusCode == 400 {
                        DispatchQueue.main.async {
                            self.toast.displayToastMessage("Your postcode is not valid")
                        }
                    }
                    else if self.statusCode == 401 {
                        DispatchQueue.main.async {
                            self.toast.displayToastMessage("Your api-key is not valid")
                        }
                    }
                    else if self.statusCode == 404 {
                        DispatchQueue.main.async {
                            self.toast.displayToastMessage("No addresses could be found for this postcode")
                        }
                    }
                    else if self.statusCode == 429 {
                        DispatchQueue.main.async {
                            self.toast.displayToastMessage("You have made more requests than your allowed limit")
                        }
                    }
                    else if self.statusCode == 500 {
                        DispatchQueue.main.async {
                            self.toast.displayToastMessage("Server error, you should never see this")
                        }
                    }
                }
                catch {
                    print("Failed to parse JSON from URL")
                }
            })
            task.resume()
        }
        else {
            toast.displayToastMessage("No or poor internet connection")
        }
    }
    
    //MARK:- Populates the app UI with the fetched addresses
    func loadMessages() {
        DispatchQueue.main.async {
            self.sessionDelegate?.loadAddress(addresses: self.addresses)
        }
    }
}
