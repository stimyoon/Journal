//
//  ItemEditView.swift
//  Journal
//
//  Created by Tim Yoon on 2/14/22.
//

import SwiftUI

struct ItemEditView: View {
    @Environment(\.dismiss) var dismiss
    let item : Item
    var completion: ()->Void
    @State private var text: String = ""
    @State private var title: String = ""
    
    var body: some View {
        Form{
            TextField("title", text: $title)
            TextField("text", text: $text)
            Button {
                completion()
                dismiss()
            } label: {
                Text("Save")
            }

        }
    }
}

//struct ItemEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemEditView()
//    }
//}
