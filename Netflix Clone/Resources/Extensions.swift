//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Ahmad Nabil on 23/05/24.
//

import Foundation


extension String {
    func capitalizeFirstLetter() -> String {
        return prefix(1).uppercased() + lowercased().dropFirst()
    }
}
