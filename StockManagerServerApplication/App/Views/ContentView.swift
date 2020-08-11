//
//  ContentView.swift
//  StockManagerServerApplication
//
//  Created by Zachary Grimaldi on 8/10/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Hello, world!")
            .padding()
            
            Button("Test Endpoints"){
                self.testHelloEndpoint()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
