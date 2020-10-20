//
//  ContentView.swift
//  Conversions
//
//  Created by Jeru Kim on 10/17/20.
//  Copyright © 2020 Jeru Kim. All rights reserved.
//

import SwiftUI

enum TempartureUnit: String, CaseIterable {
    case celsius
    case fahrenheit
    case kelvin
}

struct ContentView: View {
    let conversionRatesToCelsius: [String: (Double) -> Double] = [
        "celsius": { $0 },
        "fahrenheit": { ($0 - 32.0) * (5 / 9) },
        "kelvin": { $0 + 273.15 }
    ]
    let conversionRatesFromCelsius: [String: (Double) -> Double] = [
        "celsius": { $0 },
        "fahrenheit": { ($0 * 9/5) + 32 },
        "kelvin": { $0 - 273.15 }
    ]
    
    @State private var initialUnit: TempartureUnit = .celsius
    @State private var targetUnit: TempartureUnit = .fahrenheit
    
    @State private var initialValue: String = "0"
    
    private var targetValue: Double {
        let startingValue = Double(initialValue)

        if let value = startingValue {
            let startingUnit = initialUnit.rawValue
            
            guard let baseConversionValue = conversionRatesToCelsius[startingUnit]?(value) else { return 0 }
            
            let endingUnit = targetUnit.rawValue

            guard let convertedValue = conversionRatesFromCelsius[endingUnit]?(baseConversionValue) else { return 0 }
            
            return convertedValue
        } else {
            return 0
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    TextField("Convert From", text: $initialValue)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                    
                    Divider()
                    
                    Picker("From", selection: $initialUnit) {
                        ForEach(TempartureUnit.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
                        }
//                        .navigationBarTitle("Units", displayMode: .inline)
                    }
                }
                
                HStack {
                    
                    GeometryReader { geometry in
                        Text("\(self.targetValue, specifier: "%.2f")")
                            .frame(width: geometry.size.width / 2)
                    }
                    
                    Divider()
                    
                    Picker("To", selection: $targetUnit) {
                        ForEach(TempartureUnit.allCases, id: \.self) {
                            Text($0.rawValue).tag($0)
//                            .navigationBarTitle("Units", displayMode: .inline)
                        }
                    }
                }
            }
            .navigationBarTitle("Conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
