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
    @Published var broadcastList: BroadcastList?
    @Published var url: String = ""
    let userID = UserDefaults.standard.string(forKey: Constants.userID)
    
    

    func fetchStream(id:Int,name: String) {
        guard let userid = userID else { return }
        let userId = Int(userid)
        guard let user = userId else { return }

        task = fitMeetStream.startStream(stream: StartStream(name: name, userId: user, broadcastId: id))
            .mapError({ (error) -> Error in
                  print(error)
                   return error })
                 .sink(receiveCompletion: { _ in }, receiveValue: { response in
                    self.stream = response
                    guard let url = response.url else { return }
                    UserDefaults.standard.set(url, forKey: Constants.urlStream)
                    self.url = url
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
    
//    func getListBroadcast(id:String) {
//        task = fitMeetStream.getListBroadcast(id: id)
//            .mapError({ (error) -> Error in
//                        print(error)
//                         return error })
//            .sink(receiveCompletion: { _ in }, receiveValue: { response in
//                self.broadcastList = response
//                print(response)
//        })
//    }
    
}
