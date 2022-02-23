//
//  PhotoListView.swift
//  Journal
//
//  Created by Tim Yoon on 2/21/22.
//

import SwiftUI

struct PhotoListView: View {
    @Binding var photos : [Photo]
    var body: some View {
        ScrollView {
            VStack{
                ForEach( photos ) { photo in
                    VStack{
                        Text(photo.title)
                        if let image = photo.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: 300, maxHeight: 300)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .frame(maxWidth: 300, maxHeight: 300)
                        }
                    }
                    .background(content: {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke()
                            .foregroundColor(Color.secondary)
                    })
                    .padding(.bottom)
                }
                .onDelete { offsets in
                    guard let index = offsets.first else { return }
                    photos.remove(at: index)
                }
            }
           
        }
        .navigationBarTitle("Photo List")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                EditButton()
            }
            ToolbarItem {
                NavigationLink {
                    PhotoEditView(photo: Photo()) { photo in
                        print("\(photo.title)")
                        photos.append(photo)
                    }
                } label: {
                    Text("Add Photo")
                }

            }
        }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PhotoListView(photos: .constant(Photo.mockData))
        }
    }
}
