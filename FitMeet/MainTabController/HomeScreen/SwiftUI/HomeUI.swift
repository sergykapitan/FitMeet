//
//  HomeUI.swift
//  FitMeet
//
//  Created by novotorica on 21.04.2021.
//

import SwiftUI
import UIKit
import AVKit

class HostVC<T>: UIHostingController<T> where T: View {
    override var shouldAutorotate: Bool {
        return false
    }
}

struct HomeUI: View {
    init(){
        UITableView.appearance().backgroundColor = UIColor(named: "backgroundLight")
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().separatorStyle = .none
       // UITabBar.appearance().isTranslucent = true
          }
     var videos: [Video] = []
    @State var videoMy: Video?
    @State private var favoriteColor = "Trending"
    @State var selected = 0
    @State var presentSheet = false
    var body: some View {
      //  GeometryReader { g in
        NavigationView {
            VStack() {
                CustomSegmentedPickerView(selected: self.$selected).background(Color.white)
                    .frame( height: 20)
                Spacer()
                if self.selected == 0 {
                    List(videos) { video in
                          NavigationLink(destination: MyImagePicker(url: video.url))
                            { LibraryCell(cell: video) }
                    }
                } else if self.selected == 1{
                    List(videos) { video in
                          NavigationLink(destination: MyImagePicker(url: video.url))
                           { TrendingCell(cell: video) }
                    }
                } else {
                    
                }
            }
            .navigationBarTitle(Text("Home"))
            .navigationBarItems(trailing:
            HStack{
             Button(action: {print("123") }){Image("Time")}.accentColor(.red)
             Button(action: { print("345")}) { Image("Note")}.accentColor(.red)
             .padding(6)
              })

         }.navigationViewStyle(StackNavigationViewStyle())
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
        VStack() {
                Text("").frame( height: 15)
                Image("Preview")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio( contentMode: .fit)
                    .overlay(ImageOverlay(),alignment: .topLeading)
                    .cornerRadius(2)
                    .clipped()
                    .padding(.leading,-20)
                    .padding(.trailing, -40)
                Spacer()
                HStack{
                    Image("avatar").mask(Circle()).overlay(
                        Circle().stroke(Color.red, lineWidth: 2))
                    Text("\(cell.title)").foregroundColor(.gray)
                        .font(.custom("SFProDisplay-Regular", size: 16))
                    Spacer()
                    Button(action: {print("Like") }) { Image("Like")}.accentColor(.red)
                    Button(action: { print("More")}) { Image("More")}.accentColor(.red)
                        .padding(.trailing,0)
                }
            Spacer()
            Text("Bring balance and focus to your life by joining this yoga class").padding(.leading,55).font(.headline).padding(.top,-20)
            Spacer()
            HStack(){
                Text("Yoga")
                    .foregroundColor(.lightGray)
                    .font(.custom("SFProDisplay-Regular", size: 14))
                Text("•")
                    .foregroundColor(.lightGray)
                    .font(.custom("SFProDisplay-Regular", size: 14))
                Text("Beginner")
                    .foregroundColor(.lightGray)
                    .font(.custom("SFProDisplay-Regular", size: 14))
                Spacer()
            }.padding(.leading,60).animation(.default)
                Spacer()
             }.buttonStyle(PlainButtonStyle())
             
          }
       }

struct TrendingCell: View {
    var cell: Video
    var body: some View {
            VStack() {
                
                Image("Preview1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(ImageOverlay(),alignment: .topLeading)
                    .cornerRadius(2)
                    .scaledToFill()
                Spacer()
                HStack{
                    Text("\(cell.title)")
                    Spacer()
                    Button(action: {print("777777") }) { Image("Like")}.accentColor(.red)
                    Button(action: { print("8888888")}) { Image("More")}.accentColor(.red)
                        .padding(.trailing,20)
                }
                Spacer()
                   
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