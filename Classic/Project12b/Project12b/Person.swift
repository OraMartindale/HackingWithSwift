//
//  Person.swift
//  Project12b
//
//  Created by Ora Martindale on 2019-03-03.
//  Copyright © 2019 Ora Martindale. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
