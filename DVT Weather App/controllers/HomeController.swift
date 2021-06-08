//
//  HomeController.swift
//  DVT Weather App
//
//  Created by edwin weru on 07/06/2021.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation
import SwiftMessages

enum WeatherCondition {
    
}

class HomeController: UIViewController {

    @IBOutlet weak var lbl_displayTemp: UILabel!
    @IBOutlet weak var lbl_displayDescription: UILabel!
    
    @IBOutlet weak var lbl_minValue: UILabel!
    @IBOutlet weak var lbl_currentValue: UILabel!
    @IBOutlet weak var lbl_maxValue: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var img_cover: UIImageView!
    
    
    var locationManager:CLLocationManager!
    
    var currentLat: Double = 0.0
    var currentLng: Double = 0.0
    
    var result: Result?
    var current: Current?
    var weather: Weather?
    var temp: Temperature?
    var daily: [Daily] = []
    
    override func viewWillAppear(_ animated: Bool) {
        isLocationAccessEnabled()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        determineMyCurrentLocation()
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "ForecastViewCell", bundle: nil), forCellReuseIdentifier: "ForecastViewCell")
        tableView.rowHeight = 50
        
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        
    }

    func buildURL() -> String {
        let url = "/forecast/daily?lat=\(currentLat)&lon=\(currentLng)&cnt=\(5)&appid=\(MyConstants.URL_API_KEY)"
        let partialUrl = "/onecall?lat=" + "\(currentLat)" + "&lon=" + "\(currentLng)" + "&units=imperial" + "&appid=" + MyConstants.URL_API_KEY
        return MyConstants.URL_BASE + partialUrl
    }
    
    private func requestData () {
        
        let feedUrl = buildURL()//MyConstants.URL_SAMPLE
        
        let parameters: [String: Any] = [:]
        
        showUniversalLoadingView(true, loadingText: "Please Wait....")
        
        AF.request(feedUrl, method: .get, parameters: parameters)
            
            .responseString { [self] response in
                
                showUniversalLoadingView(false)
                switch response.result {
            
                case .success(let data):
                    
                    let json = JSON(parseJSON: data)
                    
                    result = Result(jsonObject: json)
                    
                    if let c = result?.current {
                        current = Current(jsonObject: c)
                        let celcius: Double = calculateCelsius(fahrenheit: current?.temp ?? 0.0)
                        let txt_celcius: String = String(format: "%.2f", celcius)
                        
                        lbl_displayTemp.text = "\(txt_celcius)°"
                        if let w = current?.weather{
                            weather = Weather(jsonObject: w[0])
                            //temp = Temperature(jsonObject: w[0])
                            lbl_displayDescription.text = weather?.description ?? ""
                            
                            if let main = weather?.main {
                                if main.lowercased() == "rain" {
                                    view.backgroundColor = .colorRainy
                                    img_cover.image = UIImage(named: "sea_rainy")
                                } else if main.lowercased() == "clouds" {
                                    view.backgroundColor = .colorCloudy
                                    img_cover.image = UIImage(named: "sea_cloudy")
                                }else {
                                    view.backgroundColor = .colorSunny
                                    img_cover.image = UIImage(named: "sea_sunnypng")
                                }
                            }
                            
                        }
                    }
                    
                    if let d = result?.daily {
                        daily = parseToDailyList(jsonArray: d)
                        
                        if daily[0].temp.count > 0 {
                            let tmp = Temperature(jsonObject: daily[0].temp)
                            let min = calculateCelsius(fahrenheit: tmp.min ?? 0.0)
                            let max = calculateCelsius(fahrenheit: tmp.max ?? 0.0)
                            let day = calculateCelsius(fahrenheit: tmp.day ?? 0.0)
                            
                            
                            lbl_minValue.text = String(format: "%.2f", min) + "°"
                            lbl_maxValue.text = String(format: "%.2f", max) + "°"
                            lbl_currentValue.text = String(format: "%.2f", day) + "°"
                        }
                        
                        tableView.reloadData()
                        print("count of daily is \(daily.count)")
                    }
                    
                    print("json is \(json)")
                    
                case .failure(let error):
                    
                    print("Falure code ", error)
                } // end of switch
                
        }
        
    }
    
    func parseToDailyList(jsonArray: JSON) -> [Daily] {
        
        var itemList: [Daily] = []
        
        //print("start of parsing")
        
        if let tempArray = jsonArray.array {
            
            for i in 0 ..< tempArray.count  {
                
                let ab: JSON = tempArray[i]
                let item: Daily = Daily(jsonObject: ab)
                
                itemList.append(item)
            }
            
        }
        
        return itemList
    }
    
    func calculateCelsius(fahrenheit: Double) -> Double {
        var celsius: Double
        
        celsius = (fahrenheit - 32) * 5 / 9
        
        return celsius
    }

    func calculateFahrenheit(celsius: Double) -> Double {
        var fahrenheit: Double
        
        fahrenheit = celsius * 9 / 5 + 32
        
        return fahrenheit
    }
    
    // an overlay for loader
    func showUniversalLoadingView(_ show: Bool, loadingText : String = "") {
        
        let existingView = UIApplication.shared.windows[0].viewWithTag(1200)
        if show {
            if existingView != nil {
                return
            }
            let loadingView = makeLoadingView(withFrame: UIScreen.main.bounds, loadingText: loadingText)
            loadingView?.tag = 1200
            UIApplication.shared.windows[0].addSubview(loadingView!)
        } else {
            existingView?.removeFromSuperview()
        }

    }
    
    func makeLoadingView( withFrame frame: CGRect, loadingText text: String?) -> UIView? {
        
        let loadingView = UIView(frame: frame)
        loadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = loadingView.center
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
            activityIndicator.style = .whiteLarge
        }
        activityIndicator.startAnimating()
        activityIndicator.tag = 100 // 100 for example

        loadingView.addSubview(activityIndicator)
        if !text!.isEmpty {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
            let cpoint = CGPoint(x: activityIndicator.frame.origin.x + activityIndicator.frame.size.width / 2, y: activityIndicator.frame.origin.y + 80)
            lbl.center = cpoint
            lbl.textColor = UIColor.white
            lbl.textAlignment = .center
            lbl.text = text
            lbl.numberOfLines = 2
            lbl.tag = 1234
            loadingView.addSubview(lbl)
        }
        
        return loadingView
    }
    
}

