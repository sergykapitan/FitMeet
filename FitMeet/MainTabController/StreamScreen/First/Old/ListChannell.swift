//
//  ListChannell.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//


import SwiftUI
//var broadcastID = UserDefaults.standard.string(forKey: Constants.broadcastID)

struct ListChannell: View {
    
    @ObservedObject var viewModel = ChanellListViewModel()
    @State var selection: Int? = nil
    @State var broadcastName: String = ""
    
        var body: some View {
             NavigationView {
                     VStack {
                        Text("Broadcast: \(broadcastName)")
                        Spacer()
                        TextField("{username}'s broadcast", text: $broadcastName, onEditingChanged:{(changed) in
                            print("username change = \(changed)")
                        })
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray, lineWidth: 2))
                        .shadow(radius: 6)
                        .frame(width: 300, height: 40, alignment: .center)
                        .foregroundColor(Color.lightGray)
                        
                        NavigationLink(destination: StreamCell(id: viewModel.idBroadcast, nameBroadcast: "\(broadcastName)"),tag: 1, selection: $selection) {
                                        Button("Start Live Stream") {
                                            self.selection = 1
                                        }
                                        .frame(width: 300, height: 30, alignment: .center)
                                        .background(Color(red: 0.925, green: 0, blue: 0.549))
                                    }.cornerRadius(6)
                                     .overlay(RoundedRectangle(cornerRadius: 6)
                                     .stroke(Color.red, lineWidth: 2))
                                    // .shadow(radius: 6)
                        
                        
                        
                     }
                     .padding(.bottom, 30)
                     .navigationBarTitle("List Channel")
                     .navigationBarItems(trailing:

                                  Button("Edit") {
                                    print("About tapped!")
                                    }
                             )
                .onAppear {
                      //  self.viewModel.fetchBreweries()
                   }
                }
            }
         }

struct ChannellCell: View {
    var cell: ChannelResponce
    var body: some View {
                HStack{
                    Text("\(cell.id ?? 0)")
                    Spacer()
                    Button(action: {print("777777") }) { Image("Like")}.accentColor(.red)
                    Button(action: { print("8888888")}) { Image("More")}.accentColor(.red)
                        .padding(.trailing,20)
                }
              }
           }

struct StreamCell: View {
    @ObservedObject var viewModel = StreamViewModel()
    @State var id: Int
    @State var nameBroadcast: String
    @State private var showPopUp: Bool = false
    @State var username: String = ""
    
    var body: some View {
        NavigationView {
                        MyPlayewView(name: nameBroadcast)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .frame(alignment: .center)
                        .onAppear {
                         //   self.viewModel.fetchStream(id: id, name: nameBroadcast)
              
                        }
                      }.navigationBarItems(trailing:
                            HStack {
                                Button(action: {withAnimation(.linear(duration: 0.3)){}
                                    showPopUp.toggle()
                                }, label: { Image(uiImage: #imageLiteral(resourceName: "Message"))})
                            Button(action: { print("123")}, label: {Image(uiImage: #imageLiteral(resourceName: "Settings")) })
                             }
                        )
       
     //   PopUpWindow(title: "Stream Name", message: "Please Enter Your Stream Name", buttonText: "OK", show: $showPopUp)
            
        }
    
   
    }





//    struct TextMy: View {
//        @ObservedObject var viewModel = StreamViewModel()
//        var url: Int?
//
//        var body: some View {
//            guard let u = url else {
//                return AnyView(Text("Loading..."))
//            }
//           // self.viewModel.fetchStream(id: u, name: "StreamName")
//            return AnyView(Text("\(u)"))
//        }
//    }
//

struct MyPlayewView: UIViewControllerRepresentable {
    
    var name: String
    
    func makeUIViewController(context:
              UIViewControllerRepresentableContext<MyPlayewView>) ->
    UIViewController {
        let nextViewController = LiveStreamViewController()
        nextViewController.nameStream = name
        return nextViewController
    }
    func updateUIViewController(_ uiViewController:
                                    UIViewController, context:
              UIViewControllerRepresentableContext<MyPlayewView>) {
          }
    
}



struct ListChannell_Previews: PreviewProvider {
    static var previews: some View {
        ListChannell()
    }
}

