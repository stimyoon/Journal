//
//  EntryCellView.swift
//  Journal
//
//  Created by Tim Yoon on 2/20/22.
//

import SwiftUI



struct EntryCellView: View {
    let entry : Entry
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(entry.title).font(.title3)
                Spacer()
                Text(dateString(date: entry.timestamp))
                    .font(.caption)
            }
            .padding(.bottom, 4)
            if let attributedString = try? AttributedString(markdown: entry.note ) {
                Text(attributedString)
                    .lineLimit(3)
            } else {
                Text(entry.note)
                    .lineLimit(3)
            }
            VStack{
                ForEach(entry.photos) {
                    Text($0.title)
                }
            }
        }
    }
    func dateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

}


//struct EntryCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        EntryCellView()
//    }
//}
