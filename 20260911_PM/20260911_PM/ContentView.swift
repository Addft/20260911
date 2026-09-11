//
//  ContentView.swift
//  20260911_PM
//
//  Created by competitor on 2026/9/11.
//

import SwiftUI

struct ContentView: View {
    @State var vm=VM()
    var body: some View {
        VStack {
            if let _ = vm.selectedHotel{
                DetailView(vm: vm)
            }else{
                switch vm.page {
                case .home:
                    HomeView(vm: vm)
                case .tickets:
                    TicketView(vm: vm)
                }
            }
        }
        .padding()
    }
}
struct TicketView: View {
    @Bindable var vm:VM
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        vm.page = .home
                    }
                Text("My bookings")
                Spacer()
            }
            .font(.headline)
            if vm.tickets.isEmpty{
                Text("No Tickets ")
                Spacer()
            }else{
                List(vm.tickets.enumerated(),id: \.offset){i, t in
                    HStack{
                        Text("\(i+1)")
                            .font(.title.bold())
                        VStack(alignment: .leading) {
                            Text("\(t.firstNm) \(t.lastNm)")
                                .font(.headline)
                            Text(t.hotelNm)
                                .font(.subheadline.bold())
                            Text("\(t.checkInDate.toStr) to \(t.checkOutDate.toStr)")
                            Text("\(t.adultNo) adults, \(t.kidNo) children, \(t.rmNo) Room".capitalized)
                            HStack{
                                Text("For \(t.travelFor.rawValue) Pay with \(t.payment.rawValue)")
                            }
                        }
                        
                        Spacer()
                        Text("€ \(t.price)")
                            .font(.title2.bold())
                    }
                    .font(.footnote)
                }
            }
        }
    }
}
struct DetailView: View {
    @Bindable var vm:VM
    @State var tabs: Tabs = .review
    @State var selectedRm: Room?
    var hotelDetail: HotelDetail{
        return vm.hotelDetails.first(where: {$0.hotel_id == vm.selectedHotel?.hotel_id ?? 0}) ?? HotelDetail(hotel_id: 0, hotel_name: "", guest_reviews: GuestReview(ratings_categories: [], reviews_objects: []), rooms: [])
    }
    enum Tabs: String, CaseIterable{
        case review = "guest reviews"
        case book = "room selection"
    }
    var body: some View {
        VStack(alignment: .center){
            ScrollView(.vertical,showsIndicators: false){
                HStack{
                    Image(systemName: "chevron.left")
                        .onTapGesture {
                            if selectedRm != nil{
                                selectedRm = nil
                            }else{
                                vm.selectedHotel = nil
                            }
                        }
                    Text(selectedRm != nil ? "Booking Confirm" : "Booking")
                    Spacer()
                }
                .bold()
                Divider()
                if selectedRm != nil{
                    HStack{
                        Text("You are going to reserve: ")
                            .font(.headline)
                        Spacer()
                    }
                }else{
                    Picker("",selection: $tabs){
                        ForEach(Tabs.allCases,id: \.self){ tab in
                            Text(tab.rawValue.capitalized)
                                .tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Text(vm.selectedHotel?.hotel_name ?? "")
                    .font(.title2.bold())
                    .padding()
                
                if let rm = selectedRm{
                    FormView(vm: vm, room: rm)
                        .onDisappear{
                            selectedRm=nil
                        }
                }else{
                    switch tabs {
                    case .review:
                        reviewView
                    case .book:
                        selectionView
                    }
                }
            }
        }
    }
    var selectionView: some View{
        VStack(alignment: .leading,spacing: 20){
            Text("Rooms")
                .font(.title2.bold())
            
            ForEach(hotelDetail.rooms){rm in
                VStack(alignment: .leading){
                    Text(rm.room_type)
                        .font(.headline)
                    Text("Bed: \(rm.room_bed_type), Total number of guest: \(rm.room_total_number_of_guests)")
                        .font(.footnote)
                    HStack{
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(rm.room_features,id: \.self){ feature in
                                Text(feature)
                                    .font(.footnote)
                            }
                        }
                        .padding(8)
                        .frame(width: 250)
                        .border(.secondary)
                        Spacer()
                        Text("€ \(rm.room_price_for_one_night)")
                            .font(.title2.bold())
                    }
                }
                .padding()
                .border(.secondary)
                .onTapGesture {
                    selectedRm = rm
                }
            }
        }
        .padding(8)
    }
    var reviewView: some View{
        VStack(spacing: 20){
            VStack(alignment: .leading) {
                Text("ratings".capitalized)
                    .font(.title2.bold())
                let cates = hotelDetail.guest_reviews.ratings_categories.compactMap({$0.first})
                    .sorted(by: {$0.key<$1.key})
                
                ForEach(cates,id: \.key){ cate in
                    VStack{
                        HStack{
                            Text(cate.key)
                            Spacer()
                            Text(cate.value.toStr)
                        }
                        ProgressView(value: cate.value, total: 10.0)
                    }
                }
            }
            .padding()
            .border(.secondary)
            
            VStack(alignment: .leading) {
                Text("Reviews")
                    .font(.title2.bold())
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                        ForEach(hotelDetail.guest_reviews.reviews_objects){ object in
                            VStack(alignment: .leading) {
                                HStack{
                                    ZStack{
                                        Circle()
                                            .fill(.secondary)
                                            .frame(width: 40)
                                        Text(object.username.prefix(1))
                                    }
                                    VStack(alignment: .leading){
                                        Text(object.username)
                                            .font(.headline)
                                        Text(object.country)
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Text(object.review_text)
                                    .font(.subheadline)
                                Spacer()
                            }
                            .padding()
                            .frame(width: 250,height: 300)
                            .border(.secondary)
                        }
                    }
                }
            }
        }
        .padding()
      
    }
}
struct FormView: View {
    @Bindable var vm:VM
    var room: Room
    
    @State var firstNm = ""
    @State var lastNm = ""
    @State var checkinStr = ""
    @State var checkinDate: Date?
    @State var checkoutStr = ""
    @State var checkoutDate: Date?
    @State var adult = ""
    @State var kid = ""
    @State var rmNumber = 1
    @State var price = 0
    @State var travelFor: TravelFor = .signtheeing
    @State var payment: Payment = .cash
    
    @State var isAlert = false
    @State var err = ""
    var body: some View {
        VStack(alignment: .leading){
            Text("Form")
                .font(.title3.bold())
            HStack{
                VStack(alignment: .leading){
                    Text(room.room_type)
                        .font(.headline)
                    Text("Bed: \(room.room_bed_type)\nTotal number of guest: \(room.room_total_number_of_guests)")
                        .font(.footnote)
                }
                Spacer()
                Text("€ \(room.room_price_for_one_night)")
                    .font(.title2.bold())
            }
            .padding()
            .border(.secondary)
            Group{
                HStack{
                    inputBox(section: "First Name", placeHolder: "first name", input: $firstNm)
                    inputBox(section: "Last Name", placeHolder: "last name", input: $lastNm)
                }
                HStack{
                    inputBox(section: "Check-in date", placeHolder: "check-in", input: $checkinStr)
                        .onSubmit {
                            if let date = checkinStr.toDate{
                                checkinDate = date
                            }
                        }
                    inputBox(section: "Check-out date", placeHolder: "check-out", input: $checkoutStr)
                        .onSubmit {
                            if let date = checkoutStr.toDate{
                                checkoutDate = date
                            }
                        }
                }
                HStack{
                    inputBox(section: "Adults", placeHolder: "adults", input: $adult)
                        .keyboardType(.numberPad)
                    inputBox(section: "Children", placeHolder: "childrens", input: $kid)
                        .keyboardType(.numberPad)
                    
                    VStack(alignment: .leading){
                        Text("Room")
                            .font(.headline)
                        Text("\(rmNumber)")
                            .font(.title3.bold())
                    }
                    .padding(.trailing,20)
                    .padding()
                    .border(.secondary)
                }
                VStack(alignment: .leading){
                    Text("Travel for business?")
                        .font(.headline)
                    HStack{
                        ForEach(TravelFor.allCases,id: \.self){ Tfor in
                            Spacer()
                            HStack{
                                Image(systemName: travelFor == Tfor ? "checkmark.circle.fill" : "circle")
                                if Tfor == .business{
                                    Text("+€150 \nFor \(Tfor.rawValue)")
                                }else{
                                    Text("For \(Tfor.rawValue)")
                                }
                            }
                            .onTapGesture {
                                travelFor = Tfor
                            }
                            Spacer()
                        }
                    }
                }
                .padding(8)
                .border(.secondary)
                VStack(alignment: .leading){
                    Text("Which way to pay??")
                        .font(.headline)
                    HStack(spacing: 15){
                      
                        ForEach(Payment.allCases,id: \.self){ pay in
                            HStack{
                                Image(systemName: payment == pay ? "checkmark.circle.fill" : "circle")
                                Text(pay.rawValue)
                                    .font(.footnote)
                            }
                            .padding(.horizontal,5)
                            .onTapGesture {
                                payment = pay
                            }
                        }
                        
                        Spacer()
                        
                        Text("€ \(price)")
                            .font(.title2.bold())
                        
                    }
                }
                .padding(8)
                .border(.secondary)
            }
            Button(action: {
                var isLetter = true
                for char in firstNm {
                    if char.isLetter{
                        continue
                    }else{
                        isLetter = false
                    }
                }
                for char in lastNm{
                    if char.isLetter{
                        continue
                    }else{
                        isLetter = false
                    }
                }
                guard isLetter == true else{
                    err = "first name and last name must be letter"
                    return
                }
                guard let inDate = checkinDate else {
                    err="check in date format invalid"
                    return
                }
                guard let outDate = checkoutDate else {
                    err="check out date format invalid"
                    return
                }
                
                guard let adult = Int(adult), adult > 0 else {return}
                guard let kid = Int(kid) else {return}
                guard inDate < outDate else {
                    err="check in date should ealier than check out date"
                    return
                }
                let maxKids = adult*2
                guard kid <= maxKids else {
                    err="max children number is \(maxKids)"
                    return
                }
                
                isAlert.toggle()
            }, label: {
                HStack{
                    Spacer()
                    Text("Book Now")
                    Spacer()
                }
            })
            .buttonStyle(.borderedProminent)
            .alert("Are you going to book this room?", isPresented: $isAlert, actions: {
                Button("No"){
                    isAlert.toggle()
                }
                Button("Yes"){
                    guard let inDate = checkinDate else {
                        err="check in date format invalid"
                        return
                    }
                    guard let outDate = checkoutDate else {
                        err="check out date format invalid"
                        return
                    }
                    let new = Tickets(firstNm: firstNm, lastNm: lastNm, checkInDate: inDate, checkOutDate: outDate, adultNo: Int(adult) ?? 0, kidNo: Int(kid) ?? 0, price: price,rmNo: rmNumber, travelFor: travelFor, payment: payment,hotelNm: vm.selectedHotel?.hotel_name ?? "")
                    vm.tickets.append(new)
                    vm.save()
                    
                    firstNm = ""
                    lastNm = ""
                    checkinStr = ""
                    checkinDate=nil
                    checkoutStr=""
                    checkoutDate=nil
                    adult=""
                    kid=""
                    rmNumber = 0
                    isAlert.toggle()
                    vm.selectedHotel=nil
                    vm.page = .tickets
                }
            })
        }
        
        .onAppear{
            price = room.room_price_for_one_night
        }
        .onChange(of: adult){
            updateEvryThings()
        }
        .onChange(of: kid){
            updateEvryThings()
        }
        .onChange(of: checkinDate){
            updateEvryThings()
        }
        .onChange(of: checkoutDate){
            updateEvryThings()
        }
        .onChange(of: travelFor){
            updateEvryThings()
        }
        .onChange(of: err){
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                withAnimation {
                    err = ""
                }
            })
        }
        .overlay {
            if !err.isEmpty{
                VStack{
                    Text(err)
                        .foregroundStyle(.red)
                }
                .padding()
                .background(in: RoundedRectangle(cornerRadius: 30))
                .shadow(radius: 10)
            }
        }
    }
    func updateEvryThings() {
        let ttlPpl = (Int(adult) ?? 0) + (Int(kid) ?? 0)
        let rmNeeded = Double(ttlPpl)/Double(room.room_total_number_of_guests)
        rmNumber = Int(rmNeeded.rounded(.up))
        print("\(checkinDate)")
        print("\(checkoutDate)")
        guard let inDate = checkinDate else {return}
        guard let outDate = checkoutDate else {return}
        let diff = Calendar.current.dateComponents([.day], from: inDate, to: outDate)
        guard let days = diff.day else {return}
        let baseP = days*rmNumber*room.room_price_for_one_night
        if travelFor == .business{
            price = baseP+150
        }else{
            price = baseP
        }
    }
    func inputBox(section:String, placeHolder: String, input: Binding<String>) -> some View{
        VStack(alignment: .leading,spacing: 5){
            Text(section)
                .bold()
            TextField(placeHolder, text: input)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
        }
        .padding(8)
        .border(.secondary)
    }
}

