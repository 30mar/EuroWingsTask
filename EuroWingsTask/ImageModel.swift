//
//  ImageModel.swift
//  EuroWingsTask
//
//  Created by Omar Abdelaziz on 1/12/19.
//  Copyright © 2019 Omar Abdelaziz. All rights reserved.
//

import Foundation
import UIKit
struct ImageModel{
    var id: String
    var title: String
    var link: String
    var downloadedImage: UIImage?
    init(id:String, title:String,link:String){
        self.id = id
        self.title = title
        self.link = link
    }
}
