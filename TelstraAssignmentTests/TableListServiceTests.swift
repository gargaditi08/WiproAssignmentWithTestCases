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

    func testGetApiResult() throws{
        guard let url = URL(string: "http://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json") else { return }
        
        let request = URLRequest(url: url)
        self.networkClient.loadRequest(request) { (data, response , error)  in
            guard let responseData = data else {return }
            do {
                let jsonData = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.mutableContainers)
                XCTAssertNoThrow(try JSONDecoder().decode(CanadaUpdates.self, from: jsonData as! Data))
                
            } catch
            {
            }
        }
        
    }
}




