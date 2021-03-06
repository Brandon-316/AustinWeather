//
//  ViewController.swift
//  Austin Weather
//
//  Created by Brandon Mahoney on 8/8/16.
//

import UIKit

class ViewController: UIViewController {
    
    var dailyWeather: DailyWeather? {
        didSet {
            configureView()
        }
    }
    
    var imageString = ""

    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var summaryLabel: UILabel?
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    @IBOutlet weak var lowTemperatureLabel: UILabel?
    @IBOutlet weak var highTemperatureLabel: UILabel?
    @IBOutlet weak var precipitationLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        backgroundImage.image = UIImage.init(named: imageString)
        
        configureView()
        
    }
    
    func configureView() {
        if let weather = dailyWeather {
            self.title = weather.day
            weatherIcon?.image = weather.icon
            summaryLabel?.text = weather.summary
            sunriseTimeLabel?.text = weather.sunriseTime
            sunsetTimeLabel?.text = weather.sunsetTime
            
            if let lowTemp = weather.minTemperature,
                let highTemp = weather.maxTemperature,
                let rain = weather.precipChance,
                let humidity = weather.humidity {
                    lowTemperatureLabel?.text = "\(lowTemp)º"
                    highTemperatureLabel?.text = "\(highTemp)º"
                    precipitationLabel?.text = "\(rain)%"
                    humidityLabel?.text = "\(humidity)%"
            }
            
            
        }
        
        // Configure nav bar back button
//        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
////            let barButtonAttributesDictionary: [String: AnyObject]? = [
//            let barButtonAttributesDictionary: [String: AnyObject]? = [
//                NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
//                NSAttributedStringKey.font.rawValue: buttonFont
//            ]
//            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, for: UIControlState())
//        }
        
        if let buttonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            //            let barButtonAttributesDictionary: [String: AnyObject]? = [
            let barButtonAttributesDictionary: [NSAttributedStringKey: Any]? = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white,
                NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): buttonFont
            ]
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, for: UIControlState())
        }
        
        // Update UI with information from the data model
//        weatherIcon?.image
    }

}

