//
//  MemeDetailViewController.swift
//  MemeMe_v1.0
//
//  Created by Dhara Bhavsar on 2021-10-10.
//  Copyright © 2021 Dhara Bhavsar. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {

    // MARK: Properties
    var meme: Meme!
    
    
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hiding the tabBar
        self.tabBarController?.tabBar.isHidden = true
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // showing the tabBar
        self.tabBarController?.tabBar.isHidden = false
    }
}
