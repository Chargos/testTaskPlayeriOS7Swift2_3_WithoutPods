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
    var artistName: String
    var trackName: String
    var artworkUrl60: String
    var artworkUrl100: String
    var smallImageObject: (UIImage?, ImageDownloadingStatus)
    var bigImage: UIImage?
}