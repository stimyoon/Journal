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
    @Environment(\.dismiss) var dismiss
    var completion: (Photo)->()
    @State var photo : Photo
    @State var isShowingSheet = false
    
    var body: some View {
        VStack{
            TextField("title", text: $photo.title)
                .textFieldStyle(.roundedBorder)
                .padding()
            if let uiImage = photo.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .onTapGesture {
                        isShowingSheet = true
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .onTapGesture {
                        isShowingSheet = true
                    }
            }
            Button {
                completion(photo)
                dismiss()
            } label: {
                Text("Save")
            }
            .buttonStyle(.bordered)
            .padding()
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
    init(photo: Photo, completion: @escaping (Photo)->Void) {
        _photo = State(initialValue: photo)
        self.completion = completion
    }
}

struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PhotoEditView(photo: Photo()) { photo in
                print("photot title: \(photo.title)")
            }
        }
    }
}
