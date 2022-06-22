
import Foundation
import UIKit

public enum CodingKeys: String, CodingKey {
    case name,driver,coins,speed,date
}

class Car: NSObject, Codable {
    var name: String
    var driver: String
    var coins: Int
    var speed: Float
    var date: String
    
    init(name: String, driver: String, coins: Int, speed: Float, date: String) {
        self.name = name
        self.driver = driver
        self.coins = coins
        self.speed = speed
        self.date = date
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.driver, forKey: .driver)
        try container.encode(self.coins, forKey: .coins)
        try container.encode(self.speed, forKey: .speed)
        try container.encode(self.date, forKey: .date)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.driver = try container.decode(String.self, forKey: .driver)
        self.coins = try container.decode(Int.self, forKey: .coins)
        self.speed = try container.decode(Float.self, forKey: .speed)
        self.date = try container.decode(String.self, forKey: .date)
    }
}
