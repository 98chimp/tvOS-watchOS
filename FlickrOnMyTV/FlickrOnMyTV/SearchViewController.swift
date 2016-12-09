//
//  SearchViewController.swift
//  FlickrOnMyTV
//
//  Created by Daniel Mathews on 2015-12-08.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBAction func flickrButtonPressed(_ sender: AnyObject) {
        
        let resultsViewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let searchViewController = UISearchController(searchResultsController: resultsViewController)
        searchViewController.searchResultsUpdater = resultsViewController
        present(searchViewController, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    

}
