# CropImageView
Crop Images in SwiftUI.

A SwiftUI implementation of cropping images in selected areas. Here are some of its useful features:

 * Supports input with a UIImage and cropSize.
 * Supports dragging and dropping the input image
 * Supports scale for zooming in and out.
 * Supports saving the result UIImage
 * Supports showing in present and dismiss
 * Supports SwiftUI in iOS 13 and MacOS 10.15
 
 ### Pull requests and suggestions welcome :)
<a href="https://github.com/zhxf2012/CropImageView/issues">Report Bug</a>· <a href="https://github.com/zhxf2012/CropImageView/issues">Suggest a feature</a>
 
## Getting Started
To run the example project, clone the repo, and run.

## Requirements
* Xcode 11.5 and above
* iOS 13  or MacOS 10.15 and above

 
## Installation

### As Swift Package
CropImageView is a *swift package*.
 * It can be imported into an app project using Xcode’s new Swift Packages option, which is located in the File menu.
 * When asked, use this repository's URL: https://github.com/zhxf2012/CropImageView

Alternatively, if you're unable to use SPM for some reason, you can import it manually.

### Manual installation
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
            
            if self.croppedImage != nil {
                Image(uiImage: self.cropedImage!)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
        }
        .sheet(isPresented: $showCropView,onDismiss:finishedCrop ) {
            CropImageView(inputImage: self.inputImage, resultImage: self.$croppedImage, cropSize: CGSize(width: 250, height: 250))
        }
    }
    
    func finishedCrop() {
        
    }


## Author

Xingfa Zhou

## Contributor


## License

CropImageView is available under the MIT license. See the LICENSE file for more info.
