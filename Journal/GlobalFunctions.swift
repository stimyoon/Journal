//
//  GlobalFunctions.swift
//  RadPacs
//
//  Created by Tim Yoon on 1/20/22.
//

import Foundation
#if os(macOS)
import AppKit

func getPasteboardImage() -> NSImage?
{
    let pb = NSPasteboard.general
    let type = NSPasteboard.PasteboardType.tiff
    guard let imgData = pb.data(forType: type) else { return nil }
   
    return NSImage(data: imgData)
}
#else
import UIKit

func getPasteboardImage() -> UIImage? {
    let pb = UIPasteboard.general
    return pb.image
}
#endif
