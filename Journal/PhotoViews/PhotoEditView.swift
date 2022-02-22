//
//  PhotoEditView.swift
//  Journal
//
//  Created by Tim Yoon on 2/21/22.
//

import SwiftUI
class PhotoEditViewModel: ObservableObject {
    @Published var title = ""
    @Published var uiImage : UIImage?
}
struct PhotoEditView: View {
    
    var body: some View {
        VStack{
            Text("Hello")
        }
        .navigationTitle("Choose Photo")
        .toolbar {
            ToolbarItem{
                Button {
                    
                } label: {
                    Text("Add Photo")
                }

            }
        }
    }
}

struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PhotoEditView()
        }
    }
}
