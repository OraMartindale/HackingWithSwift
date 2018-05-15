//
//  ViewController.swift
//  Project2
//
//  Created by Ora Martindale on 5/15/18.
//  Copyright © 2018 Ora Martindale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    let countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for button in [button1, button2, button3] {
            button!.layer.borderWidth = 1
            button!.layer.borderColor = UIColor.lightGray.cgColor
        }
        
        askQuestion()
    }
    
    func askQuestion() {
        for (i, button) in [button1, button2, button3].enumerated() {
            button!.setImage(UIImage(named: countries[i]), for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

