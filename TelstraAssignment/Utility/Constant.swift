//
//  Constant.swift
//  TelstraAssignment
//
//  Created by Aditi Garg on 15/04/20.
//  Copyright © 2020 Aditi Garg. All rights reserved.
//

import Foundation
import UIKit



struct apiForCanaraDetails {
    static let BaseUrl = "http://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}
open class Utils : NSObject {
    internal static let shared = Utils()
    static let placeholderImg : UIImage = UIImage(named: "downloadImg")!
    
}

