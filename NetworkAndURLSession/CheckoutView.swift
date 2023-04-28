//
//  CheckoutView.swift
//  NetworkAndURLSession
//
//  Created by july on 2023/4/27.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    @State private var errorMessage = ""
    @State private var showingErrorAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"),scale: 3)
                { phase in
                    switch phase {
                    case .success(let image) : image.resizable().scaledToFit()
                    case .failure : Image(systemName: "photo").font(.largeTitle)
                    default: ProgressView()
                    }
                }
                .frame(height: 233)
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                Button {
                    Task {
                        await placeOrder()
                    }
                } label: {
                    Text("Place order")
                }
                
                .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!",isPresented: $showingConfirmation) {
            Button("OK"){}
        } message: {
            Text(confirmationMessage)
        }
        .alert("Notification",isPresented: $showingErrorAlert) {
            Button("Cancel") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    func placeOrder() async {
        //convert to json
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to ecode order")
            return
        }
        
        if let url = URL(string: "https://reqres.in/api/cupcakes") {
            //URLRequest doesn't fetch anything; it just describes how data should be fetched.
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            do {
                //把数据通过接口上传到服务器
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                print(data)
                //读取返回的数据
                let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
                confirmationMessage = "Your order for \(decodedOrder.quantity)* \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
                showingConfirmation = true
            } catch {
                print("checkout failed")
                errorMessage = "Your order is placed in failure.Error:\(error)"
                showingErrorAlert = true
            }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
