//
//  MemeTableViewController.swift
//  MemeMe_v1.0
//
//  Created by Dhara Bhavsar on 2021-09-14.
//  Copyright © 2021 Dhara Bhavsar. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {

    // MARK: Properties
    // Get ahold of shared model data memes array
    var memes : [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    
    // MARK: lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44;
        tableView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView!.reloadData()
    }

    
    
    // MARK: Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText + " " + meme.bottomText
        cell.imageView?.image = meme.memedImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }

    
    // MARK: IBActions
    @IBAction func createMeme(_ sender: Any) {
        print("Create Meme")
    }
        
}
