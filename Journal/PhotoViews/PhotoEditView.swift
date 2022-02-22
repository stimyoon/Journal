//
//  PhotoEditView.swift
//  Journal
//
//  Created by Tim Yoon on 2/21/22.
//

import SwiftUI
import AVFAudio
class PhotoEditViewModel: ObservableObject {
    @Published var title = ""
    @Published var uiImage : UIImage?
}
struct PhotoEditView: View {
    @State var photo = Photo()
    @State var isShowingSheet = false
    
    var body: some View {
        VStack{
            TextField("title", text: $photo.title)
            if let uiImage = photo.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                Image(systemName: "photo")
            }
        }
        .sheet(isPresented: $isShowingSheet, onDismiss: nil) {
            ImagePicker(uiImage: $photo.uiImage)
        }
        .navigationTitle("Choose Photo")
        .toolbar {
            ToolbarItem{
                Button {
                    isShowingSheet = true
                } label: {
                    Text("Image Picker")
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
