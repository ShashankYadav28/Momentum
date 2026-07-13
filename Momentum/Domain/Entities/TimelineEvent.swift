//
//  TimelineEvent.swift
//  Momentum
//
//  Created by Shashank Yadav on 13/07/26.
//

import Foundation

struct TimelineEvent: Identifiable {
    
    let id = UUID()
    var title:String
    var description:String?
    var dueDate: Date?
    var link: URL?
    
}
