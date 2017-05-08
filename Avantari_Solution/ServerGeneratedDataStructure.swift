//
//  ServerGeneratedDataStructure.swift
//  Avantari_Solution
//
//  Created by pranav gupta on 08/05/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import Foundation

class ServerData: NSObject, NSCoding {
    let time : String
    let number : Int
    
    
    init(time: String, number : Int){

        self.time = time
        self.number = number
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.time = (aDecoder.decodeObject(forKey: "time") as? String)!
        self.number = Int(aDecoder.decodeCInt(forKey: "number"))
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(time,forKey:"time")
        aCoder.encodeCInt(Int32(number), forKey: "number")
        
        
    }
}




