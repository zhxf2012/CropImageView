//
//  CropImageView.swift
//  CropImageView
//
//  Created by Xingfa Zhou on 2020/7/30.
//  Copyright © 2020 Yitesi. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
struct RectHole: Shape {
    let holeSize: CGSize
    func path(in rect: CGRect) -> Path {
        let path = CGMutablePath()
        path.move(to: rect.origin)
        path.addLine(to: .init(x: rect.maxX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: rect.origin)
        path.closeSubpath()
        
        let newRect = CGRect(origin: .init(x: rect.midX - holeSize.width/2.0, y: rect.midY - holeSize.height/2.0), size: holeSize)
        
        path.move(to: newRect.origin)
        path.addLine(to: .init(x: newRect.maxX, y: newRect.minY))
        path.addLine(to: .init(x: newRect.maxX, y: newRect.maxY))
        path.addLine(to: .init(x: newRect.minX, y: newRect.maxY))
        path.addLine(to: newRect.origin)
        path.closeSubpath()
        return Path(path)
    }
}

@available(iOS 13.0, OSX 10.15, *)
public struct CropImageView: View {
     
    @State private var dragAmount = CGSize.zero
    @State private var scale: CGFloat = 1.0
    
    @State private var clipped = false
    var inputImage: UIImage
    @Binding var resultImage:  UIImage?
    var cropSize: CGSize
    
    @State private var tempResult: UIImage?
    @State private var result: Image?
    
    @Environment(\.presentationMode) var presentationMode

    /*Fix error by spm: 'CropImageView' initializer is inaccessible due to 'internal' protection level
     .Lesson learned: all public struct need a public init
     https://stackoverflow.com/questions/54673224/public-struct-in-framework-init-is-inaccessible-due-to-internal-protection-lev?rq=1
     .Maybe there is another way.
     */
    public init(inputImage:UIImage,resultImage: Binding<UIImage?> ,cropSize:CGSize) {
        self.inputImage = inputImage
        _resultImage = resultImage
        self.cropSize = cropSize
    }

    var imageView: some View {
        Image(uiImage: inputImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            
            
            // 缩放
            .gesture(MagnificationGesture()
                .onChanged { value in
                    self.scale = value.magnitude
                }
        )
            // 拖拽
            .highPriorityGesture(
                DragGesture()
                    .onChanged { value in
                         self.dragAmount = value.translation
                }
                .onEnded { value in
                    self.dragAmount = value.translation
                }
        )
            
            //点击放大
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        self.scale += 0.1
                        print("\(self.scale)")
                }
        )
    }
    
    public var body: some View {
        GeometryReader { proxy  in
            ZStack {
                ZStack {
                    if self.clipped {
                        self.result?.resizable().scaledToFit().frame(width:self.cropSize.width,height: self.cropSize.height).overlay(Rectangle().stroke(Color.blue,lineWidth: 2))
                    } else {
                        self.imageView
                            .scaleEffect(self.scale)
                            .offset(self.dragAmount)
                            .animation(.easeInOut)
                        //                    .scaledToFit()
                    }
                    
                    RectHole(holeSize: self.cropSize)
                        .fill(Color(UIColor.black.withAlphaComponent(0.5)),style: FillStyle(eoFill: true,antialiased: true))
                        
                        .allowsHitTesting(false)
                    
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .frame(width:self.cropSize.width,height: self.cropSize.height)
                        .background(Rectangle().stroke(Color.white,lineWidth: 2))
                    
                    
                }
                .frame(width:proxy.size.width,height: proxy.size.height)
                
                VStack {
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Cancel")
                            .padding()
                        }
                         
                        
                        Spacer()
                        
                        Button(action: {
                            if self.tempResult == nil {
                                self.cropTheImageWithImageViewSize(proxy.size)
                            }
                            self.resultImage = self.tempResult
                            self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Done")
                            .padding()
                        }
                    }
                    .background(Color.secondary)
                    
                    Spacer()
                    
                    HStack {
                        Text("Size:\(Int(self.scale * 100))%")
                            .frame(width:90)
                            .foregroundColor(.accentColor)
                            .padding()
                        
                        Slider(value: self.$scale, in: 0.1 ... 2, step: 0.01)
                        .frame(width:140)
                        .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            self.cropTheImageWithImageViewSize(proxy.size)
                            self.clipped.toggle()
                            
                        }) {
                            Image(systemName: self.clipped ? "gobackward": "crop")
                        }
                        .padding()
                    }
                    .background(Color.secondary)
                    
                }
                .accentColor(.accentColor)
            }
            .padding()
        }
    }
    
    func cropTheImageWithImageViewSize(_ size: CGSize) {

        let imsize =  inputImage.size
        let scale = max(inputImage.size.width / size.width,
                        inputImage.size.height / size.height)

        
        let zoomScale = self.scale
        
//        print("imageView size:\(size), image size:\(imsize), aspectScale:\(scale),zoomScale:\(zoomScale)，currentPostion:\(dragAmount)")
 
        let currentPositionWidth = self.dragAmount.width * scale
            let currentPositionHeight = self.dragAmount.height * scale
        
        let croppedImsize = CGSize(width: (self.cropSize.width * scale) / zoomScale, height: (self.cropSize.height * scale) / zoomScale)
         
        let xOffset = (( imsize.width - croppedImsize.width) / 2.0) - (currentPositionWidth  / zoomScale)
        let yOffset = (( imsize.height - croppedImsize.height) / 2.0) - (currentPositionHeight  / zoomScale)
        let croppedImrect: CGRect = CGRect(x: xOffset, y: yOffset, width: croppedImsize.width, height: croppedImsize.height)
              
//        print("croppedImsize:\(croppedImsize),croppedImrect:\(croppedImrect)")
        if let cropped = inputImage.cgImage?.cropping(to: croppedImrect) {
            let croppedIm = UIImage(cgImage: cropped)
            tempResult = croppedIm
            result = Image(uiImage: croppedIm)
        }
    }
}

struct CropImageView_Previews: PreviewProvider {
    @State static var result: UIImage?
    static var previews: some View {
        CropImageView(inputImage: UIImage(systemName: "sun.haze.fill")!, resultImage: self.$result,cropSize: .init(width: 200, height: 200))
    }
}
