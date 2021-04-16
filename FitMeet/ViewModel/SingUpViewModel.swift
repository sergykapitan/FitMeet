//
//  SingUpViewModel.swift
//  FitMeet
//
//  Created by novotorica on 14.04.2021.
//

import Foundation
import Combine


class SingUpViewModel: ObservableObject {
    
    @Inject var fitMeetApi: FitMeetApi
   // @Published var responce: AuthResponce?
    var cancellation: AnyCancellable?
    
//    init() {
//            fetchAuth()
//        }
//    func fetchAuth() {
//        let auth = AuthorizationRequest(fullName: "Foo", username: "Bar", email: "foo@gmail.com", phone: "+79117552870", password: "123456789")
//
//        cancellation = fitMeetApi.signupPassword(authRequest: auth)
//           .mapError({ (error) -> Error in
//               print(error)
//               return error
//           })
//           .sink(receiveCompletion: { _ in }, receiveValue: { responce in
//                   self.responce = responce
//                  print("RESPONCE =======\(responce)")
//           })
//       }
//
    
}
