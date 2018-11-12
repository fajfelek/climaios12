//
//  ForecastVieController.swift
//  Clima
//
//  Created by Filip Stajniak on 10/11/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForecastViewController : UIViewController {
    
    let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast"
    let APP_ID = "93b176bf01f1d4b2bb88042a81f832cc"
    
    var currentTemp: String = ""
    var currentCityName: String = ""
    var currentDay = [JSON]()
    var nextDays = [JSON]()
    
    var weatherID = [Int]()
    var temp = [Double]()
    var pressure = [Double]()
    var windSpeed = [Double]()
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        tempLabel.text = currentTemp
        cityLabel.text = currentCityName
        let params : [String : String] = ["q" : currentCityName, "appid" : APP_ID]
        getWeatherData(url: FORECAST_URL, parameters: params)
    }
    
    @IBAction func powrotButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String : String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! Got the weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.parseJSONdata(json: weatherJSON)
                
                
            } else {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func getDate(seconds: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: (Date() + TimeInterval(seconds)))
    }
    
    func parseJSONdata(json : JSON) {
        var dataNumber : Int = json["cnt"].int!
        for item in json["list"].arrayValue{
            if item["dt_txt"].description.prefix(10) == getDate(seconds: 0){
                currentDay.append(item)
            } else {
                nextDays.append(item)
            }
        }
        //print(currentDay.count)
        //print(nextDays.count)
        prepareTableViewData()
    }
    
    func prepareTableViewData() {
        
        for item in currentDay {
            if item["dt_txt"].description.prefix(13) == (getDate(seconds: 0) + " 12"){
                temp.append(item["main"]["temp"].double!)
                pressure.append(item["main"]["pressure"].double!)
                windSpeed.append(item["wind"]["speed"].double!)
                //weatherID.append(item["weather"]["id"].int!)
                continue
            } else {
                temp.append(item["main"]["temp"].double!)
                pressure.append(item["main"]["pressure"].double!)
                windSpeed.append(item["wind"]["speed"].double!)
                //weatherID.append(item["weather"]["id"].int!)
                continue
            }
        }
        //86400
        for i in 1...4 {
                for item in nextDays {
                    print(item["dt_txt"].description.prefix(13))
                    if item["dt_txt"].description.prefix(13) == (getDate(seconds: (i*86400)) + " 12"){
                        temp.append(item["main"]["temp"].double!)
                        pressure.append(item["main"]["pressure"].double!)
                        windSpeed.append(item["wind"]["speed"].double!)
                        //weatherID.append(item["weather"]["id"].int!)
                }
            }
        }
        printData()

    }
        func printData() {
            print(temp.count)
            print(pressure.count)
            print(windSpeed.count)
            for i in 0..<temp.count {
                print(temp[i])
                print(pressure[i])
                print(windSpeed[i])
                //print(weatherID[i])
            }
        }
    
}
