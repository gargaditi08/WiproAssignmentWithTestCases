//
//  TableListServiceTests.swift
//  TelstraAssignmentTests
//
//  Created by Aditi Garg on 20/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import XCTest
@testable import TelstraAssignment

class TableListServiceTests: XCTestCase {
    let networkClient = NetworkClient()
    override func setUp() {
        super.setUp()
    }
    
    func testGetApiResult() {
        let session = URLSession.shared
        guard let url = URL(string: "http://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json") else { return }
        let request = URLRequest(url: url)
        self.networkClient.loadRequest(request) { (data, response , error)  in
            guard let responseData = data else {return }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                XCTAssertNoThrow(try JSONDecoder().decode(CanadaUpdates.self, from: jsonData as! Data))
            } catch let error {
                print(error.localizedDescription)
            }
            self.measure {
                let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                    guard error == nil else {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print("response JSON = \(json)")
                        }
                    } catch let error {
                         print(error.localizedDescription)
                    }
                })
                task.resume()
                self.waitForExpectations(timeout: 10) {(error) in
                    if let error = error {
                        XCTFail("Error:\(error.localizedDescription)")
                    }
                    
                }
            }
            
        }}
    
    
    
}

