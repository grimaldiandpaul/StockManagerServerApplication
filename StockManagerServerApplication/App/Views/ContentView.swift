//
//  ContentView.swift
//  StockManagerServerApplication
//
//  Created By Zachary Grimaldi and Joseph Paul on 8/10/20.
//

import SwiftUI

struct ContentView: View {
    
    @State var logs: [Log] = []
    
    var sortedLogs: [String] {
        return self.logs.sorted(by: {$0.time > $1.time}).map({$0.output})
    }
    
    var body: some View {
        VStack{
            HStack {
                Text("Logs").font(.largeTitle)
                Button("Server Still Alive?") {
                    LoggingManager.log("THE SERVER IS ALIVE AND WELL!")
                }
            }
            ScrollView {
                ForEach(self.sortedLogs, id:\.self) { log in
                    HStack  {
                        Text(log)
                            .lineLimit(nil)
                        Spacer()
                    }.padding(.bottom, 5)
                }
            }
        }.onAppear {
            self.logs = LoggingManager.main.logs
            NotificationCenter.default.addObserver(forName: NSNotification.Name.newLog, object: nil, queue: .main) { (notif) in
                if let newLog = notif.userInfo?["newLog"] as? Log {
                    self.logs.append(newLog)
                }
            }
        }.padding()
        .frame(width: 500, height: 700, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
