//
//  ContentView.swift
//  20260911_AM
//
//  Created by competitor on 2026/9/11.
//

import SwiftUI

struct ContentView: View {
    @State var vm = VM()
    @Environment(\.colorScheme) var colorScheme
    @State var isActive = false
    var body: some View {
        VStack (spacing: 20){
            VStack{
                header
                    .padding()
                    .padding(.horizontal)
                Capsule()
                    .fill(.secondary)
                    .frame(height: 2)
            }
            if let _ = vm.selectedBook{
                DetailView(vm: vm)
            }else{
                HomeView(vm: vm)
            }
            
            
        }
        //.padding()
        .onAppear{
            withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: true)) {
                isActive = true
            }
        }
    }
    var header: some View{
        HStack(alignment: .center){
            ZStack{
                RoundedRectangle(cornerRadius: 20 )
                    .fill(
                        accent
                    )
                    .frame(width: 80, height: 80)
                Image(colorScheme == .dark ? "logo-black" : "logo-white")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
               
            }
            .scaleEffect(isActive ? 0.9 : 0.8)
            .rotationEffect(.degrees(isActive ? -10 : 10))
            .onTapGesture {
                withAnimation {
                    vm.selectedBook=nil
                }
            }
            VStack(alignment: .leading) {
                Text("NeubrandenBook")
                    .font(.title2.bold())
                    .foregroundStyle(accent)
                Text("Discover Your Next Adventure")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            HStack{
                Image(systemName: "magnifyingglass")
                Text("Search books, authors, genres…")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 30))
        }
    }
}
struct DetailView: View {
    @Bindable var vm:VM
    @State var isPreview = false
    @State var seeMore = false
    @State var openGalley = false
    @State var sortBy: Sorter = .trending
    @State var isSaved = false
    @State var selectedArt: String?
    enum Sorter: String, CaseIterable{
        case trending, newest
    }
    var body: some View {
        if let book = vm.selectedBook{
            VStack{
                ScrollView(.vertical,showsIndicators: false){
                    HStack{
                        Button(action: {
                            withAnimation {
                                vm.selectedBook = nil
                            }
                        }, label: {
                            HStack{
                                Image(systemName: "chevron.left")
                                Text("Back to Home")
                            }.font(.title3.bold())
                        })
                        .buttonStyle(.bordered)
                            
                        Spacer()
                    }
                    VStack{
                        HStack(alignment: .top){
                            VStack{
                                Image(book.id)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 300, height: 400)
                                    .clipShape(.rect(cornerRadius: 30))
                                
                                Button(action: {
                                    isPreview.toggle()
                                }) {
                                    HStack{
                                        Image(systemName: "book")
                                        Text("Read Preview (\(book.previewPages?.count ?? 0))")
                                    }
                                    .bold()
                                    .padding()
                                    .padding(.horizontal,40)
                                    .foregroundStyle(.white)
                                    .background(accent,in: .rect(cornerRadius: 10))
                                }
                                
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.largeTitle)
                                    .bold()
                                Text("by: \(book.author)")
                                HStack{
                                    let maxRate = Int(book.rating.rounded())
                                    ForEach(0..<maxRate, id: \.self){ i in
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                    }
                                    ForEach(0..<5-maxRate,id: \.self){ i in
                                        Image(systemName: "star")
                                            .foregroundStyle(.primary)
                                    }
                                    Text("\(book.rating.formatted())")
                                }
                                
                                HStack{
                                    ForEach(book.tags,id: \.self){tag in
                                        Text(tag)
                                            .padding()
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(lineWidth: 1)
                                            }
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Description")
                                        .font(.title2.bold())
                                    Text(book.description)
                                        .lineLimit(seeMore ? nil : 4)
                                    Button(seeMore ? "Show less" :"Read more"){
                                        withAnimation {
                                            seeMore.toggle()
                                        }
                                    }
                                    
                                }
                            }
                            .frame(width: 400)
                        }
                    }
                    .padding(30)
                    .background(.thinMaterial,in: .rect(cornerRadius: 30))
                    
                    
                    VStack{
                        let fanArts = vm.fanArts.filter({$0.bookId == book.id})
                        HStack{
                            VStack(alignment: .leading){
                             Text("Fan Art Gallery")
                                    .font(.title2.bold())
                                Text("Explore amazing artwork created by our community")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button(action: {
                                openGalley.toggle()
                            }, label: {
                                HStack{
                                    Image("upload")
                                    Text("Upload Your Art")
                                }
                                .padding()
                                .foregroundStyle(.white)
                                .background(accent, in: .rect(cornerRadius: 10))
                            })
                        }
                        HStack{
                            Text("Sort by:")
                                .foregroundStyle(.secondary)
                            ForEach(Sorter.allCases,id: \.self){sorter in
                                Button {
                                    sortBy = sorter
                                } label: {
                                        HStack{
                                            Image(sorter == .trending ? "trending-up" : "clock")
                                            Text(sorter.rawValue)
                                        }
                                        .padding()
                                       
                                } .buttonStyle(.borderedProminent)
                                    .tint(sortBy == sorter ? .blue : .secondary)

                            }
                            Spacer()
                            
                        }
                        
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                            ForEach(fanArts.sorted(by: { sortBy == .newest ?
                                $0.createdAt>$1.createdAt : $0.likes>$1.likes
                            })){ art in
                                Image(art.id)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: art.width/2,height: art.height/2)
                                    .clipShape(.rect(cornerRadius: 30))
                                    .contextMenu{
                                        ShareLink("Share", item: art.id)
                                        Button("Save to Gallery"){
                                            selectedArt = art.id
                                            if let uiImage = saveImage(){
                                                UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                                    withAnimation {
                                                        isSaved.toggle()
                                                    }
                                                })
                                            }
                                        }
                                    }
                                
                            }
                        }
                        
                    }.padding(30)
                        .background(.thinMaterial,in: .rect(cornerRadius: 30))
                }
            }
            .padding()
            .overlay(content: {
                if isSaved{
                    VStack{
                        Text("Saved to Gallery")
                    }
                    .padding()
                    .background(in: RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 10)
                }
            })
