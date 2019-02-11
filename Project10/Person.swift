//
//  Person.swift
//  Project10
//
//  Created by Ora Martindale on 2/10/19.
//  Copyright © 2019 Ora Martindale. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
