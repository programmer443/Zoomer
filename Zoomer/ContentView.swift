//
//  ContentView.swift
//  Zoomer
//
//  Created by Muhammad Ahmad on 22/09/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimated: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    let pages: [Page] = pageData
    @State private var pageIndex = 1
    
    func resetImageState(){
        return withAnimation(.spring()){
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage() -> String {
        return pages[pageIndex - 1].imageName
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()){
                                imageScale = 5
                            }
                        }
                        else{
                            resetImageState()
                        }
                    })
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                withAnimation(.linear(duration: 1)){
                                    imageOffset = gesture.translation
                                }
                            }
                            .onEnded{_ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged({ value in
                                withAnimation(.linear(duration: 1)){
                                    if imageScale >= 1 && imageScale <= 5{
                                        imageScale = value
                                    }else if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            })
                            .onEnded({ _ in
                                if imageScale > 5{
                                    imageScale = 5
                                }
                                else if imageScale >= 1{
                                    resetImageState()
                                }
                            })
                    )
            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
                ,alignment: .top
            )
            .overlay (
                Group{
                    HStack{
                        Button(action: {
                            withAnimation(.spring()){
                                if imageScale > 1{
                                    imageScale -= 1
                                    if imageScale <= 1{
                                        resetImageState()
                                    }
                                }
                            }
                        }, label: {
                            ImageControlView(icon: "minus.magnifyingglass")
                        })
                        Button(action: {
                            resetImageState()
                        }, label: {
                            ImageControlView(icon: "arrow.up.left.and.down.right.magnifyingglass")
                        })
                        Button(action: {
                            withAnimation(.spring()){
                                if imageScale < 5{
                                    imageScale += 1
                                    if imageScale > 5{
                                        imageScale = 5
                                    }
                                }
                            }
                        }, label: {
                            ImageControlView(icon: "plus.magnifyingglass")
                        })
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimated ? 1 : 0)
                }
                , alignment: .bottom
            )
            .overlay(
                HStack(spacing: 12){
                    Image(systemName:  isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .onTapGesture {
                            withAnimation(.easeOut){
                                isDrawerOpen.toggle()
                            }
                        }
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture(perform: {
                                isAnimated = true
                                pageIndex = page.id
                            })
                    }
                    Spacer()
                }
                    .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimated ? 1 : 0)
                    .frame(width: 260)
                    .offset(x: isDrawerOpen ? 20 : 215)
                    .padding(.top, UIScreen.main.bounds.height / 12)
                , alignment: .topTrailing
            )
        }.navigationViewStyle(.stack)
            .onAppear(perform: {
                withAnimation(.linear(duration: 0.5)){
                    isAnimated = true
                }
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
