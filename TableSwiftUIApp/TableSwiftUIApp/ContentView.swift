//
//  ContentView.swift
//  TableSwiftUIApp
//
//  Created by derrick muonaka on 3/25/26.
//

import SwiftUI
import MapKit


let data = [
Item(name: "Pepe's Tacos", neighborhood: "Downtown", category: "Mexican", desc: "This food truck offers delicious birria tacos served with a warm consomme.", address: "704 N. Lamar", lat: 30.273320, long: -97.753550,  imageName: "rest1"),
Item(name: "Biscuits + Groovy", neighborhood: "Hyde Park", category: "Breakfast", desc: "Groovy little neighborhood truck serving up biscuits in a variety of styles.", address: "5015 Duval St.", lat: 30.313960, long: -97.719760, imageName: "rest2"),
Item(name: "Veracruz All Natural", neighborhood: "Mueller", category: "Mexican", desc: "This is one of many locations for the beloved taco mavens of Austin.", address: "1905 Aldrich St.", lat: 30.2962244, long: -97.7079799, imageName: "rest3"),
Item(name: "Vaquero Taquero", neighborhood: "UT", category: "Mexican", desc: "Delicious tacos with a convenient walk up window. ", address: "104 E. 31st St.", lat: 30.295190, long: -97.736540, imageName: "rest4"),
Item(name: "Uncle Nicky's", neighborhood: "Hyde Park", category: "Italian", desc: "Serving up Italian specialties and drinks.", address: "4222 Duval St.", lat: 30.304890, long: -97.726220, imageName: "rest5")
]

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let neighborhood: String
    let category: String
    let desc: String
    let address: String
    let lat: Double
    let long: Double
    let imageName: String
}

struct ContentView: View {
// initialize variables for Map in List View abd set zoom and centering location
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.295190, longitude: -97.726220),
            span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07)
        )
    )
    
    let categories = ["All"] + Array(Set(data.map { $0.category })).sorted()
       @State private var selectedCategory = "All"

       var filteredData: [Item] {
           if selectedCategory == "All" {
               return data
           } else {
               return data.filter { $0.category == selectedCategory }
           }
       } // end filteredData
    
    
var body: some View {
    NavigationView {
    VStack {
    Picker("Category", selection: $selectedCategory) {
          ForEach(categories, id: \.self) { category in
              Text(category).tag(category)
          }
      } // end Picker
      .pickerStyle(.menu)
      .padding()

        List(filteredData, id: \.name) { item in
            NavigationLink(destination: DetailView(item: item)) {
                HStack {
                    Image(item.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.category)
                            .font(.subheadline)
                        Text(item.neighborhood)
                            .font(.subheadline)
                    } // end internal VStack
                } // end HStack
            } // end NavigationLink
        } // end List
    
// Map code inserted after list
Map(position: $mapPosition) {
    ForEach(data) { item in
        Annotation(item.name, coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.red)
                .font(.title)
                .overlay(
                    Text(item.name)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .fixedSize(horizontal: true, vertical: false)
                        .offset(y: 25)
                )
        }
    }
} // end Map
.frame(height: 300)
.padding(.bottom, -30)
            
            
        } // end VStack
        .listStyle(PlainListStyle())
             .navigationTitle("Austin Restaurants")
         } // end NavigationView
    } // end body
}


struct DetailView: View {
// initialize variables for Map in Detail View abd set zoom and centering on specific item
    @State private var mapPosition: MapCameraPosition
         
init(item: Item) {
self.item = item
        _mapPosition = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long),
                    span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20)
                )
            )
        )
}
        
let item: Item
               
var body: some View {
VStack {
   Image(item.imageName)
       .resizable()
       .aspectRatio(contentMode: .fit)
       .frame(maxWidth: 200)
   Text("Neighborhood: \(item.neighborhood)")
       .font(.subheadline)
   Text("Category: \(item.category)")
       .font(.subheadline)
       
   Text((item.address))
       .font(.subheadline)
       .frame(maxWidth: .infinity, alignment: .leading)
       .padding()
   Text("Description: \(item.desc)")
       .font(.subheadline)
       .padding(10)
               
//Map code in Detail View
Map(position: $mapPosition) {
    Annotation(item.name, coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)) {
        Image(systemName: "mappin.circle.fill")
            .foregroundColor(.red)
            .font(.title)
            .overlay(
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .fixedSize(horizontal: true, vertical: false)
                    .offset(y: 25)
            )
    }
} // end Map
    .frame(height: 300)
    .padding(.bottom, -60)
    Spacer()
           
    } // end VStack
    .navigationTitle(item.name)
   
        } // end body
     } // end DetailView
   

#Preview {
    ContentView()
}
