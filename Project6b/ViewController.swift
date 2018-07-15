//
//  ViewController.swift
//  Project6b
//
//  Created by Ora Martindale on 7/11/18.
//  Copyright © 2018 Ora Martindale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label1 = createLabel(color: UIColor.red, text: "THESE")
        let label2 = createLabel(color: UIColor.cyan, text: "ARE")
        let label3 = createLabel(color: UIColor.yellow, text: "SOME")
        let label4 = createLabel(color: UIColor.green, text: "AWESOME")
        let label5 = createLabel(color: UIColor.orange, text: "LABELS")
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        let viewsDictionary = [
            "label1": label1,
            "label2": label2,
            "label3": label3,
            "label4": label4,
            "label5": label5
        ]

        var previous: UILabel?
        for label in [label1, label2, label3, label4, label5] {
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            }
            previous = label
        }
    }

    func createLabel(color: UIColor, text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = color
        label.text = text
        return label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

