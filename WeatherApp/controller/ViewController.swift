//
//  ViewController.swift
//  WeatherApp
//
//  Created by harsh yadav on 14/05/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=634d28d10f3e2431cc4aee00dd123e1b"
    var locationManager = CLLocationManager()
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }

    
    @IBAction func liveLocationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    
    // MARK: UITEXTFIELD DELEGATE METHOD
    
    
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         searchTextField.endEditing(true)
        //searchTextField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            fetchWeather(cityName: city)
        }

        searchTextField.text = ""

    }
    
    
}
    

//MARK: EXTENSION


extension WeatherViewController   {
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        getWeatherData(with: urlString)
    }
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        getWeatherData(with: urlString)
    }
    
    func getWeatherData(with urlString : String){
        guard let url = URL(string: urlString) else{ return   }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil{
                if let safedata = data{
                    do{
                        let userResponse = try JSONDecoder().decode(WeatherData.self , from : safedata)
                        let id = userResponse.weather[0].id
                        let temp = userResponse.main.temp
                        let name = userResponse.name
                        let weather = WeatherModel(conditionId: id , cityName: name , temperature: temp)
                        DispatchQueue.main.async {
                            self.lblTemp.text = weather.temperatureString
                            self.weatherImg.image = UIImage(systemName: weather.conditionName)
                            self.lblCity.text = weather.cityName
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            fetchWeather(latitude: lat, longitude: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    

}



    
    



