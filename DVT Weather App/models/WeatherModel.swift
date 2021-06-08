//
//  File.swift
//  DVT Weather App
//
//  Created by edwin weru on 07/06/2021.
//

import Foundation
import SwiftyJSON

class Result {
    
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let current: JSON?
    var hourly: JSON?
    var daily: JSON?
    
    init (jsonObject: JSON) {
        
        self.lat = jsonObject["lat"].doubleValue;
        self.lon = jsonObject["lon"].doubleValue;
        self.timezone = jsonObject["timezone"].stringValue;
        self.current = jsonObject["current"];
        self.hourly = jsonObject["hourly"];
        self.daily = jsonObject["daily"];
        
    }
    
}

class Current {
    
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Double?
    let feels_like: Double?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let uvi: Double?
    let clouds: Int?
    let wind_speed: Double?
    let wind_deg: Int?
    let weather: JSON?
    
    init (jsonObject: JSON) {
        
        self.dt = jsonObject["dt"].intValue;
        self.sunrise = jsonObject["sunrise"].intValue;
        self.sunset = jsonObject["sunset"].intValue;
        self.temp = jsonObject["temp"].doubleValue;
        self.feels_like = jsonObject["feels_like"].doubleValue;
        self.pressure = jsonObject["pressure"].intValue;
        self.humidity = jsonObject["humidity"].intValue;
        self.dew_point = jsonObject["dew_point"].doubleValue;
        self.uvi = jsonObject["uvi"].doubleValue;
        self.clouds = jsonObject["clouds"].intValue;
        self.wind_speed = jsonObject["wind_speed"].doubleValue;
        self.wind_deg = jsonObject["wind_deg"].intValue;
        self.weather = jsonObject["weather"];
        
    }
}

class Weather {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    init (jsonObject: JSON) {
        
        self.id = jsonObject["id"].intValue;
        self.main = jsonObject["main"].stringValue;
        self.description = jsonObject["description"].stringValue;
        self.icon = jsonObject["icon"].stringValue;
        
    }
}

class Hourly {
    let dt: Int?
    let temp: Double?
    let feels_like: Double?
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let clouds: Int?
    let wind_speed: Double?
    let wind_deg: Int?
    let weather: JSON?
    
    init (jsonObject: JSON) {
        
        self.dt = jsonObject["dt"].intValue;
        self.temp = jsonObject["temp"].doubleValue;
        self.feels_like = jsonObject["feels_like"].doubleValue;
        self.pressure = jsonObject["pressure"].intValue;
        self.humidity = jsonObject["humidity"].intValue;
        self.dew_point = jsonObject["dew_point"].doubleValue;
        self.clouds = jsonObject["clouds"].intValue;
        self.wind_speed = jsonObject["wind_speed"].doubleValue;
        self.wind_deg = jsonObject["wind_deg"].intValue;
        self.weather = jsonObject["weather"];
        
    }
}

class Daily {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: JSON
    let feels_like: JSON
    let pressure: Int?
    let humidity: Int?
    let dew_point: Double?
    let wind_speed: Double?
    let wind_deg: Int?
    let weather: JSON
    let clouds: Int?
    let uvi: Double?
    
    init (jsonObject: JSON) {
        
        self.dt = jsonObject["dt"].intValue;
        self.sunrise = jsonObject["sunrise"].intValue;
        self.sunset = jsonObject["sunset"].intValue;
        self.temp = jsonObject["temp"];
        self.feels_like = jsonObject["feels_like"];
        self.pressure = jsonObject["pressure"].intValue;
        self.humidity = jsonObject["humidity"].intValue;
        self.dew_point = jsonObject["dew_point"].doubleValue;
        self.wind_speed = jsonObject["wind_speed"].doubleValue;
        self.wind_deg = jsonObject["wind_deg"].intValue;
        self.weather = jsonObject["weather"];
        self.clouds = jsonObject["clouds"].intValue;
        self.uvi = jsonObject["uvi"].doubleValue;
        
    }
}

class Temperature {
    
    let day: Double?
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
    
    init (jsonObject: JSON) {
        
        self.day = jsonObject["day"].doubleValue;
        self.min = jsonObject["min"].doubleValue;
        self.max = jsonObject["max"].doubleValue;
        self.night = jsonObject["night"].doubleValue;
        self.eve = jsonObject["eve"].doubleValue;
        self.morn = jsonObject["morn"].doubleValue;
        
    }
}

class Feels_Like {
    
    let day: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
    
    init (jsonObject: JSON) {
        
        self.day = jsonObject["day"].doubleValue;
        self.night = jsonObject["night"].doubleValue;
        self.eve = jsonObject["eve"].doubleValue;
        self.morn = jsonObject["morn"].doubleValue;
        
    }
}
