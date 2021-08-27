//
//  SocketWatcher.swift
//  MakeStep
//
//  Created by novotorica on 27.08.2021.
//

import SocketIO
import Combine

class SocketWatcher: NSObject {
    
  
    @Inject var fitMeetApi: FitMeetApi
    private var takeTokenChat: AnyCancellable?
    
    static let sharedInstance = SocketIOManager()

    var manager: SocketManager!
    var socket: SocketIOClient!

    func establishConnection(broadcastId: String,chanelId: String) {
        
        let token = UserDefaults.standard.string(forKey: "tokenChat")
        
        self.manager = SocketManager(socketURL: URL(string:"https://dev.fitliga.com")!, config: [
                                                                    .log(true),
                                                                    .compress,
                                                                    .forceNew(true),
                                                                    .reconnects(true),
                                                                    .forceWebsockets(true),
                                                                    .reconnectAttempts(3),
                                                                    .reconnectWait(3),
                                                                    .path("/api/v0/watcherSocket"),
                                                                    .reconnectWaitMax(10000),
                                                                    .connectParams(["broadcastId": broadcastId, "channelId": chanelId,"token": token!])
        
        
        
        ])
        
        
        self.socket = manager.defaultSocket
        socket.connect()

    }
        
    func closeConnection() {
        socket.disconnect()
    }
    
    func saveToken(tokenChat: String) {
        UserDefaults.standard.set(tokenChat, forKey: "tokenWatcher")
    }
    func getTokenChat() {
        takeTokenChat = fitMeetApi.getTokenWatcher()
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                guard let token = response.token else { return }
                print("\(token)")
                self.saveToken(tokenChat: token)
              
                   
        })
    }
    

}
