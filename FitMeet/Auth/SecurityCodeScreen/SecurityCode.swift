//
//  SecurityCode.swift
//  FitMeet
//
//  Created by novotorica on 15.04.2021.
//

import SwiftUI

struct SecurityCode: View {
    
    @State var text: String = "5467"
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack (alignment: .center, spacing: 20){
                Text("Security Code")
                    .font(.system(size: 16))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .accentColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                Text("Enter the code sent to you by Email")
                    .font(.system(size: 12))
                    .accentColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                     
                TextField("Placeholder Text", text: $text)
                            .frame(width: geometry.size.width - 32, height: 39)
                            .font(.system(size: 13, weight: .light, design: .default))
                            .background(Color(red: 0.975, green: 0.975, blue: 0.975))
                            .multilineTextAlignment(.center)
                            //.padding(.leading,10).padding()
                           .border(Color.red, width: /*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            .cornerRadius(32)

                            
               Button(action: {print("12345")}, label: {
                            Text("Send Code")
                                .accentColor(Color.init(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                                .font(.system(size: 16))
                        })
                        .frame(width: geometry.size.width - 32, height: 39)
                        .background(Color(red: 0, green: 0.601, blue: 0.683))
                        .cornerRadius(32)
            }
            Spacer()
          }
        }
      }

struct SecurityCode_Previews: PreviewProvider {
    static var previews: some View {
        SecurityCode()
            .preferredColorScheme(.light)
            .padding(0.0)
    }
}
