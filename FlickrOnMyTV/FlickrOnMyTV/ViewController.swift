//
//  ViewController.swift
//  FlickrOnMyTV
//
//  Created by Daniel Mathews on 2015-12-08.
//  Copyright © 2015 Daniel Mathews. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UISearchResultsUpdating, UICollectionViewDelegate {

    var posts = [FlickrImage]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var filterString = "cat"
        
    func getFlickData(_ searchTerm:String){
        
        let task = URLSession.shared.dataTask(with: URL(string: "https://www.flickr.com/services/rest/?method=flickr.photos.search&format=json&safe_search=3&nojsoncallback=1&api_key=e33dc5502147cf3fd3515aa44224783f&tags=\(searchTerm)")!, completionHandler: { (data, response, error) -> Void in
            
            if let jsonUnformatted = try? JSONSerialization.jsonObject(with: data!, options: []),
                let json = jsonUnformatted as? [String : AnyObject],
                let photosDictionary = json["photos"] as? [String : AnyObject],
                let photosArray = photosDictionary["photo"] as? [[String : AnyObject]]
            {
                
                for photo in photosArray {
                    
                    if let farmID = photo["farm"] as? Int,
                        let serverID = photo["server"] as? String,
                        let photoID = photo["id"] as? String,
                        let secret = photo["secret"] as? String {
                            
                            let photoURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(photoID)_\(secret).jpg"
                            if let photoURL = URL(string: photoURLString){
                                let post = FlickrImage(imageURL:photoURL)
                                self.posts.append(post)
                            }
                    }
                    
                }
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.collectionView.reloadData()
                })
                
            }else{
                print("error with response data")
            }
            
        }) 
        
        task.resume()

        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterString = searchController.searchBar.text ?? ""
        getFlickData(filterString)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flickrCell", for: indexPath) as! FlickrCollectionViewCell
        let post = posts[indexPath.item]

        cell.imageView.image = nil
        
        if (cell.downloadTask != nil) {
            cell.downloadTask.suspend()
            cell.downloadTask.cancel()
        }
        
        cell.downloadTask = URLSession.shared.downloadTask(with: post.imageURL, completionHandler: { (url, response, error) -> Void in
                
                if let imageURL = url,
                    let imageData = try? Data(contentsOf: imageURL){
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            cell.imageView.adjustsImageWhenAncestorFocused = true
                            cell.imageView.image = UIImage(data: imageData)
                            
                        })
                }
            }) 
        
        cell.downloadTask.resume()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

