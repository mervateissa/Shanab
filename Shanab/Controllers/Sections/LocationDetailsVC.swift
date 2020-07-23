//
//  LocationsVC.swift
//  Shanab
//
//  Created by Macbook on 5/4/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import DropDown
class LocationDetailsVC: UIViewController {
    @IBOutlet weak var apartmentTF: UITextField!
    @IBOutlet weak var building: UITextField!
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var floor: UITextField!
    @IBOutlet weak var areaBn: UIButton!
    @IBOutlet weak var street: UITextField!
    @IBOutlet weak var city: UIButton!
    @IBOutlet weak var country: UIButton!
    private let AddAddressVCPresenter = AddAddressPresenter(services: Services())
    let CountryDropDown = DropDown()
    let CityDropDown = DropDown()
    let AreaDropDown = DropDown()
    var cities = [String]()
    var Countries = [String]()
    var Aries = [String]()
    var cityId = Int()
    var city_id = String()
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 300
    var perviousLocation: CLLocation?
    let geoCoder = CLGeocoder()
    var lat = Double()
    var long = Double()
    var view_controller = String()
    var adressesList = [Country]()
    var countryId = Int()
    var country_id = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        AddAddressVCPresenter.setAddAddressViewDelegate(AddAddressViewDelegate: self)
        AddAddressVCPresenter.postGetCountries(table: "countries")
    }
    func SetupCityDropDown() {
        CityDropDown.anchorView = city
        CityDropDown.bottomOffset = CGPoint(x: 0, y: CityDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        CityDropDown.dataSource = cities
        CityDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.city.setTitleColor(#colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1), for: .normal)
            self?.city.setTitle(item, for: .normal)
          
            
            
        }
        
        CityDropDown.direction = .any
        CityDropDown.width = self.view.frame.width * 1
    }
    func SetupAreaDropDown() {
        AreaDropDown.anchorView = areaBn
        AreaDropDown.bottomOffset = CGPoint(x: 0, y: AreaDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        AreaDropDown.dataSource = Aries
        AreaDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.areaBn.setTitleColor(#colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1), for: .normal)
            self?.areaBn.setTitle(item, for: .normal)
             self?.cityId = self?.adressesList[index].id ?? 0
            self?.AddAddressVCPresenter.postGetCitiesAndAries(table: "areas", condition: "city_id", id: self?.adressesList[index].id ?? 0)
            
        }
        AreaDropDown.direction = .any
        AreaDropDown.width = self.view.frame.width * 1
    }
    func SetupCountryDropDown() {
        CountryDropDown.anchorView = country
        CountryDropDown.bottomOffset = CGPoint(x: 0, y: CountryDropDown.anchorView?.plainView.bounds.height ?? 0 + 50)
        CountryDropDown.dataSource = Countries
        CountryDropDown.selectionAction = {
            [weak self] (index, item) in
            self?.country.setTitleColor(#colorLiteral(red: 0.8121929765, green: 0.2939046025, blue: 0.2674312294, alpha: 1), for: .normal)
            self?.country.setTitle(item, for: .normal)
            self?.countryId = self?.adressesList[index].id ?? 0
            self?.AddAddressVCPresenter.postGetCitiesAndAries(table: "cities", condition: "country_id", id: self?.adressesList[index].id ?? 0)
        }
        CountryDropDown.direction = .any
        CountryDropDown.width = self.view.frame.width * 1
    }
    
    @IBAction func countryBN(_ sender: Any) {
        CountryDropDown.show()
    }
    @IBAction func CityBN(_ sender: Any) {
        CityDropDown.show()
    }
    @IBAction func AreaBN(_ sender: Any) {
        AreaDropDown.show()
    }
    @IBAction func Confirm(_ sender: UIButton) {
        AddAddressVCPresenter.showIndicator()
//                AddAddressVCPresenter.postAddAddress(lat: lat, long: long, address: addressTF.text ?? "", floor:  fl , country_id: 0, city_id: 0, area_id: 0, building: building.text ?? 0 , apartment: apartmentTF.text ?? 0)
//        
    }
}
extension LocationDetailsVC: AddAddressViewDelegate {
    func postGetCitiesAndAries(_ error: Error?, _ result: [Country]?) {
        if let Cities = result {
            self.adressesList = Cities
            for cities in Cities {
                    self.cities.append(cities.nameEn ?? "")
                    
                }
                SetupCityDropDown()
            }
        }
    
    
    func postGetCountries(_ error: Error?, _ result: [Country]?) {
        if let adds = result {
            self.adressesList = adds
            for countries in adds {
                    self.Countries.append(countries.nameEn ?? "")
                    
                }
                SetupCountryDropDown()
            }
            
        }
    
    func postAddAddress(_ error: Error?, _ result: SuccessError_Model?) {
        if let resultMsg = result {
            if resultMsg.successMessage != "" {
                displayMessage(title: "", message: resultMsg.successMessage , status: .success, forController: self)
                guard let sb = UIStoryboard(name: "Location", bundle: nil).instantiateViewController(withIdentifier: "MyAddressesVC") as? MyAddressesVC else {return}
                self.navigationController?.pushViewController(sb, animated: true)
            } else if resultMsg.latitude != [""] {
                displayMessage(title: "", message: resultMsg.latitude[0], status: .error, forController: self)
            } else if resultMsg.longitude != [""] {
                displayMessage(title: "", message: resultMsg.longitude[0], status: .error, forController: self)
            } else if resultMsg.address != [""] {
                displayMessage(title: "", message: resultMsg.address[0], status: .error, forController: self)
            } else if resultMsg.city_id != [""] {
                displayMessage(title: "", message: resultMsg.city_id[0], status: .error, forController: self)
            }  else if resultMsg.floor != [""] {
                displayMessage(title: "", message: resultMsg.floor[0], status: .error, forController: self)
            } else if resultMsg.country_id != [""] {
                displayMessage(title: "", message: resultMsg.country_id[0], status: .error, forController: self)
            } else if resultMsg.city_id != [""] {
                displayMessage(title: "", message: resultMsg.city_id[0], status: .error, forController: self)
            } else if resultMsg.apartment != [""] {
                displayMessage(title: "", message: resultMsg.apartment[0], status: .error, forController: self)
            } else if resultMsg.building != [""] {
                displayMessage(title: "", message: resultMsg.building[0], status: .error, forController: self)
            }
        }
    }
}
