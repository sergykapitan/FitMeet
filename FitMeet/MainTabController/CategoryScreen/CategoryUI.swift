//
//  CategoryUI.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import SwiftUI

struct CategoryUI: View {
    @ObservedObject var viewModel = CategoryViewModel()
    
        var body: some View {
            NavigationView {
               // guard let data = viewModel.category?.data else { return }
                List((viewModel.category.data)! ,id: \.self) {
                    CategoryCell(cell: $0)
                }.navigationBarTitle("Category")
                .onAppear {
                           self.viewModel.fetchBreweries()
                   }
            }
        }
}
struct CategoryCell: View {
    var cell: Datum
    var body: some View {
                HStack{
                    Text("\(cell.title ?? "123")")
                    Spacer()
                    Button(action: {print("777777") }) { Image("Like")}.accentColor(.red)
                    Button(action: { print("8888888")}) { Image("More")}.accentColor(.red)
                        .padding(.trailing,20)
                }
              }
           }
struct CategoryUI_Previews: PreviewProvider {
    static var previews: some View {
        CategoryUI()
    }
}
