//
//  ChanellListViewModel.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation
import Combine


class ChanellListViewModel: ObservableObject {
    
    @Inject var fitMeetChannel: FitMeetChannels
    private var task: AnyCancellable?
    
    @Published var channels: ChannelModel = ChannelModel(data: [ChannelResponce(statusCode: 1, message: ["1"], error: "", createdAt: "", id: 1, deleted: "", userID: 1, name: "", title: "", welcome5Description: "", backgroundURL: "", facebookLink: "", instagramLink: "", twitterLink: "", status: "", banReason: true, subscribersCount: 1, followersCount: 1, updatedAt: "")])
    
    func fetchBreweries() {
        task = fitMeetChannel.listChannels()
            .mapError({ (error) -> Error in
                      print(error)
                       return error })
                     .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    self.channels = response
                    print(response)
                })
             }
         
    func delete(ind: IndexSet) {
        print(ind)
       // task = fitMeetChannel
    }
}
