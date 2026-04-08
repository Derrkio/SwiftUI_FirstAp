//  ContentView.swift
//  TableSwiftUIApp
//
//  Created by derrick muonaka on 3/25/26.
//
 
import SwiftUI
import MapKit
 
 
let data = [
Item(name: "Hestia", neighborhood: "Downtown", category: "New American", desc: "Michelin-starred live-fire restaurant featuring a 13-course tasting menu cooked on a 20-foot hearth. Known for ember-roasted seafood, Texas wagyu, and an acclaimed wine program.", address: "607 W 3rd St #105", lat: 30.266762, long: -97.750074, imageName: "rest1"),
Item(name: "Olamaie", neighborhood: "Downtown", category: "Southern", desc: "Michelin-starred fine dining set inside a historic home, elevating Southern cuisine with dishes like beef tartare, gulf shrimp, and legendary honey butter biscuits.", address: "1610 San Antonio St", lat: 30.279907, long: -97.743698, imageName: "rest2"),
Item(name: "Uchi", neighborhood: "South Lamar", category: "Japanese", desc: "The James Beard Award-winning original Austin location from chef Tyson Cole. Renowned for inventive Japanese cuisine and an intimate, romantic atmosphere in a renovated bungalow.", address: "801 S Lamar Blvd", lat: 30.257539, long: -97.759796, imageName: "rest3"),
Item(name: "Barley Swine", neighborhood: "North Austin", category: "New American", desc: "Michelin One Star farm-to-table tasting menu restaurant from six-time James Beard nominee Bryce Gilmore. Seasonal, locally sourced ingredients in a rustic yet refined setting.", address: "6555 Burnet Rd #400", lat: 30.341315, long: -97.738287, imageName: "rest4"),
Item(name: "Jeffrey's", neighborhood: "Clarksville", category: "Steakhouse", desc: "An Austin institution since 1975 and a Michelin-recommended classic. Known for dry-aged steaks, caviar service, and a clubby atmosphere with an exceptional wine list.", address: "1204 W Lynn St", lat: 30.280423, long: -97.759095, imageName: "rest5")
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
// initialize variables for Map in List View and set zoom and centering location
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.275000, longitude: -97.750000),
            span: MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
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
             .navigationTitle("Austin Fine Dining")
         } // end NavigationView
    } // end body
}
 
 
struct DetailView: View {
// initialize variables for Map in Detail View and set zoom and centering on specific item
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
 
