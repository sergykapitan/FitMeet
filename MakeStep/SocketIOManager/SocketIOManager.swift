//
//  SocketIOManager.swift
//  MakeStep
//
//  Created by novotorica on 01.07.2021.
//

import Foundation
import SocketIO
import Combine

class SocketIOManager: NSObject {
    
  
    @Inject var fitMeetApi: FitMeetApi
    private var takeTokenChat: AnyCancellable?
    
    static let sharedInstance = SocketIOManager()
    var query = ["broadcastId": 29, "channelId": 29]
   // var token: String?
    
   // var auth  = ["token" : token ]\(token)
    let path = ""
    let token = UserDefaults.standard.string(forKey: "tokenChat")
        
    var  manager = SocketManager(socketURL: URL(string:"https://dev.fitliga.com")!, config: [.log(true),                                                                                           .compress,
                                                                                        .forceNew(true),
                                                                                       // .forcePolling(true),
                                                                                        .reconnects(true),
                                                                                        .forceWebsockets(true),
                                                                                        .reconnectAttempts(3),
                                                                                        .reconnectWait(3),
                                                                                        .connectParams(["broadcastId": 264, "channelId": 9,"token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTUyMiwidXNlcklkIjoyOSwic2VydmljZU5hbWUiOiJBVVRIX0FQUCIsImlhdCI6MTYyNTU3MjQ1MSwiZXhwIjoxNjI3MTk4MDgzODI5fQ.yJrRKGzSdApRHLEvMDvg1863KVZrhHOxTJKN9ItSSSw","path":"/api/v0/chatSocket"])
                                                                                        
    ])
    lazy var socket = manager.defaultSocket
    
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        let token = UserDefaults.standard.string(forKey: "tokenChat")
        
        self.manager.config = SocketIOClientConfiguration(
               arrayLiteral: .connectParams(["token": token!]), .secure(true)
               )
               socket.connect()
      //  socket.connect()
 

    }
        
    func closeConnection() {
        socket.disconnect()
    }
    
    func saveToken(tokenChat: String) {
        UserDefaults.standard.set(tokenChat, forKey: "tokenChat")
    }
    func getTokenChat() {
        takeTokenChat = fitMeetApi.getTokenChat()
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                guard let token = response.token else { return }
                self.saveToken(tokenChat: token)
              
                   
        })
    }
    
    func connectToServerWithNickname(nickname: String,  completionHandler: @escaping (_ userList: [[String: Any]]?) -> Void) {
        let token = UserDefaults.standard.string(forKey: "tokenChat")
        
//        self.manager.config = SocketIOClientConfiguration(
//            arrayLiteral: .connectParams(), .secure(true)
//               )
//               socket.connect()
//               socket.on(clientEvent: .connect) {data, ack in
//               print("socket connected")
//               self.gotConnection()
//              }
        
        socket.emit("editRole", nickname)
        socket.emit("message", nickname)
        socket.emit("help", nickname)
       
        socket.on("message") { ( dataArray, ack) -> Void in
            print("DATAARRAY ===== \(dataArray)")
            
            completionHandler(dataArray[0] as? [[String: Any]])
        }
        
        listenForOtherMessages()
    }
    func gotConnection(){

     socket.on("new message here") { (dataArray, ack) in

        print(dataArray.count)

         }
       }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: Any]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject
            messageDictionary["message"] = dataArray[1] as! String as AnyObject
            messageDictionary["date"] = dataArray[2] as! String as AnyObject
            
            completionHandler(messageDictionary)
        }
    }

    private func listenForOtherMessages() {
        socket.on("userConnectUpdate"){ (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: Any])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: Any])
        }
    }
    
    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }
    
    
    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
    
}
