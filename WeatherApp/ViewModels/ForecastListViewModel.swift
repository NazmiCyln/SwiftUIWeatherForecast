//
//  ForecastListViewModel.swift
//  WeatherApp
//
//  Created by Nazmi Ceylan on 2.09.2024.
//

import CoreLocation
import Foundation
import SwiftUI

class ForecastListViewModel: ObservableObject{
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }

    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    @Published var isError: Bool = false
    @Published var isLoading: Bool = false
    @AppStorage("location") var storagelocation: String = ""
    @Published var location = ""
    @AppStorage("system") var systen: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].system = systen
            }
        }
    }

    init(){
        location = storagelocation
        getWeatherForecast()

    }

    func getWeatherForecast() {
        storagelocation = location

        UIApplication.shared.endEditing()

        if location.isEmpty {
            forecasts = []
        } else {

            isLoading = true
            isError = false
            let apiService = APIService.shared
            CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                if let error = error as? CLError {
                    switch error.code{
                    case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                        self.appError = AppError(errorString: "Unable to determine location from this text.")
                    case .network:
                        self.appError = AppError(errorString: "You do not appera to have a network connection")
                    default:
                        self.appError = AppError(errorString: error.localizedDescription)
                    }

                    self.isError = true
                    self.isLoading = false
                    print(error.localizedDescription)
                }
                if let lat = placemarks?.first?.location?.coordinate.latitude,
                   let lon = placemarks?.first?.location?.coordinate.longitude {
                    apiService.getJson(
                        urlString:
                            "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=\(Secrets.apiKey)",
                        dateDecodingStrategy: .secondsSince1970) {
                            (result: Result<Forecast,APIService.APIError>) in

                            switch result {
                            case .success(let forecast):
                                DispatchQueue.main.async{
                                    self.isLoading = false
                                    self.forecasts = forecast.daily.map{
                                        ForecastViewModel(forecast: $0, system: self.systen)
                                    }
                                }

                            case .failure(let apiError):
                                switch apiError {
                                case .error(let errorString):
                                    self.appError = AppError(errorString: errorString)
                                    self.isError = true
                                    self.isLoading = false
                                    print(errorString)
                                }
                            }
                        }
                }
            }
        }

    }

}
