//
//  UpdatesViewModel.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import UIKit

final class UpdatesViewModel {
    var canadaUpdate : CanadaUpdates?{
        didSet{
            self.reloadData?()
            self.passNavTitle?()
        }
    }
    var listService: TableListService = TableListService()
    var errorOccured: ((_ message: String)->())?
    var reloadData: (()->())?
    var passNavTitle: (() ->())?
    
    init()  {
    }
    
    func getUpdateList(){
        self.listService.getDataList{ (result, error) in
            if let canadaData = result {
                self.canadaUpdate = canadaData
            }else if let errorMessage = error{
                self.errorOccured?(errorMessage)
            }
        }
    }
    var titleNavbar : String?{
        if let titleMain = self.canadaUpdate{
            return titleMain.title
        }
        else {
            return "Canara Detail"
        }
    }
    
    var noOfRows : Int {
        guard let object = self.canadaUpdate else {return 0 }
        return object.rows.count
    }
    
    func updateAtIndex(index:Int) -> Rows? {
        guard let content = self.canadaUpdate else {return nil}
        return content.rows[index]
    }
}


