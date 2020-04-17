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
    var viewCon : HomeViewController!
    override func setUp() {
        super.setUp()
    }
    
    func testInitMyTableView() {
        let vc = HomeViewController()
        _ = vc.view
        XCTAssertNotNil(vc.tableView)
    }
    
    func testTableDataSource() {
         let vc = HomeViewController()
               _ = vc.view
        XCTAssertTrue(vc.tableView.dataSource is HomeViewController)
    }
    
    func testTableDelegateSourceMethod() {
        let vc = HomeViewController()
            _ = vc.view
               XCTAssertTrue(vc.tableView.delegate is HomeViewController)
           }
    
    
    func testDataSourceDelegateSaeInstance() {
         let vc = HomeViewController()
                   _ = vc.view
         XCTAssertEqual(vc.tableView.dataSource as! HomeViewController, vc.tableView.delegate as! HomeViewController)
    }
           
    func testReachability() {
           XCTAssertTrue(true)
       }
       

   

}
