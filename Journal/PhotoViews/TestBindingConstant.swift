//
//  TestBindingConstant.swift
//  Journal
//
//  Created by Tim Yoon on 2/22/22.
//

import SwiftUI
struct Num : Identifiable {
    var id = UUID()
    var n = 0
}
struct TestBindingConstant: View {
    @Binding var list : [Num]
    var body: some View {
        VStack{
            ForEach(list){ number in
                Text("\(number.n)")
            }
            Button {
                list.append(Num(n: Int.random(in: 0...10)))
            } label: {
                Text("add")
            }
        }
    }
}
struct TestBindingPreviewContainer: View {
    @State var list = [Num(n: 2), Num(n: 6)]
    var body: some View {
        TestBindingConstant(list: $list)
    }
}
struct TestBindingConstant_Previews: PreviewProvider {
    static var previews: some View {
        TestBindingPreviewContainer()
    }
}
