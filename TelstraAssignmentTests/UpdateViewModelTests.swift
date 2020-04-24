//
//  UpdateViewModelTests.swift
//  TelstraAssignmentTests
//
//  Created by Aditi Garg on 20/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import XCTest
@testable import TelstraAssignment

class UpdateViewModelTests: XCTestCase {
    var listService = TableListService()
    var canadaUpdates: CanadaUpdates?
    override func setUp() {
        super.setUp()
        
    }
    func testGetUpdateList() {
        listService.getDataList(requestCompletion: {( result, error) in
            if let canadaData = result
            {
                XCTAssertNotNil(canadaData)
            }
        })
    }
    func testTitleOfTableData() {
        if let titleMain = self.canadaUpdates {
            XCTAssertTrue(titleMain.title! == "About Canada")
        }
    }
    func testUpdateTableCellForRow() {
        if let rowsValue = self.canadaUpdates {
            XCTAssertNotNil(rowsValue.rows)
        }
    }
}
