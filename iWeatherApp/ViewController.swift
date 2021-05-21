//
//  ViewController.swift
//  iWeatherApp
//
//  Created by Dino  Omanovic on 16/09/2017.
//  Copyright © 2017 Dino  Omanovic. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import GooglePlaces
import NVActivityIndicatorView

class ViewController: UIViewController {
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherDescription: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var dayOne: UILabel!
    @IBOutlet weak var dayTwo: UILabel!
    @IBOutlet weak var dayThree: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var temperatureOne: UILabel!
    @IBOutlet weak var temperatureTwo: UILabel!
    @IBOutlet weak var temperatureThree: UILabel!
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }    

    @IBOutlet weak var progressBar: NVActivityIndicatorView!
    
    private let APPID = "14c1ad343b75d7f6fbe4f14fd766f0f7"
    private let unit = "metric"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.color = UIColor.blue
        progressBar.type = NVActivityIndicatorType.circleStrokeSpin
        progressBar.startAnimating()
        getWeather(cityName: "Tuzla,BA")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather(cityName: String) {
        AF.request("https://api.openweathermap.org/data/2.5/forecast", parameters: ["q":cityName,"APPID":APPID,"units":unit])
            .responseJSON {
                response in
                if let result = response.data {
                    let json = JSON(result)
                    print(json)
                    let cityName = String(describing: json["city"]["name"])
                    self.titleText.text = cityName
                    let currentImage = String(describing:json["list"][0]["weather"][0]["icon"])
                    let dayOneImage = String(describing:json["list"][8]["weather"][0]["icon"])
                    let dayTwoImage = String(describing:json["list"][16]["weather"][0]["icon"])
                    let dayThreeImage = String(describing:json["list"][24]["weather"][0]["icon"])
                    print(currentImage)
                    self.currentWeatherImage.image = UIImage(named: (self.getIcon(iconName: currentImage)))
                    self.imageOne.image = UIImage(named: (self.getIcon(iconName: dayOneImage)))
                    self.imageTwo.image = UIImage(named: (self.getIcon(iconName: dayTwoImage)))
                    self.imageThree.image = UIImage(named: (self.getIcon(iconName: dayThreeImage)))
                    let currentDesc = String(describing:json["list"][0]["weather"][0]["description"])
                    let dayOneDesc = String(describing:json["list"][8]["weather"][0]["description"])
                    let dayTwoDesc = String(describing:json["list"][16]["weather"][0]["description"])
                    let dayThreeDesc = String(describing:json["list"][24]["weather"][0]["description"])
                    let currentTempFloat = String(describing: json["list"][0]["main"]["temp"])
                    let dayOneValue = String(describing: json["list"][8]["main"]["temp"])
                    let dayTwoValue = String(describing: json["list"][16]["main"]["temp"])
                    let dayThreeValue = String(describing: json["list"][24]["main"]["temp"])
                    let currentTempInt = (currentTempFloat as NSString).integerValue
                    let dayOneInt = (dayOneValue as NSString).integerValue
                    let dayTwoInt = (dayTwoValue as NSString).integerValue
                    let dayThreeInt = (dayThreeValue as NSString).integerValue
                    let currentTemp = String(describing: currentTempInt)
                    let dayOneTempVal = String(describing: dayOneInt)
                    let dayTwoTempVal = String(describing: dayTwoInt)
                    let dayThreeTempVal = String(describing: dayThreeInt)
                    self.currentTemperature.text = currentTemp + " °C"
                    self.imageOne.image = UIImage(named: (self.getIcon(iconName:dayOneImage)))
                    self.temperatureOne.text = dayOneTempVal + " °C"
                    self.imageTwo.image = UIImage(named: (self.getIcon(iconName:dayTwoImage)))
                    self.temperatureTwo.text = dayTwoTempVal + " °C"
                    self.imageThree.image = UIImage(named: (self.getIcon(iconName:dayThreeImage)))
                    self.temperatureThree.text = dayThreeTempVal + " °C"
                    self.dayOne.text = dayOneDesc
                    self.dayTwo.text = dayTwoDesc
                    self.dayThree.text = dayThreeDesc
                    self.currentWeatherDescription.text = currentDesc
                    self.progressBar.stopAnimating()
                }
        }
    }
    
    func getIcon(iconName: String)->String {
        switch(iconName) {
        case "01d":
            return "d01"
        case "01n":
            return "n01"
        case "02d":
            return "d02"
        case "02n":
            return "n02"
        case "03d":
            return "d03"
        case "03n":
            return "n03"
        case "04d":
            return "d04"
        case "04n":
            return "n04"
        case "09d":
            return "d09"
        case "09n":
            return "n09"
        case "10d":
            return "d10"
        case "10n":
            return "n10"
        case "11d":
            return "d11"
        case "11n":
            return "n11"
        case "13d":
            return "d13"
        case "13n":
            return "n13"
        default:
            return "n01"
        }
    }
    
}

struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    
    var formattedAddress: String {
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        self.progressBar.startAnimating()
        let location = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            
            guard let placemark = placemarks?.first else {
                let errorString = error?.localizedDescription ?? "Unexpected Error"
                print("Unable to reverse geocode the given location. Error: \(errorString)")
                return
            }
            
            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
            print(reversedGeoLocation.isoCountryCode)
            print(reversedGeoLocation.city)
            self.getWeather(cityName: reversedGeoLocation.city+","+reversedGeoLocation.isoCountryCode)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
