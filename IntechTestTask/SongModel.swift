//
//  SongModel.swift
//  IntechTestTask
//
//  Created by Petrovichev on 16/09/16.
//  Copyright © 2016 Petrovichev. All rights reserved.
//
import UIKit

public enum ImageDownloadingStatus {
    case notLoaded
    case loadingInProgress
    case loaded
}

public struct SongModel {
    var artistName = ""
    var trackName = ""
    var artworkUrl60 = ""
    var artworkUrl100 = ""
    var smallImageObject: (UIImage?, ImageDownloadingStatus)
    var bigImage: UIImage?
}