//
//  weatherData.swift
//  temp
//
//  Created by harsh yadav on 29/12/20.
//

import Foundation

struct WeatherData: Codable {
    let name : String 
    let main : Main
    var weather : [Weather]
    
}

struct Main : Codable {
    let temp : Double
    let humidity : Int
}

struct Weather : Codable {
    let description : String
    let id : Int
    
}
