//
//  PageModel.swift
//  Zoomer
//
//  Created by Muhammad Ahmad on 22/09/2022.
//

import Foundation

struct Page : Identifiable {
    var id: Int
    var imageName: String
}

extension Page{
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
