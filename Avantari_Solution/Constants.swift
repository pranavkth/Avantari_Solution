//
//  Constants.swift
//  Avantari_Solution
//
//  Created by pranav gupta on 08/05/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//


import Foundation
import SocketIO

let defaults: UserDefaults = UserDefaults.standard
var data = [Int]()
var persistentDataGlobal = [ServerData]()
var socket = SocketIOClient(socketURL: URL(string: "http://ios-test.us-east-1.elasticbeanstalk.com/")!, config: [.log(true), .forcePolling(true), .nsp("/random")])


