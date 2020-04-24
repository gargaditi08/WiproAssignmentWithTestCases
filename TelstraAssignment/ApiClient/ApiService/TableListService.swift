//
//  TableListService.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import UIKit

class TableListService : NSObject {
    var reachability : Reachability? = Reachability.networkReachabilityForInternetConnection()
    private let refreshControl = UIRefreshControl()
    var networkClient  =  NetworkClient()
    
    func getDataList(requestCompletion : @escaping (_ object: CanadaUpdates?,_ error: String?)->()) {
        if (reachability?.isReachable == false){
            requestCompletion(nil, "No internet Available")
            return
        }
        else{
            let urlString = apiForCanaraDetails.BaseUrl
            guard let url = URL(string: urlString) else {
                requestCompletion(nil, "Invalid URL")
                return
            }
            let request = URLRequest(url:url)
            self.networkClient.loadRequest(request) { data, response, error in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    requestCompletion(nil, "Internet Connection Error")
                    return
                }
                if httpResponse.statusCode == 200{
                    guard let responseData = data else {
                        requestCompletion(nil, "No Data Available")
                        return
                    }
                    do {
                        guard let utf8Data = String (decoding : responseData, as: UTF8.self).data(using: .utf8) else {
                            requestCompletion(nil, "Encoding issue occured")
                            return
                        }
                        let jsonData = try JSONSerialization.jsonObject(with: utf8Data, options: .mutableContainers)
                        print("API Response : \(jsonData)")
                        let modeledResponse = try JSONDecoder().decode(CanadaUpdates.self, from: utf8Data)
                        requestCompletion(modeledResponse,nil)
                    }catch {
                        print(error)
                    }
                }
            }
        }
    }
}

