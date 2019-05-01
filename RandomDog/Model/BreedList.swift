//
//  BreedList.swift
//  RandomDog
//
//  Created by 中尾 佳代 on 2019/03/26.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import Foundation

struct BreedList:Codable {
    var status:String
    var message:[String:[String]]
}
