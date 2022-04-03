//
//  LottieView.swift
//  WeatherAppSwiftUI
//
//  Created by Helen Poe on 12.03.2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .loop
    
    //predstavlenie polzovatelskogo interfeisa
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView()
        return view
    }
    //obnovlennoe predstavlenie (mu ispolzuem dlya nastroiki ili otpravki svoistv dlya lottie animation)
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //sbros vseh sostoyanii
        uiView.subviews.forEach({$0.removeFromSuperview()})
        
        //deistviya dlya izmenenii animation
        let animationView = AnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        animationView.animation = Animation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
    }
}
