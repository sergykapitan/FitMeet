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

    
    let token = UserDefaults.standard.string(forKey: "tokenChat")
    let broadcastId = UserDefaults.standard.string(forKey: Constants.broadcastID)
    let chanelId = UserDefaults.standard.string(forKey: Constants.chanellID)
    

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
                                                                .connectParams(["broadcastId": broadcastId!, "channelId": chanelId!,"token": token!])
                                                                                        
    ])
    //"token": token!
    lazy var socket = manager.defaultSocket

    
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        getTokenChat()
        
        let token = UserDefaults.standard.string(forKey: "tokenChat")
        let broadcastId = UserDefaults.standard.string(forKey: Constants.broadcastID)
        let chanelId = UserDefaults.standard.string(forKey: Constants.chanellID)
       
        
        guard let t = token,let b = broadcastId ,let chanel = chanelId else { return }

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
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                guard let token = response.token else { return }
                print("\(token)")
                self.saveToken(tokenChat: token)
              
                   
        })
    }
    
    func connectToServerWithNickname(nickname: String,  completionHandler: @escaping (_ userList: [[String: Any]]?) -> Void) {
        
        getTokenChat()
        let token = UserDefaults.standard.string(forKey: "tokenChat")
     

        socket.connect()

//        connection = 'connection',
//        connectUser = 'connectUser',
//        disconnectUser = 'disconnectUser',
//        message = 'message',
//        closeRoom = 'closeRoom',
//        editRole = 'editRole',
//        systemMessage = 'systemMessage',
//        help = 'help',
        
        socket.emit("connection", nickname)
        socket.emit("connectUser", nickname)
        socket.emit("disconnectUser", nickname)
        socket.emit("closeRoom", nickname)
        socket.emit("systemMessage", nickname)
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
          socket.on("message") { (dataArray, ack) in

          print(dataArray.count)

         }
       }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("disconnectUser", nickname)
        completionHandler()
    }
    
    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("message", nickname, message)
    }
    
    func getChatMessage(completionHandler: @escaping (_ messageInfo: [String: Any]) -> Void) {
        socket.on("messageAll") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
       
            messageDictionary["username"] = dataArray[4] as! String as AnyObject?
            messageDictionary["message"] = dataArray[1]  as! String as AnyObject?
            messageDictionary["timestamp"] = dataArray[3] as! String as AnyObject?
       
            
            completionHandler(messageDictionary)
        }
    }

    private func listenForOtherMessages() {
         
        socket.on("connectUser"){ (dataArray, socketAck) -> Void in
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
        socket.emit("disconnectUser", nickname)
    }
    
}
