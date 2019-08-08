//
//  ForecastService.swift
//  Austin Weather
//
//  Created by Brandon Mahoney on 8/8/16.
//

import Foundation

struct ForecastService {
    
    let forecastAPIKey: String
    let forecastBaseURL: URL?
    
    init(APIKey: String) {
        forecastAPIKey = "ad38ddfe192834becf4958f622ec2330"
        forecastBaseURL = URL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast(_ lat: Double, lon: Double, completion: @escaping ((Forecast?) -> Void)) {
        
        if let forecastURL = URL(string: "\(lat),\(lon)", relativeTo: forecastBaseURL) {
            let networkOperation = NetworkOperation(url: forecastURL)
            
            networkOperation.downloadJSONFromURL {
                (JSONDictionary) in
                let forecast = Forecast(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
        } else {
            print("Could not construct a valid URL")
        }
    }
}
