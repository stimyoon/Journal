//
//  Photo.swift
//  Journal
//
//  Created by Tim Yoon on 2/16/22.
//

import SwiftUI

struct Photo : Identifiable {
    var id: String = UUID().uuidString
    var timestamp : Date = Date()
    var uiImage : UIImage?
    var image : Image? {
        guard let uiImage = self.uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
}

