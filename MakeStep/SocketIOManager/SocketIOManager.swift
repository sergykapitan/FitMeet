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

    var manager: SocketManager!
    var socket: SocketIOClient!

    func establishConnection(broadcastId: String,chanelId: String) {
        
        guard let token = UserDefaults.standard.string(forKey: "tokenChat") else { return }
        
#if QA
 let url = "https://dev.makestep.com"
#elseif DEBUG
 let url = "https://api.makestep.com"
#endif
  
        self.manager = SocketManager(socketURL: URL(string:url)!, config: [
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
        
        
        self.socket = manager.defaultSocket
        socket.connect()

    }
        
    func closeConnection() {
        guard let socket = socket else { return }
        socket.disconnect()
    }
    
    func saveToken(tokenChat: String) {
        UserDefaults.standard.set(tokenChat, forKey: "tokenChat")
    }
    func getTokenChat() {
        takeTokenChat = fitMeetApi.getTokenChat()
            .mapError({ (error) -> Error in
                        return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                guard let token = response.token else { return }
                self.saveToken(tokenChat: token)
              
                   
        })
    }
    
    func connectToServerWithNickname(nicname: String, completionHandler: @escaping (_ userList: [Int]?) -> Void) {
        guard let socket = socket else {return}
        socket.connect()
        var arrayUserId = [Int]()
        var arrUser = [Any]()
        socket.on("connection") { dataArr, socData in
          
            for i in dataArr {
                let dicty = i as? [String: Any]
                let user = dicty?["connectedUsers"] as? [Any]
                guard let users = user else { return }
                arrUser = users
            }
            arrUser.forEach { i in
                let  dictUser =  i as? [String: Any]
                let  userid = dictUser?["userId"] as? Int
                guard let userId = userid else { return }
                arrayUserId.append(userId)
               
            }
            completionHandler(arrayUserId)
        }
       
    }
    
    func gotConnection(){
          socket.on("message") { (dataArray, ack) in

         }
       }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        completionHandler()
    }
    
    func sendMessage(message: [String: String], withNickname nickname: String) {
        
        let dict =  ["message": message,
                     "messageType": "TEXT_MESSAGE",
                     "targetUserId": nil,
                     "targetMessageId": nil] as [String : Any?]
        guard let socket = socket else { return }
        socket.emit("message", dict)

    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String : Any]) -> Void) {
        
        guard let socket = socket else { return }
        socket.on("message") { (dataArray, socketAck) -> Void in
            
            var messageDictionary = [String: Any]()
            let dict = dataArray[0] as? [String: Any]
            let user = dict!["user"] as? [String: Any]
            let message = dict!["payload"] as? [String: Any]
            let text = message!["message"] as? [String: Any]
            
            
            messageDictionary["username"] = user!["fullName"] as! String
            messageDictionary["message"] = text!["text"] as! String
            messageDictionary["timestamp"] = dict!["timestamp"] as! String
            messageDictionary["id"] = user!["userId"] as! Int

            completionHandler(messageDictionary) 
        }
    }

    private func listenForOtherMessages() {
         
        socket.on("message"){ (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: Any])
        }
        
        socket.on("disconnectUser") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: Any])
        }

    }
    
    func sendStartTypingMessage(nickname: String) {
        guard let socket = socket else { return }
        socket.emit("connectUser", nickname)
    }
    
    
    func sendStopTypingMessage(nickname: String) {

    }
    
    func stopSocket() {
        socket.manager?.disconnect()
    }

}