//            .onChange(of: isSaved) { _, new in
//                if new{
//                  
//                }
//            }
        }
    }
    
    func saveImage() -> UIImage?{
        let image = Image(selectedArt ?? "")
        let renderer = ImageRenderer(content: image)
        renderer.scale = UIScreen.main.scale
        isSaved = true
        return renderer.uiImage
    }
}
struct HomeView: View {
    @Bindable var vm:VM
    @State var bannerIdx: Int? = 0
    @State var btnScale = 1.0
    @State var selectedBook: Book?
    @State var isActive = false
    var top20: [Book]{
        Array(vm.books.sorted(by: {$0.rating>$1.rating}).prefix(20))
    }
    var recent20: [Book]{
        Array(vm.books.sorted(by: {$0.publishingDate>$1.publishingDate}).prefix(20))
    }
    var editorPicks: [Book]{
        Array(vm.books.filter({$0.isEditorPick == true})
            .prefix(Int.random(in: 5...20))
        )
        
        
    }
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 20){
                ScrollView(.horizontal,showsIndicators: false){
                    HStack(spacing: 20){
                        ForEach(vm.books.enumerated(), id: \.offset){idx, book in
                            HStack{
                                Button(action: {
                                    if idx == 0{
                                        withAnimation {
                                            bannerIdx! = vm.books.count-1
                                        }
                                        
                                    }else{
                                        withAnimation {
                                            bannerIdx! -= 1
                                        }
                                        
                                    }
                                }, label: {
                                    Image(systemName: "chevron.left")
                                        .font(.title2)
                                        .padding(8)
                                })
                                .buttonStyle(.bordered)
                                VStack(alignment: .leading,spacing: 20){
                                    HStack{
                                        Image(systemName: "star.fill")
                                        Text("Featured Release")
                                    }
                                    .padding()
                                    .background(.yellow.opacity(0.1), in: RoundedRectangle(cornerRadius: 30))
                                    .foregroundStyle(.yellow)
                                    Text(book.title)
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundStyle(.white)
                                    Text("by \(book.author)")
                                        .font(.title)
                                        .foregroundStyle(.gray)
                                    
                                    Text(book.description)
                                        .font(.title3)
                                        .lineLimit(3)
                                        .foregroundStyle(.gray)
                                    
                                    HStack{
                                        exploreBtn(book: book)
                                        HStack{
                                            Image(systemName: "star.fill")
                                                .foregroundStyle(.yellow)
                                            Text("\(book.rating.formatted())")
                                                .font(.title3.bold())
                                                .foregroundStyle(.white)
                                            Text("(\(book.reviews.formatted()) reviews)")
                                                .font(.headline)
                                                .foregroundStyle(.gray)
                                        }
                                    }
                                }
                                Button(action: {
                                    if idx == vm.books.count-1{
                                        withAnimation {
                                            bannerIdx! = 0
                                        }
                                        
                                    }else{
                                        withAnimation {
                                            bannerIdx! += 1
                                        }
                                        
                                    }
                                }, label: {
                                    Image(systemName: "chevron.right")
                                        .font(.title2)
                                        .padding(8)
                                })
                                .buttonStyle(.bordered)
                            }
                            .opacity(isActive ? 1 : 0)
                            .animation(.easeInOut.delay(1.8), value: isActive)
                            .padding()
                            .frame(width: 780, height: 400)
                            .foregroundStyle(.white)
                            .background(
                                Image(book.id)
                                    .resizable()
                                    .scaledToFill()
                                    .overlay(content: {
                                        LinearGradient(colors: [.black.opacity(0.7), .indigo.opacity(0.5)], startPoint: .leading, endPoint: .trailing)
                                    })
                                    .clipped()
                            )
                            .clipShape(.rect(cornerRadius: 30))
                            .id(idx)
                            .padding(.horizontal)
                            
                        }
                    }
                    .scrollTargetLayout()
                    
                }
                .defaultScrollAnchor(.leading)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $bannerIdx)
                
                
                lists(books: top20, title: "trending Now", image: "trending-up")
                    .opacity(isActive ? 1 : 0)
                    .animation(.easeInOut.delay(1.0), value: isActive)
                lists(books: recent20, title: "new release", image: "sparkles")
                    .opacity(isActive ? 1 : 0)
                    .animation(.easeInOut.delay(1.3), value: isActive)
                lists(books: top20, title: "Editor’s Picks", image: "trending-up")
                    .opacity(isActive ? 1 : 0)
                    .animation(.easeInOut.delay(1.6), value: isActive)
            }
        }
        .padding()
        .onAppear{
            withAnimation {
                isActive = true
            }
            Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                if bannerIdx == vm.books.count-1{
                    withAnimation {
                        bannerIdx = 0
                    }
                }else{
                    withAnimation {
                        bannerIdx! += 1
                    }
                }
            }
        }
        
    }
    @ViewBuilder
    func exploreBtn(book: Book) -> some View{
        Button(action: {
            withAnimation {
                btnScale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                withAnimation {
                    btnScale = 1.0
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+0.7, execute: {
                withAnimation {
                    vm.selectedBook = book
                }
            })
            
        }, label: {
            Text("Explore Now")
                .bold()
                .foregroundStyle(.white)
                .padding()
                .background(accent,in: RoundedRectangle(cornerRadius: 30))
        })
        .scaleEffect(btnScale)
        
    }
    
    func lists(books: [Book], title: String, image: String) -> some View {
        VStack{
            HStack{
                HStack{
                    Image(image)
                    Text(title.capitalized)
                        .font(.title.bold())
                }
                Spacer()
                HStack(spacing: 15){
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(in: .circle)
                        .shadow(radius: 10)
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(in: .circle)
                        .shadow(radius: 10)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false){
                HStack(alignment: .top,spacing: 15){
                    ForEach(books){ book in
                        VStack(alignment:.leading){
                            ZStack{
                                Image(book.id)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 180,height: 280)
                                    .clipShape(.rect(cornerRadius: 10))
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 280, maximum: 300))]){
                                    ForEach(book.tags,id:\.self){ tag in
                                        Text(tag)
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                            .padding(8)
                                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 30))
                                        
                                    }
                                }
                                .offset(y: 50)
                                HStack{
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                    Text("\(book.rating.formatted())")
                                }
                                .font(.subheadline)
                                .padding(8)
                                .background(in: RoundedRectangle(cornerRadius: 20))
                                .offset(x: 50, y: -110)
                            }
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .frame(width: 200,alignment:.leading)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                                Text("\(book.reviews) reviews")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(height: 400)
                        .clipped()
                        .scaleEffect(selectedBook?.id == book.id ? 0.9 : 1.0)
                        .onLongPressGesture(perform: {
                            withAnimation {
                                selectedBook = book
                            }
                        }) { isPress in
                            if !isPress{
                                withAnimation {
                                    selectedBook = nil
                                    vm.selectedBook = book
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}

