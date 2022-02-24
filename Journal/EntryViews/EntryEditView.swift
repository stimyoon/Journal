//
//  EntryEditView.swift
//  Journal
//
//  Created by Tim Yoon on 2/20/22.
//

import SwiftUI

struct EntryEditView : View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm : EntryListVM
    
    @State var entry : Entry
    @State var photoTitle = ""
    var completion: (Entry)->()
    
    var body: some View {
        VStack{
            List{
                HStack{
                    Spacer()
                    DatePicker("Date", selection: $entry.timestamp)
                }
                TextField("title", text: $entry.title)
                    .textFieldStyle(.roundedBorder)
                    .font(.title3.weight(.semibold))
                Section(header: Text("Note")){
                    TextEditor(text: $entry.note)
                        .lineLimit(nil)
//                        .frame(maxHeight: 300)
                        .border(.tertiary)
                }

                Section(header: Text("Photos")) {
                    PhotoListView(photos: $entry.photos)
                }
            }
            Button {
                completion(entry)
                dismiss()
            } label: {
                Text("Save").centerHorizontally()
            }
            .buttonStyle(.bordered)
            .padding()
            .navigationBarTitle("Entry Edit View")
        }
    }
}

struct EntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EntryEditView(vm: EntryListVM(dataService: MockEntryDataService()), entry: Entry.mockEntryData) { _ in
                print("completion is executed")
            }
        }
    }
}
