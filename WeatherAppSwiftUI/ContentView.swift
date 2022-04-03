//
//  ContentView.swift
//  WeatherAppSwiftUI
//
//  Created by Helen Poe on 05.03.2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var cityVM = CityViewViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                MenuHeaderView(cityVM: cityVM)
                ScrollView(showsIndicators: false) {
                    CityView(cityVM:  cityVM)
                }
            }
            .padding(.top, 40)
        }
        .background(RoundedRectangle(cornerRadius: 5).fill(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7220992446, green: 0.7620736957, blue: 0.9948483109, alpha: 1)), Color(#colorLiteral(red: 0.4078431373, green: 0.5333333333, blue: 0.937254902, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
