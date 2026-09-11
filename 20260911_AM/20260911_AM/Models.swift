//
//  Models.swift
//  20260911_AM
//
//  Created by competitor on 2026/9/11.
//

import Foundation
import SwiftUI
struct Book: Codable,Identifiable{
    var id: String
    var title: String
    var author: String
    var rating: Double
    var reviews: Int
    var tags: [String]
    var description: String
    var previewPages: [String]?
    var totalPages: Int
    var publishingDate: String
    var isEditorPick: Bool?
}
struct BookRoot: Codable{
    var books : [Book]
    var fanArt: [FanArt]
}

struct FanArt: Codable,Identifiable{
    var id: String
    var bookId: String
    var likes:Int
    var shares:Int
    var artist: String
    var createdAt: String
    var width: Double
    var height: Double
}

var accent: LinearGradient{
    return  LinearGradient(colors: [.indigo, .purple], startPoint: .topLeading, endPoint: .bottom)
}

@Observable
class VM{
    var books = [Book]()
    var fanArts = [FanArt]()
    
    var selectedBook: Book?
    init(){
        if let u = Bundle.main.url(forResource: "data", withExtension: "json"),
           let d = try? Data(contentsOf: u){
            let v = try! JSONDecoder().decode(BookRoot.self, from: d)
            books = v.books
            fanArts = v.fanArt
        }
    }
}

