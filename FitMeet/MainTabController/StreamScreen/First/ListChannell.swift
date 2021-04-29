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
   // @ObservedObject var userSettings = UserSettings()
    
        var body: some View {
            
            NavigationView {
              
             //   OptionalView(viewModel.broadcast?.id) { ID in
                    VStack {
                    
                        NavigationLink(destination: StreamCell(id: viewModel.idBroadcast),tag: 1, selection: $selection) {
                                        Button("Press me") {
                                            self.selection = 1
                                        }
                                    }
                                }
              //  }
 
                .navigationBarTitle("List Channel")
                .onAppear {
                        self.viewModel.fetchBreweries()
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
    var id: Int
    var body: some View {
        
                        MyPlayewView()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .frame(alignment: .center)
                        .onAppear {
                            self.viewModel.fetchStream(id: id, name: "Name Stream")
              
                        }
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
    
   // var url: String
    
    func makeUIViewController(context:
              UIViewControllerRepresentableContext<MyPlayewView>) ->
    UIViewController {
        let nextViewController = LiveStreamViewController()
        let d = UserDefaults.standard.string(forKey: Constants.urlStream)
        print("HHHHHHHHHHH=======\(d)")
        nextViewController.url = d
        return nextViewController
    }
    func updateUIViewController(_ uiViewController:
                                    UIViewController, context:
              UIViewControllerRepresentableContext<MyPlayewView>) {
          }}



struct ListChannell_Previews: PreviewProvider {
    static var previews: some View {
        ListChannell()
    }
}
