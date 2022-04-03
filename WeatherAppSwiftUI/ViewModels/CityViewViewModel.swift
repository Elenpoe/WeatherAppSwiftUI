//
//  CityViewViewModel.swift
//  WeatherAppSwiftUI
//
//  Created by Helen Poe on 07.03.2022.
//

import SwiftUI
import CoreLocation

//nablyudenie za izmeneniyami, kogda oni proishodyat.kogda bi oni ne proishodili, API vozvrawaet otvet vporyadke.
final class CityViewViewModel: ObservableObject {
    @Published var weather = WeatherResponse.empty()
    @Published var city: String = "San Francisco"{
        didSet{
            //nabor data kotorue bedyt vuzuvat func kotoraya polychit mestopolojenie (call get location here) getLocation()
        }
    }
    // sozdanie formatirovwika (peregon iz originalnogo tipa dannuh v nyjnui formatirovanui)
    // sredstvo formatirovaniya datu
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    //sredstvo formatirovaniya dnya
    private lazy var dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE" // format datu - vozvrat 3h bykv dnya
        return formatter
    }()
    //sredstvo formatirovanoya vremeni
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        return formatter
    }()
    
    init(){
        //call get location - getLocation()
        getLocation()
    }
    
    //vozvrawaem datu
    var date: String{
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.current.dt)))
    }
    var weatherIcon: String {
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].icon
        }
        return "dayClearSky"
    }
    
    var temperature: String {
        return getTempFor(temp: weather.current.temp)
    }
    // vspomagatelnaya func kotoraya daet temperatyry
    func getTempFor(temp:Double) -> String {
        return String(format: "%0.1f", temp)
    }
    
    // ysloviya
    var conditions: String{
        if weather.current.weather.count > 0 {
            return weather.current.weather[0].main
        }
        return ""
    }
    //
    var windSpeed: String {
        return String(format: "%0.1f", weather.current.wind_speed)
    }
    //vlajnost
    var humidity: String{
        return String(format: "%d%", weather.current.humidity)
    }
    
    var rainChances: String {
        return String(format: "%0.0f", weather.current.dew_point)
    }
    //vspomogatelnaya func
    func getTimeFor(timestamp: Int) -> String {
        return timeFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    //deformator (peregon iz formatirovanogo tipa dannuh v originalnui)
    func getDayFor(timestamp: Int) -> String {
        return dayFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timestamp)))
    }
    // ispolzovanie geolokacuii dlya vuchisleniya dolgotu i shurinu iz adresa kotorui nam dali
    //2.) sozdanie func dlya poluchebiya lokacui
    func getLocation() {
        print("CityViewViewModel: getLocation...")
        CLGeocoder().geocodeAddressString(city) { (plaemarks, error) in
            if let  pleces = plaemarks, let place = pleces.first {
                self.getWeather(coord: place.location?.coordinate)
            }
        }
    }
    
    // 1.) sopdanie chasnoi func
    private func getWeather(coord: CLLocationCoordinate2D?){
        if let coord = coord {
            let urlString = API.getURLFor(lat: coord.latitude, lon: coord.longitude)
            getWeatherInternal(city: city, for: urlString)
        } else {
            //pri otsytstvii url bydet ispolzovatsya etot randomnui koordinatu
            let urlString = API.getURLFor(lat: 37.5484, lon: -121.9886)
            getWeatherInternal(city: city, for: urlString)
        }
    }
    // func info o pogode, gde bydet proishodit setevoi vuzov
    private func getWeatherInternal(city: String, for urlString: String){
        //        <ykazanie tipa dannuh>.vuborka iz
        NetworkManager<WeatherResponse>.fetch(for: URL(string: urlString)!) { (result) in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.weather =  response
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    //1:21 - kak sdelat protokol dlya rabotu s lottie ( https://www.youtube.com/watch?v=KI6Yf7VMefc&ab_channel=DevTechie )
   // 1:15
    func getLottieAnimationFor(icon: String) -> String {
        switch icon {
        case "01d":
            return "dayClearSky"
        case "01n":
            return "nightClearSky"
        case "02d":
            return "dayFewClouds"
        case "02n":
            return "nigthFewClouds"
        case "03d":
            return "dayScatteredClouds"
        case "03n":
            return "nightScatteredClouds"
        case "04d":
            return "dayBrokenClouds"
        case "04n":
            return "nightBrokenClouds"
        case "09d":
            return "dayShowerRain"
        case "09n":
            return "nigthShowerRain"
        case "10d":
            return "dayRain"
        case "10n":
            return "nightRain"
        case "11d":
            return "dayThunderstorm"
        case "11n":
            return "nightThunderstorm"
        case "13d":
            return "daySnow"
        case "13n":
            return "nightSnow"
        case "50d":
            return "dayMist"
        case "50n":
            return "nightMist"
        default:
            return "dayClearSky"
        }
    }
    func getWeatherIconFor(icon: String) -> Image {
        switch icon {
        case "01d":
            return Image(systemName: "sun.max.fill") //"dayClearSky"
        case "01n":
            return Image(systemName: "moon.fill") //"nightClearSky"
        case "02d":
            return Image(systemName: "cloud.sun.fiil") //"dayFewClouds"
        case "02n":
            return Image(systemName: "cloud.moon.fill") //"nigthFewClouds"
        case "03d":
            return Image(systemName: "cloud.fill") //"dayScatteredClouds"
        case "03n":
            return Image(systemName: "cloud.fill") //"nightScatteredClouds"
        case "04d":
            return Image(systemName: "cloud.fill") //"dayBrokenClouds"
        case "04n":
            return Image(systemName: "cloud.fill") //"nightBrokenClouds"
        case "09d":
            return Image(systemName: "cloud.drizzle.fill") //"dayShowerRain"
        case "09n":
            return Image(systemName: "cloud.drizzle.fill") //"nigthShowerRain"
        case "10d":
            return Image(systemName: "cloud.heavyrain.fill") //"dayRain"
        case "10n":
            return Image(systemName: "cloud.heavyrain.fill") //"nightRain"
        case "11d":
            return Image(systemName: "cloud.bolt.fill") //"dayThunderstorm"
        case "11n":
            return Image(systemName: "cloud.bolt.fill") //"nightThunderstorm"
        case "13d":
            return Image(systemName: "cloud.snow.fill") //"daySnow"
        case "13n":
            return Image(systemName: "cloud.snow.fill") //"nightSnow"
        case "50d":
            return Image(systemName: "cloud.fog.fill") //"dayMist"
        case "50n":
            return Image(systemName: "cloud.fog.fill") //"nightMist"
        default:
            return Image(systemName: "cloud.max.fill") //"dayClearSky"
        }
    }
}
