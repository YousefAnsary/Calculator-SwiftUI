//
//  AlertData.swift
//  Calculator-SwiftUI
//
//  Created by Yousef on 4/25/21.
//

import SwiftUI

struct AlertData: Identifiable {
    
    var id: UUID = UUID()
    let title: String
    let msg: String
    
    var alert: Alert {
        Alert(title: Text(title), message: Text(msg), dismissButton: .default(Text("OK")))
    }
    
}
