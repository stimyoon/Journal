//
//  ViewExtensions.swift
//  Journal
//
//  Created by Tim Yoon on 2/15/22.
//

import SwiftUI

extension View {
    func pushOut() -> some View {
        ZStack{
            Color.clear
            self
        }
    }
    func centerHorizontally() -> some View {
        HStack{
            Spacer()
            self
            Spacer()
        }
    }
    func test() {
        print("test")
    }
}
