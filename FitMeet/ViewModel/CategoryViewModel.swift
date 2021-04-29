//
//  CategoryViewModel.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import Foundation
import Combine


class CategoryViewModel: ObservableObject {
    
    @Inject var fitMeetStream: FitMeetStream
    private var task: AnyCancellable?
    
    @Published var category: CategoryResponce = CategoryResponce(data: [Datum(createdAt: CreatedAt(rawValue: "2021-04-13T10:38:46.947Z"), id: 1, deleted: Deleted(rawValue: "NOT_DELETED"),title: "123"),Datum(createdAt: CreatedAt(rawValue: "2021-04-13T10:38:46.947Z"), id: 1, deleted: Deleted(rawValue: "NOT_DELETED"), title: "123")])
    
    func fetchBreweries() {
        task = fitMeetStream.getBroadcastCategory(category: CategoryRequest(order: "ASC", page: 1, take: 10)).mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.category = response
                    print(response)
            })
           }
         }
