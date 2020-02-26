//
//  ViewController.swift
//  IntechTestTask
//
//  Created by Petrovichev on 15/09/16.
//  Copyright © 2016 Petrovichev. All rights reserved.
//

import UIKit

class SongsListViewController: UIViewController {
    
    private let serverURL = NSURL(string: "https://itunes.apple.com/search?")!
    private let meaningfulCharCount = 5
    
    @IBOutlet weak var tableView: UITableView!
    private var songs = [SongModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? PlayerViewController, cell = sender as? UITableViewCell, indexPath = self.tableView.indexPathForCell(cell) where songs.count > indexPath.row {
            vc.song = songs[indexPath.row]
        }
    }
    
    func loadSongs(searchText searchText:String) {
        let request = NSMutableURLRequest(URL: serverURL)
        request.HTTPMethod = "POST"
        request.HTTPBody = ("term=" + searchText).dataUsingEncoding(NSUTF8StringEncoding)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard let data = data where error == nil else { return }
            let json = JSON(data: data)
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.songs = []
                if let results = json["results"].array {
                    results.forEach { song in
                        self.songs.append(SongModel(artistName: song["artistName"].string ?? "", trackName: song["trackName"].string ?? "", artworkUrl60: song["artworkUrl60"].string ?? "", artworkUrl100: song["artworkUrl100"].string ?? "", smallImageObject: (nil, .notLoaded), bigImage: nil))
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        task.resume()
    }
    
}

extension SongsListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SongTableViewCell", forIndexPath: indexPath) as! SongTableViewCell
        cell.songTitle?.text = songs[indexPath.row].trackName
        cell.artistName?.text = songs[indexPath.row].artistName
        cell.songImage?.image = songs[indexPath.row].smallImageObject.0
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? SongTableViewCell, url = NSURL(string: songs[indexPath.row].artworkUrl60) where songs[indexPath.row].smallImageObject.1 == ImageDownloadingStatus.notLoaded {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                self.songs[indexPath.row].smallImageObject.1 = .loadingInProgress
                let data = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue(), {
                    if let data = data, image = UIImage(data: data) where self.songs.count > indexPath.row && NSURL(string: self.songs[indexPath.row].artworkUrl60) == url {
                        self.songs[indexPath.row].smallImageObject = (image, .loaded)
                        cell.songImage?.image = image
                    }
                })
            }
        }
    }
    
}

extension SongsListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        view.endEditing(true)
    }
    
}

extension SongsListViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count >= meaningfulCharCount {
            loadSongs(searchText: searchText)
        }
    }
    
}