struct HomeView: View {
    @Bindable var vm:VM
    @State var search = ""
    var hotels : [Hotel]{
        if search.isEmpty{
            return vm.hotels
        }else{
            return vm.hotels.filter({$0.hotel_name.localizedCaseInsensitiveContains(search)})
        }
    }
    var body: some View {
        VStack{
            HStack{
                Text("The Apls'Hotel")
                    .font(.headline)
                Image("france_national_flag")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                Spacer()
                Image(systemName: "person")
                    .onTapGesture {
                        vm.page = .tickets
                    }
            }
            Divider()
            TextField("Search a hotel name", text: $search)
                .textFieldStyle(.roundedBorder)
            
            List{
                ForEach(hotels){ hotel in
                    HStack(alignment: .top){
                        Image(hotel.hotel_cover_image.replacingOccurrences(of: ".jpg", with: ""))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(.rect(cornerRadius: 10))
                        VStack(alignment: .leading){
                            Text(hotel.hotel_name)
                                .font(.headline)
                            HStack{
                                Text(hotel.hotel_rating.toStr)
                                ForEach(0..<4,id: \.self){ i in
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            }.font(.caption)
                            HStack{
                                Text("\(hotel.hotel_to_ski_distance.toStr) km from Alps'ski lift")
                                    .font(.footnote)
                                Spacer()
                                Button("Book it"){
                                    if hotel.hotel_id == 1000 || hotel.hotel_id == 1008 {
                                        vm.selectedHotel = hotel
                                    }
                                }
                                .font(.caption)
                                .buttonStyle(.borderedProminent)
                            }
                        }
                        
                    }
                }
            }
            .listStyle(.plain)
            .scrollIndicators(.hidden)
        }
    }
}
#Preview {
    ContentView()
}

extension Double{
    var toStr: String{
        return String(format: "%.1f", self)
    }
}

extension String{
    var toDate: Date?{
        let f = DateFormatter()
        let formats = [
            "MM/dd/yyyy", "MM-dd-yyyy", "MMM dd yyyy"
        ]
        for format in formats {
            f.dateFormat = format
            if let d = f.date(from: self){
                return d
            }
        }
        return nil
    }
}
extension Date{
    var toStr: String{
        let f = DateFormatter()
        f.dateFormat = "EEE, MMM dd, yyyy"
        return f.string(from: self)
    }
}