//MARK:-
extension HomeController: CLLocationManagerDelegate {
    
    private func showLocationAlert() {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "Hey There!", body: "Please enable Location Settings for the App, Otherwise it won't work as expected", iconImage: nil, iconText: "🤔", buttonImage: nil, buttonTitle: "Okay") { _ in
            SwiftMessages.hide()
            if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }
    
    func isLocationAccessEnabled() {
       if CLLocationManager.locationServicesEnabled() {
        
          switch CLLocationManager.authorizationStatus() {
             case .notDetermined, .restricted, .denied:
                print("Location Status: No access")
                self.showLocationAlert()
                
             case .authorizedAlways, .authorizedWhenInUse:
                print("Location Status: Access")
          @unknown default:
            print("Location Status: Unknown location status")//fatalError()
            
            self.showLocationAlert()
          }
        
       } else {
          print("Location Status: Location services not enabled")
          self.showLocationAlert()
       } // else
    }
    
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        manager.stopUpdatingLocation()
        self.currentLat = userLocation.coordinate.latitude
        self.currentLng = userLocation.coordinate.longitude
        
        print("user latitude = \(currentLat)")
        print("user longitude = \(currentLng)")
        
        requestData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}

//MARK:-
extension HomeController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return daily.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastViewCell", for: indexPath) as! ForecastViewCell
  
        cell.backgroundColor = .clear
        
        let row = indexPath.row
        let currentItem: Daily = daily[row]
        
        let w_json = currentItem.weather[0]
        let day_weather: Weather = Weather(jsonObject: w_json)
        let tmp = Temperature(jsonObject: currentItem.temp)
        
        let main = day_weather.main
        
        if main.lowercased() == "rain" {
            cell.img_icon.image = UIImage(named: "rain")
        } else if main.lowercased() == "clouds" {
            cell.img_icon.image = UIImage(named: "AccentColor")
        }else {
            cell.img_icon.image = UIImage(named: "partlysunny")
        }
        
        if let weekDate = currentItem.dt {
            let dateFormatter = DateFormatter()
            let date = Date(timeIntervalSinceNow: TimeInterval(weekDate))
            //dateFormatter.locale = Locale(identifier: "en_US")
            dateFormatter.setLocalizedDateFormatFromTemplate("EEE dd") // set template after setting locale
            //print(dateFormatter.string(from: date))
            cell.lbl_day.text = dateFormatter.string(from: date)
        } else {
            cell.lbl_day.text = "No data"
        }
        
        let day = calculateCelsius(fahrenheit: tmp.day ?? 0.0)
        cell.lbl_weather.text = String(format: "%.2f", day) + "°"
        
        return cell
        
    }
    
}
