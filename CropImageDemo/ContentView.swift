//
//  ContentView.swift
//  CropImageDemo
//
//  Created by Xingfa Zhou on 2020/8/7.
//  Copyright © 2020 Xingfa. All rights reserved.
//

import SwiftUI
import CropImageView

struct ContentView: View {
    @State var showCropView = false
    @State private var cropedImage: UIImage?
    
    var inputImage: UIImage {
        return UIImage(named: "demo") ??  UIImage(systemName: "sun.haze.fill")!
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.showCropView = true
            }) {
                Text("Show the crop view")
            }
            
            if self.cropedImage != nil {
                Image(uiImage: self.cropedImage!)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .sheet(isPresented: $showCropView,onDismiss:finishedCrop ) {
            CropImageView(inputImage: self.inputImage, resultImage: self.$cropedImage, cropSize: CGSize(width: 250, height: 250))
        }
    }
    
    func finishedCrop() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
