//
//  StreamViewModel.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//

import Foundation
import Combine

class StreamViewModel: ObservableObject {
    
    @Inject var fitMeetStream: FitMeetStream
    private var task: AnyCancellable?
    
    @Published var broadcast: BroadcastResponce?
    @Published var stream: StreamResponce?
    
   //
    func fetchBreweries(id:Int,name: String) {
        task = fitMeetStream.createBroadcas(broadcast: BroadcastRequest(channelID: id, name: name, type: "STANDARD", access: "ALL", hasChat: true, isPlanned: true, onlyForSponsors: false, onlyForSubscribers: false,categoryIDS: [1], scheduledStartDate: "2021-04-28T15:32:57.135Z"))
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    self.broadcast = response
                    print(response)
            })
           }
    func fetchStream(id:Int,name: String) {
        task = fitMeetStream.startStream(stream: StartStream(name: name, userID: 29, broadcastID: id))
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    self.stream = response
                    print(response)
            })
           }
    func startStreamId(id:Int) {
        task = fitMeetStream.startStremId(id: id)
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    self.stream = response
                    print(response)
            })
           }
    
    
    
}
