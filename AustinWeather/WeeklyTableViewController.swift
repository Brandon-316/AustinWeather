//
//  WeeklyTableViewController.swift
//  Austin Weather
//
//  Created by Brandon Mahoney on 8/8/16.
//

import UIKit

class WeeklyTableViewController: UITableViewController {
    
    var count = 0
    
    var images = [
        "Austonian",
        "BobMarley",
        "DowntownKayak",
        "Longhorn",
        "PricklyPear",
        "UTTower"
    ]

    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentWeatherIcon: UIImageView?
    @IBOutlet weak var currentPrecipitationLabel: UILabel?
    @IBOutlet weak var currentTemperatureRangeLabel: UILabel?
    
    // Location coordinates
    let coordinate: (lat: Double, lon: Double) = (30.2672,-97.7431)
//    let coordinate: (lat: Double, lon: Double) = (37.8267,-122.423)
    
    // TODO: Enter your API key here
    fileprivate let forecastAPIKey = "ad38ddfe192834becf4958f622ec2330"
    
    var weeklyWeather: [DailyWeather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        addBackgroundImage()
        
        retrieveWeatherForecast()
        
        images = images.shuffle
    }
    
    
    func configureView() {
        // Set table view's background view property
        tableView.backgroundView = BackgroundView()
        
        
        // Set custom height for table view row
        tableView.rowHeight = 64
        
        // Change the font and size of nav bar text
//        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
////            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
//            let navBarAttributesDictionary: [String: AnyObject]? = [
//                NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
//                NSAttributedStringKey.font.rawValue: navBarFont
//            ]
//            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
//        }
        
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0) {
            //            let navBarAttributesDictionary: [NSObject: AnyObject]? = [
            let navBarAttributesDictionary: [NSAttributedStringKey: Any]? = [
                NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white,
                NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): navBarFont
            ]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        // Position refresh control above background view
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.white
    }
    
    func addBackgroundImage() {
        let background = tableView.backgroundView
        
        let image = UIImageView.init(image: UIImage.init(named: "Capitol"))
        image.contentMode = .scaleAspectFill
        
        let visualEffect = UIVisualEffectView()
        visualEffect.effect = UIBlurEffect(style: .dark)
        visualEffect.contentMode = .scaleAspectFill
        visualEffect.frame = CGRect.init(x: 0, y: 64, width: tableView.frame.width, height: tableView.frame.height - 64)
        
        visualEffect.alpha = 0.2
        
        image.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height - 64)
        visualEffect.contentView.addSubview(image)
        background?.addSubview(visualEffect)
    }

    @IBAction func refreshWeather() {
        retrieveWeatherForecast()
        refreshControl?.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDaily" {
            let vc = segue.destination as! ViewController
            let imageString = getImage()
            vc.imageString = imageString
            if let indexPath = tableView.indexPathForSelectedRow {
                let dailyWeather = weeklyWeather[indexPath.row]
                (segue.destination as! ViewController).dailyWeather = dailyWeather
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return weeklyWeather.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! DailyWeatherTableViewCell
        let dailyWeather = weeklyWeather[indexPath.row]
        if let maxTemp = dailyWeather.maxTemperature {
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        cell.weatherIcon.image = dailyWeather.icon
        cell.dayLabel.text = dailyWeather.day
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 170/255.0, green: 131/255.0, blue: 224/255.0, alpha: 1.0)
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            header.textLabel!.textColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        cell?.selectedBackgroundView = highlightView
    }
    
    
    // MARK: - Weather Fetching
    
    func retrieveWeatherForecast() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, lon: coordinate.lon) {
            (forecast) in
            
            if let weatherForecast = forecast,
                let currentWeather = weatherForecast.currentWeather {
                
                DispatchQueue.main.async {
                    
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                    }
                    
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "Rain: \(precipitation)%"
                    }
                    
                    if let icon = currentWeather.icon {
                        self.currentWeatherIcon?.image = icon
                    }
                    
                    self.weeklyWeather = weatherForecast.weekly
                    
                    if let highTemp = self.weeklyWeather.first?.maxTemperature,
                        let lowTemp = self.weeklyWeather.first?.minTemperature {
                            self.currentTemperatureRangeLabel?.text = "↑\(highTemp)º↓\(lowTemp)º"
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getImage() -> String {
        let imageString = images[count]
        
        if count == images.count - 1 {
            count = 0
        } else {
            count += 1
        }
        return imageString
    }
}
