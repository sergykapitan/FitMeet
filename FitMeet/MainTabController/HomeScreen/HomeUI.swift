//
//  HomeUI.swift
//  FitMeet
//
//  Created by novotorica on 21.04.2021.
//

import SwiftUI
import UIKit
import AVKit

struct HomeUI: View {
    
    var videos: [Video] = []
    @State private var favoriteColor = "Trending"

    
    @State var selected = 0
    
    var body: some View {
        NavigationView {
            VStack() {
               
                CustomSegmentedPickerView(selected: self.$selected)
                
                if self.selected == 0 {
                    
                    
                } else {
                    
                }
                
                List(videos) { video in
                   // NavigationLink(destination: VideoPlayerContainerView(url: video.url))
                    NavigationLink(destination: MyImagePicker(url: video.url))
                    {
                    LibraryCell(cell: video)
                  }
                    
                }
                .listStyle(GroupedListStyle())
                .padding(.leading,-20)
                .padding(.trailing,-20)
                
            }
            .navigationBarTitle(Text("Home"))
            .navigationBarItems(trailing:
                                    HStack{
                                        Button(action: {print("123") }) { Image("Time")}.accentColor(.red)
                                        Button(action: { print("345")}) { Image("Note")}.accentColor(.red)
                                            .padding(6)
                                    })
        }
    }
}
struct MyImagePicker: UIViewControllerRepresentable {
    var url: URL
    func makeUIViewController(context:
              UIViewControllerRepresentableContext<MyImagePicker>) ->
    AVPlayerViewController {
        let videoURL = url
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        return playerViewController
    }
    func updateUIViewController(_ uiViewController:
                                    AVPlayerViewController, context:
              UIViewControllerRepresentableContext<MyImagePicker>) {
          }}

struct LibraryCell: View {
    var cell: Video
    var body: some View {
       
        HStack(alignment: .center) {
            VStack(alignment: .center) {
                
                Image("Preview")
                    .resizable()
                    .scaledToFit()
                    .overlay(ImageOverlay(),alignment: .topLeading)
                    .cornerRadius(2)
                    .padding(.leading,-20)
                    .padding(.trailing,-20)
                    .scaledToFit()
                HStack{
                    Text("\(cell.title)")
                    Spacer()
                    Button(action: {print("777777") }) { Image("Like")}.accentColor(.red)
                    Button(action: { print("8888888")}) { Image("More")}.accentColor(.red)
                        .padding(.trailing,20)
                }
             }
         }
    }
}
struct ImageOverlay: View {
    var body: some View {
        ZStack{
            Text("OverlayText")
                .font(.callout)
                .padding(6)
                .foregroundColor(.white)
        }.background(Color.gray)
        .opacity(0.3)
        .cornerRadius(10.0)
        .padding(15)
    }
}
struct CustomSegmentedPickerView: View {
    @Binding var selected: Int
    var titles = ["Trending", "For you", "Subscriptions"]
    var body: some View {
        HStack (spacing: 10){
            ForEach(self.titles.indices, id: \.self) { index in
            Button(action: {
                 self.selected = index
            }){
                Text(self.titles[index])
                    .background(
                      Capsule().fill( self.selected == index ? Color(red: 0, green: 0.601, blue: 0.683) : Color.clear)
                        .frame(width: 50, height: 3, alignment: .center)
                        .offset( y: 15.0)
                        ,alignment: .center
                    )
            }
            .foregroundColor(self.selected == index ? Color(red: 0, green: 0.601, blue: 0.683) : .gray)
            }
            Spacer()
        }.padding(.leading,20).animation(.default)
        Spacer()
    }
}

struct Library_Previews: PreviewProvider {
    static var previews: some View {
        HomeUI()
    }
}
