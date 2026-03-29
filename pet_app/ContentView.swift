//
//  ContentView.swift
//
//
//  Created by Anya Huang on 2026-03-07.
//

import SwiftUI
import CoreMotion
 
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
    
    @State private var tiltOffset = CGSize.zero
    private let motionManager = CMMotionManager()
    
    @State private var breathTimer: Timer?

    var body: some View{
        
//        let pupilX = (tiltOffset.width / 80) * 4
//        let pupilY = (tiltOffset.height / 80) * 4
        
        let pupilX = max(-4, min(4, (tiltOffset.width / 80) * 4))
        let pupilY = max(-4, min(4, (tiltOffset.height / 80) * 4))
        
        ZStack{
            Color.black.ignoresSafeArea()
            
            Circle()
                .fill(Color.gray)
                .frame(width: 120, height: 120)
                .scaleEffect(isScaled ? CGSize(width:1.3, height: 0.7): CGSize(width: 1, height: 1))
                .offset(offset)
                .offset(x:offset.width + tiltOffset.width,
                        y:offset.height + tiltOffset.height)
                .animation(.spring(response:0.3, dampingFraction: 0.4), value: offset)
                .animation(.spring(response: 0.2, dampingFraction: 0.3), value: isScaled)
                  
                .onAppear {
                    startTiltTracking()
                    startBreathing()
                }
            HStack(spacing: 24){
                Eye(isScared: isScaled,
                    pupilOffset: CGSize(width: pupilX, height: pupilY))
                
                Eye(isScared: isScaled,
                    pupilOffset: CGSize(width: pupilX, height: pupilY))
            }
            
            .offset(y: -10)
            
        }
        
        .onReceive(NotificationCenter.default.publisher(
            for: Notification.Name("DeviceShook"))) { _ in onShake()
        }
    }
    
    func onShake(){
        let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
        impactHeavy.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
        }
        
        isScaled = true
        let randomX = CGFloat.random(in: -80...80)
        let randomY = CGFloat.random(in: -80...80)
        offset = CGSize(width: randomX, height: randomY)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            offset = .zero
            isScaled = false
        }
        
    }
    
    func startTiltTracking(){
        guard motionManager.isAccelerometerAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.05
        motionManager.startAccelerometerUpdates(to: .main) { data, error in
            guard let data = data else { return }
            let x = data.acceleration.x * 100
            let y = data.acceleration.y * 100
            
            
            withAnimation(.spring(response:0.4, dampingFraction: 0.6)){
                tiltOffset = CGSize(width: x, height: -y)
            }
        }
    }
    
    func startBreathing(){
        breathTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true){ _ in
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred(intensity:0.4)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                generator.impactOccurred(intensity:0.2)
            }
                                          
        }
    }
}


struct Eye: View {
    var isScared: Bool = false
    var pupilOffset: CGSize = .zero
    
    var body: some View {
        
        
        
        ZStack{
            Circle()
                .fill(Color.white)
                .frame(width: isScared ? 22:16,
                       height: isScared ? 22:16)
            
            Circle()
                .fill(Color.black)
                .frame(width: isScared ? 10:8,
                       height: isScared ? 10:8)
                .offset(pupilOffset)
        }
        .animation(.spring(response:0.2), value:isScared)
    }
    
}
