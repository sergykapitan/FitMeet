//
//  ListChannell.swift
//  FitMeet
//
//  Created by novotorica on 28.04.2021.
//


import SwiftUI

struct ListChannell: View {
    
    @ObservedObject var viewModel = ChanellListViewModel()

        var body: some View {
            
            NavigationView {
                List(viewModel.channels.data) { channel in
                    NavigationLink(destination: StreamCell(id: channel.id ?? 0))
                    { ChannellCell(cell: channel) }
                }
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
    @State var idStream: Int?
    var body: some View {
                     
                    MyPlayewView()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .edgesIgnoringSafeArea(.all)
                        .frame(alignment: .center)
                 //   Text("\(id)")
                   // TextMy(url: viewModel.broadcast?.id)
                 //   Text("\(viewModel.stream?.url ?? "wert")")
                        .onAppear {
                         //   self.viewModel.startStreamId(id: 4)
                          //  self.viewModel.fetchBreweries(id: id, name: "BroadcastNameSert")

                }
             //   Spacer()
            }
        }

    struct TextMy: View {
        @ObservedObject var viewModel = StreamViewModel()
        var url: Int?

        var body: some View {
            guard let u = url else {
                return AnyView(Text("Loading..."))
            }
           // self.viewModel.fetchStream(id: u, name: "StreamName")
            return AnyView(Text("\(u)"))
        }
    }


struct MyPlayewView: UIViewControllerRepresentable {
    
   // var url: URL
    func makeUIViewController(context:
              UIViewControllerRepresentableContext<MyPlayewView>) ->
    UIViewController {
       // let videoURL = url
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PopUpLive") as! LiveViewController
        let nextViewController = LiveStreamViewController()
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
