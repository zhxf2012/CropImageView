# CropImageView
Crop Images in SwiftUI .

A SwiftUI implementation of crop images in special areas.. Here's some of its useful features:
 * supports input with a UIImage and cropSize.
 * Supports Drag and drop the input image
 * Supports Scale for zoom in and out.
 * Supports save the result UIImage
 * Supports show in present and dismiss
 * Supports SwiftUI in iOS 13 and MacOS 10.15
 
 ### Pull requests and suggestions welcome :)
<a href="https://github.com/zhxf2012/CropImageView/issues">Report Bug</a>  ·  <a href="https://github.com/zhxf2012/CropImageView/issues">Suggest a feature</a>
 
## Getting Started
To run the example project, clone the repo, and run.

## Requirements
* Xcode 11.5 and above
* iOS 13  or MacOS 10.15 and above

 
## Installation
CropImageView is a *swift package*.
 * It can be imported into an app project using Xcode’s new Swift Packages option, which is located within the File menu.
 * When asked, use this repository's url: https://github.com/zhxf2012/CropImageView

Alternatively, if you're unable to use SPM for some reason, you can import it Manual
### Manual
Add ` CropImageView.swift` to your project.

## Usage
### Simple use

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


## Author

Xingfa Zhou

## Contributor


## License

CropImageView is available under the MIT license. See the LICENSE file for more info.
