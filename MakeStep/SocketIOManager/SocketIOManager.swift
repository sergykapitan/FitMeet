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
        print("token Chat = \(token)")
        
        self.manager = SocketManager(socketURL: URL(string:"https://dev.fitliga.com")!, config: [
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
        
        
        socket.on("connection") {data, ack in
            
//            let dict = data[0] as? [String: Any]
//            let user = dict!["connectedUsers"] as? [[String: Any]]
//            print("USER == \(user)")
//            let col = user!
//            let k = col
//            print("K ==\(k)")
//            print("COL == \(col)")
//            let id = user![0]["username"] as? String
//            print("USERNAME === \(id)")
            
           // UserDefaults.standard.set(id, forKey: "idChat")
            
        }
   
        socket.connect()

    }
        
    func closeConnection() {
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
                print("\(token)")
                self.saveToken(tokenChat: token)
              
                   
        })
    }
    
    func connectToServerWithNickname(nickname: String,  completionHandler: @escaping (_ userList: [[String: Any]]?) -> Void) {

        let token = UserDefaults.standard.string(forKey: "tokenChat")
     

        socket.connect()

        
        socket.on("connectUser") { dataArr, socData in
            print("CONECTENUSER == \(dataArr)")
        }
 
    }
    func gotConnection(){
          socket.on("message") { (dataArray, ack) in

          

         }
       }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
       // socket.emit("disconnectUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: [String: String], withNickname nickname: String) {
        
        let dict =  ["message": message,
                     "messageType": "TEXT_MESSAGE",
                     "targetUserId": nil,
                     "targetMessageId": nil] as [String : Any?]
        socket.emit("message", dict)

    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String : String]) -> Void) {
        

        socket.on("message") { (dataArray, socketAck) -> Void in
            
            print("CHAT ===\(dataArray)")
            
            var messageDictionary = [String: String]()
            

            let dict = dataArray[0] as? [String: Any]
            
            let user = dict!["user"] as? [String: Any]
            
            let message = dict!["payload"] as? [String: Any]
            
            let text = message!["message"] as? [String: Any]
            print(user)
            
            
            messageDictionary["username"] = user!["fullName"] as! String
            messageDictionary["message"] = text!["text"] as! String
            messageDictionary["timestamp"] = dict!["timestamp"] as! String

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
        socket.emit("connectUser", nickname)
    }
    
    
    func sendStopTypingMessage(nickname: String) {
       // socket.emit("disconnectUser", nickname)
       
        //socket.disconnect()
    
    }
    
    func stopSocket() {
        socket.manager?.disconnect()
    }

}
