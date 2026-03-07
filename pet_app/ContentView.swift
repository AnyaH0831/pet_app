//
//  ContentView.swift
//
//
//  Created by Anya Huang on 2026-03-07.
//

import SwiftUI

struct ContentView: View{
    var body: some View{
        ZStack{
            Color.black.ignoresSafeArea()
            
            Circle()
                .fill(Color.gray)
                .frame(width: 120, height: 120)
                  
        }
    }
}



