//
//  DetailsViewController.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 24/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var navTitle: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navTitle
    }
}
