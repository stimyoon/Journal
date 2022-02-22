//
//  PhotoListView.swift
//  Journal
//
//  Created by Tim Yoon on 2/21/22.
//

import SwiftUI

struct PhotoListView: View {
    let photos : [Photo]
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
            }
        }
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoListView(photos: Photo.mockData)
    }
}
