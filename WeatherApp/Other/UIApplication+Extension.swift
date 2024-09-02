//
//  UIApplication.swift
//  WeatherApp
//
//  Created by Nazmi Ceylan on 2.09.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
