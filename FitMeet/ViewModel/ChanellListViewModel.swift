//
//  ChanellListViewModel.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation
import Combine


class ChanellListViewModel: ObservableObject {
    
    @Inject var fitMeetStrem: FitMeetStream
    private var task: AnyCancellable?
    
    @Published var broadcast: BroadcastResponce? = nil
    @Published var idBroadcast: Int = 0
    
    func fetchBreweries() {
        let chanellId = UserDefaults.standard.string(forKey: Constants.chanellID)
        let userName =  UserDefaults.standard.string(forKey: Constants.userFullName)
        guard let id = chanellId else {return }
        let idInt = Int(id)
        task = fitMeetStrem.createBroadcas(broadcast:BroadcastRequest(channelID: idInt, name: userName, type: "STANDARD", access: "ALL", hasChat: true, isPlanned: true, onlyForSponsors: false, onlyForSubscribers: false,categoryIDS: [1], scheduledStartDate: "2021-04-28T15:32:57.135Z"))
            .mapError({ (error) -> Error in
                      print(error)
                       return error })
                     .sink(receiveCompletion: { _ in }, receiveValue: { response in
                        UserDefaults.standard.set(response.id, forKey: Constants.broadcastID)
                    self.broadcast = response
                    self.idBroadcast = response.id ?? 0
                    print(response)
                })
             }

}
