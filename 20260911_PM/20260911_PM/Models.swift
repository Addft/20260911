//
//  Models.swift
//  20260911_PM
//
//  Created by competitor on 2026/9/11.
//

import Foundation
struct Hotel: Codable,Identifiable{
    var hotel_id: Int
    var hotel_name: String
    var hotel_rating: Double
    var hotel_to_ski_distance: Double
    var hotel_cover_image: String
    var id:Int{hotel_id}
}
struct HotelDetail: Codable{
    var hotel_id: Int
    var hotel_name: String
    var guest_reviews: GuestReview
    var rooms: [Room]
    
}

struct GuestReview: Codable{
    var ratings_categories: [[String: Double]]
    var reviews_objects: [ReviewObject]
}
struct ReviewObject: Codable,Identifiable{
    var username: String
    var country: String
    var review_text: String
    var id: String {username}
}
struct Room: Codable,Identifiable{
    var room_id: Int
    var room_type: String
    var room_bed_type: String
    var room_total_number_of_guests: Int
    var room_features: [String]
    var room_price_for_one_night: Int
    var id: Int{room_id}
}
struct Tickets: Codable,Identifiable{
    var id = UUID()
    var firstNm: String
    var lastNm: String
    var checkInDate: Date
    var checkOutDate: Date
    var adultNo: Int
    var kidNo: Int
    var price: Int
    var rmNo: Int
    var travelFor: TravelFor
    var payment: Payment
    var hotelNm: String
}
enum Payment: String,CaseIterable,Codable{
    case cash = "Cash"
    case credit = "Credit card"
    case epay = "E-Pay"
}
enum TravelFor: String, CaseIterable, Codable{
    case signtheeing
    case business = "business with a meeting room"
}
@Observable
class VM{
    var page: Page = .home
    var hotels = [Hotel]()
    var hotelDetails = [HotelDetail]()
    var selectedHotel: Hotel?
    var tickets = [Tickets]()
    
    init(){
        if let u = Bundle.main.url(forResource: "hotels", withExtension: "json"),
           let d = try? Data(contentsOf: u){
            hotels = try! JSONDecoder().decode([Hotel].self, from: d)
        }
        
        if let u = Bundle.main.url(forResource: "hotels_details.1000", withExtension: "json"),
           let d = try? Data(contentsOf: u){
            let v = try! JSONDecoder().decode(HotelDetail.self, from: d)
            hotelDetails.append(v)
        }
        
        if let u = Bundle.main.url(forResource: "hotels_details.1008", withExtension: "json"),
           let d = try? Data(contentsOf: u){
            let v = try! JSONDecoder().decode(HotelDetail.self, from: d)
            hotelDetails.append(v)
        }
        
        if let d = UserDefaults.standard.data(forKey: "data"),
           let v = try? JSONDecoder().decode([Tickets].self, from: d){
            tickets = v
        }
    }
    
    func save() {
        if let v = try? JSONEncoder().encode(tickets){
            UserDefaults.standard.set(v, forKey: "data")
        }
    }
}

enum Page: String,CaseIterable{
    case home, tickets
}
