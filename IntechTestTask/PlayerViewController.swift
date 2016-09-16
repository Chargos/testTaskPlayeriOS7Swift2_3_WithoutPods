//
//  PlayerViewController.swift
//  IntechTestTask
//
//  Created by Petrovichev on 15/09/16.
//  Copyright © 2016 Petrovichev. All rights reserved.
//

import UIKit
import Foundation

class PlayerViewController: UIViewController {
    
    private let playText = "Play"
    private let pauseText = "Pause"
    private var isPlayText = true {
        didSet {
            playPauseButton.setTitle(isPlayText ? playText : pauseText, forState: .Normal)
        }
    }
    
    @IBOutlet private weak var artistImage: UIImageView!
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var songTitleLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    var song: SongModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let song = song {
            isPlayText = true
            artistNameLabel.text = song.artistName
            songTitleLabel.text = song.trackName
            setArtistImage(song: song)
        }
        
    }
    
    @IBAction func playerButtonPressed(sender: AnyObject) {
        isPlayText = !isPlayText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setArtistImage(song song:SongModel) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if let url = NSURL(string: song.artworkUrl100) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let data = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    if let data = data, image = UIImage(data: data) {
                        self?.artistImage.image = image
                    }
                })
            }
        }
    }
    
}