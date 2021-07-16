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
  //  var query = ["broadcastId": 29, "channelId": 29]
   // var token: String?
    
   // var auth  = ["token" : token ]\(token)
    let path = ""
    let token = UserDefaults.standard.string(forKey: "tokenChat")
    let broadcastId = UserDefaults.standard.string(forKey: Constants.broadcastID)
    let chanelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    
   // guard let t = token else { return }
    
        
    lazy var  manager = SocketManager(socketURL: URL(string:"https://dev.fitliga.com")!, config: [
                                                                .log(true),
                                                                .compress,
                                                                .forceNew(true),
                                                                .reconnects(true),
                                                                .forceWebsockets(true),
                                                                .reconnectAttempts(3),
                                                                .reconnectWait(3),
                                                                .path("/api/v0/chatSocket"),
                                                                .reconnectWaitMax(10000),
                                                                .connectParams(["broadcastId": broadcastId, "channelId": chanelId,"token": token])
                                                                                        
    ])
    lazy var socket = manager.socket(forNamespace: "/swift")

    
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        
        let token = UserDefaults.standard.string(forKey: "tokenChat")
        let broadcastId = UserDefaults.standard.string(forKey: Constants.broadcastID)
        let chanelId = UserDefaults.standard.string(forKey: Constants.chanellID)
        print("TOKEN +++++++++++++\(token)\n BROADCASTID +++++++++++\(broadcastId)\n ChanellID ===== \(chanelId)")
        
        guard let t = token,let b = broadcastId ,let chanel = chanelId else { return }
        
        
        
        print("TOKEN +++++++++++++\(t)\n BROADCASTID +++++++++++\(b)\n ChanellID ===== \(chanel)")
        
//        self.manager.config = SocketIOClientConfiguration(
//               arrayLiteral:
//        
//               .connectParams(["broadcastId": b, "channelId": chanel,"token": t]),
//               .path("/api/v0/chatSocket"),
//               .secure(true)
//               )
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
               socket.connect()
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
