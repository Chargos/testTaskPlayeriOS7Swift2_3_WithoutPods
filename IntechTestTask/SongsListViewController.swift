//
//  ViewController.swift
//  IntechTestTask
//
//  Created by Petrovichev on 15/09/16.
//  Copyright © 2016 Petrovichev. All rights reserved.
//

import UIKit
//itunes.apple.com/search?term=SEARCH_KEYWORD),

class SongsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var songs = [SongModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionHeaderHeight = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    

}

extension SongsListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = songs[indexPath.row].trackName
        cell.detailTextLabel?.text = songs[indexPath.row].artistName
        cell.imageView?.image = songs[indexPath.row].image
        return cell
    }
    
}

extension SongsListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showPlayerViewController", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
}

struct SongModel {
    var artistName = ""
    var trackName = ""
    var artworkUrl60 = ""
    var artworkUrl100 = ""
    var image: UIImage?
}

extension SongsListViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= 5 {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://itunes.apple.com/search?")!)
            request.HTTPMethod = "POST"
            let postString = "term=" + searchText
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                }
                
                let json = JSON(data: data!)
                if let userName = json["results"][0]["artistName"].string {
                    
                    print(userName)
                    //Now you got your value
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.songs = []
                    if let results = json["results"].array {
                        results.forEach { song in
                            
                            let url = NSURL(string: song["artworkUrl60"].string ?? "")
                            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                            
                            self.songs.append(SongModel(artistName: song["artistName"].string ?? "", trackName: song["trackName"].string ?? "", artworkUrl60: song["artworkUrl60"].string ?? "", artworkUrl100: song["artworkUrl100"].string ?? "", image: UIImage(data: data ?? NSData())))
                        }
                    }
                
                    self.tableView.reloadData()
                }
                
            }
            task.resume()
        }
    }
    
    
    
}