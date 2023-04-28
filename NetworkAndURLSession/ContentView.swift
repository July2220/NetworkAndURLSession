//
//  ContentView.swift
//  NetworkAndURLSession
//
//  Created by july on 2023/4/27.
//

import SwiftUI

//class User: ObservableObject, Codable {
//    enum CodingKeys: CodingKey {
//        case name
//
//    }
//    var name = "Paul Hudson"
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        name = try container.decode(String.self, forKey: .name)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy:CodingKeys.self)
//        try container.encode(name, forKey: .name)
//    }
//}


struct ContentView: View {
    @StateObject var order = Order() //new empty order
    
    var body: some View {
        NavigationStack{
            Form {
                Section{
                    Picker("Select your cake type",selection: $order.type) {
                        ForEach(Order.types.indices){
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.quantity)",value: $order.quantity,in: 3...20)
                }
                
                Section {
                    Toggle("Any special request",isOn: $order.specialRequestEnabled.animation())
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting",isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles",isOn: $order.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Deliver Address")
                    }
                }
                
            }
            .navigationTitle("Cupcake Corner")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
