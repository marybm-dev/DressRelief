//
//  AboutItem.swift
//  bFashionIster
//
//  Created by Mary Martinez on 1/4/17.
//  Copyright © 2017 Mary Martinez. All rights reserved.
//

import Foundation

struct AboutItem {
    var title: String
    var imageName: IconName
    var description: String?
    
    init(title: String, imageName: IconName) {
        self.title = title
        self.imageName = imageName
    }
    
    static func all() -> [AboutItem] {
        var version = AboutItem(title: "Version", imageName: .version)
        let feedback = AboutItem(title: "Feedback", imageName: .feedback)
        let icons8 = AboutItem(title: "Icons8", imageName: .icons8)
        
        version.description = "1.1"
        
        return [version, feedback, icons8]
    }
}
