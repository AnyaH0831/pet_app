//
//  ContentView.swift
//
//
//  Created by Anya Huang on 2026-03-07.
//

import SwiftUI
 
extension UIWindow{
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake{
            NotificationCenter.default.post(
                name: Notification.Name("DeviceShook"), object: nil)
           
        }
    }
}

struct ContentView: View{
    @State private var offset = CGSize.zero  //pos
    
    //Squish state of the ball
    @State private var isScaled: Bool = false
    
    var body: some View{
        ZStack{
            Color.black.ignoresSafeArea()
            
            Circle()
                .fill(Color.gray)
                .frame(width: 120, height: 120)
                .scaleEffect(isScaled ? CGSize(width:1.3, height: 0.7): CGSize(width: 1, height: 1))
                .offset(offset)
                .animation(.spring(response:0.3, dampingFraction: 0.4), value: offset)
                .animation(.spring(response: 0.2, dampingFraction: 0.3), value: isScaled)
                  
        }
        
        .onReceive(NotificationCenter.default.publisher(
            for: Notification.Name("DeviceShook"))) { _ in onShake()
        }
    }
    
    func onShake(){
        isScaled = true
        let randomX = CGFloat.random(in: -80...80)
        let randomY = CGFloat.random(in: -80...80)
        offset = CGSize(width: randomX, height: randomY)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            offset = .zero
            isScaled = false
        }
        
    }
}



