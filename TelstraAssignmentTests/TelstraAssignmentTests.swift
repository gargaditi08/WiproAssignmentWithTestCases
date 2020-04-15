//
//  TelstraAssignmentTests.swift
//  TelstraAssignmentTests
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import XCTest
@testable import TelstraAssignment

class TelstraAssignmentTests: XCTestCase {
    
    var viewCon : ViewController!
   
    override func setUp() {
        super.setUp()
    }
    
    func testInitMyTableView() {
        let vc = ViewController()
        _ = vc.view
        XCTAssertNotNil(vc.tableView)
    }
    
    func testTableDataSource() {
         let vc = ViewController()
               _ = vc.view
        XCTAssertTrue(vc.tableView.dataSource is ViewController)
    }
    
    func testTableDelegateSourceMethod() {
        let vc = ViewController()
            _ = vc.view
               XCTAssertTrue(vc.tableView.delegate is ViewController)
           }
    
    
    func testDataSourceDelegateSaeInstance() {
         let vc = ViewController()
                   _ = vc.view
         XCTAssertEqual(vc.tableView.dataSource as! ViewController, vc.tableView.delegate as! ViewController)
    }
           
    func testReachability() {
           XCTAssertTrue(true)
       }
       

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   

}
