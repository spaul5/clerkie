//
//  Objects.swift
//  clerkie-challenge
//
//  Created by Shouvik Paul on 11/9/18.
//

import UIKit

struct ChatUser {
    let name: String
    var image: UIImage
}

struct Message {
    let sent: Bool
    let image: UIImage?
    let text: String?
}
