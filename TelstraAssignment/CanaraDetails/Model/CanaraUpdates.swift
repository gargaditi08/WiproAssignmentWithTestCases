//
//  CanaraUpdates.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import UIKit

//BO object
struct CanadaUpdates : Codable {
    var title : String?
    var rows : [Rows]
}

struct Rows : Codable {
   var title : String?
   var description : String?
   var imageHref : String?
}
