//
//  HomeCustomList.swift
//  FitMeet
//
//  Created by novotorica on 22.04.2021.
//

import SwiftUI

struct HomeCustomList: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
extension Color {
    static let lightPink = Color(red: 236 / 255, green: 188 / 255, blue: 180 / 255)
    static let lightGray = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let lightOrange = Color(red: 219 / 255, green: 98 / 255, blue: 68 / 255)
    static let iconGray = Color(red: 112 / 255, green: 112 / 255, blue: 112 / 255)
    static let lighterPink = Color(red: 233 / 255, green: 219 / 255, blue: 210 / 255)
    static let lighterGray = Color(red: 214 / 255, green: 214 / 255, blue: 214 / 255)
}

struct nospaceTags: View {
    
    var tags: Array<String>
    
    var body: some View {
        HStack {
            ForEach(tags, id: \.self) { tag in
                Text("\(tag)")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(.vertical, 2)
                    .foregroundColor(.black)
            }
        }
    }
}




struct NoSpaceList: View {
    var videos: [Video] = []
    @State var selected = 0
    var body: some View {
        GeometryReader { g in
            NavigationView {
                ScrollView {
                    HStack {
                        CustomSegmentedPickerView(selected: self.$selected)
//                        Image(systemName: "square.grid.3x3.fill")
//                            .font(.callout)
                        Spacer()
//                        Text("The Happy Programmer")
//                            .font(.callout)
//                        Spacer()
//                        Image(systemName: "magnifyingglass")
//                            .font(.callout)
                    }//.padding(.leading,-10)//.ignoresSafeArea()
                    Spacer()
                    VStack {
                        ForEach(videos) { video in
                            NavigationLink(destination: NospaceListDestination(post: video)) {
                                HStack{
                                    HStack(alignment: .firstTextBaseline) {
                                        VStack(alignment: .leading) {
                                            Image("Preview")
                                                .resizable()
                                                .frame(width: g.size.width, height: g.size.height / 2.3)
                                            
                                            
                                            
                                            Text(video.title)
                                                .font(.largeTitle)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            nospaceTags(tags: ["iOS","SwiftUI", "Xcode"])
                                            Spacer()
                                            Divider().frame(height: 0.5).background(Color.black)
                                            HStack {
                                                Text("Post Updated")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                                Spacer()
                                                Text(video.title)
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }.padding(.bottom, 20)
                                        }.padding(.top, 30)
                                        
//                                        Image(systemName: "arrow.right")
//                                            .foregroundColor(.iconGray)
//                                            .font(.largeTitle)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: g.size.width, height: g.size.height / 2.5)
                                //.background(video.Color)
                            }
                            
                        }
                    }
                }
                .frame(width: g.size.width, height: g.size.height)
                .navigationBarTitle(Text("Home"))
                .padding(.bottom,-80)
                
                .navigationBarItems(trailing:
                                        HStack{
                                            Button(action: {print("123") }) { Image("Time")}.accentColor(.red)
                                            Button(action: { print("345")}) { Image("Note")}.accentColor(.red)
                                                .padding(6)
                                        })
            }
        }
    }
}

struct NospaceListDestination: View {
    @Environment(\.presentationMode) var presentationMode
    var post : Video
    var body: some View {
        VStack {
            GeometryReader { g in
                VStack {
                    ZStack(alignment: .top) {
                       // post.Color
                        Image("Preview")
                            .resizable()
                            .frame(width: g.size.width, height: g.size.height / 2.3)
                            
//                            .overlay(LinearGradient(gradient: Gradient(colors: [post.Color, post.Color.opacity(0.1)]), startPoint: .bottom, endPoint: .top))
                         //   .overlay(post.Color.opacity(0.5))
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                                
                            }, label: {
                                Image(systemName: "arrow.left")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(10)
                                   // .background(post.Color.opacity(0.1))
                                    .cornerRadius(100)
                            })
                            Spacer()
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding(10)
                                  //  .background(post.Color.opacity(0.1))
                                    .cornerRadius(50)
                            })
                        }
                        
                        .padding(.horizontal)
                        .padding(.bottom)
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    }.frame(height: g.size.height / 2.3)
                    HStack {
                        Text("Post Updated")
                            .font(.caption)
                            .foregroundColor(.black)
                        Spacer()
                        Text(post.title)
                            .font(.caption)
                            .foregroundColor(.black)
                    }.padding(.horizontal)
                    .padding(.vertical, 10)
                    VStack(alignment: .leading,spacing: 30) {
                        Text(post.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text("One advanced diverted domestic sex repeated bringing you old. Possible procured her trifling laughter thoughts property she met way. Companions shy had solicitude favourable own.").lineSpacing(10)
                    }.padding()
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Spacer()
                            Text("Read More")
                                .padding(.trailing)
                            Image(systemName: "arrow.right")
                                
                            Spacer()
                        }.padding()
                        .border(Color.black, width: 1)
                        .padding()
                        .foregroundColor(.black)
                    }.padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                }
            }
        }
        .navigationBarHidden(true)
       // .background(post.Color)
       // .ignoresSafeArea(edges: [.top,.bottom])
    }
}

// ------------------------------------------
struct HomeCustomList_Previews: PreviewProvider {
    static var previews: some View {
        NoSpaceList()
    }
}
