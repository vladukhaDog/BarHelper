//
//  SelectImageOptionsView.swift
//  BarHelper
//
//  Created by Владислав Пермяков on 25.10.2024.
//

import SwiftUI
import Vision

struct SelectImageOptionsView: View {
    @Binding var imageBinding: UIImage?
    @State private var image: UIImage?
    @State private var selectFromGallery: Bool = false
    @State private var clipObject: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(imageBinding: Binding<UIImage?>){
        self._imageBinding = imageBinding
        self.image = imageBinding.wrappedValue
    }
    
    private func cutObject(_ imageToCut: UIImage?) -> UIImage? {
        guard let cgImage = imageToCut?.cgImage else {
            AlertsManager.shared.alert("Failed getting cgImage")
                return nil
            }
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(cgImage: cgImage)
        try? handler.perform([request])
        guard let result = request.results?.first else {
            print("Failed getting results")
            AlertsManager.shared.alert("Failed getting results")
            return nil
        }
        guard let maskedImage = try? result.generateMaskedImage(
            ofInstances: result.allInstances,
                    from: handler,
                    croppedToInstancesExtent: true
        ) else {
            print("Failed generating masked image")
            AlertsManager.shared.alert("Failed generating masked image")
            return nil
        }
                
        
        let img = UIImage(ciImage: CIImage(cvPixelBuffer: maskedImage))
        guard let data = img.pngData(), let uiImage = UIImage(data: data) else {
            print("Failed making image")
            AlertsManager.shared.alert("Failed making image")
            return nil
        }
        return uiImage
    }
    
    enum RotationDirection {
        case left
        case right
    }

    private func rotateImage(_ image: UIImage, direction: RotationDirection) -> UIImage? {
        var angle: CGFloat
        
        switch direction {
        case .left:
            angle = -.pi / 2  // Rotate 90 degrees to the left
        case .right:
            angle = .pi / 2   // Rotate 90 degrees to the right
        }
        
        var newSize = CGRect(origin: CGPoint.zero, size: image.size).applying(CGAffineTransform(rotationAngle: CGFloat(angle))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(angle))
        // Draw the image at its center
        image.draw(in: CGRect(x: -image.size.width/2, y: -image.size.height/2, width: image.size.width, height: image.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    var body: some View {
        VStack {
            Spacer()
            if let image = image{
                HStack {
                    Button("<-") {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let img = rotateImage(image, direction: .left)
                            DispatchQueue.main.async {
                                self.image = img
                            }
                        }
                    }
                    .cyberpunkFont(.title)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .frame(maxWidth: .infinity)
                    Button("->") {
                        DispatchQueue.global(qos: .userInitiated).async {
                            let img = rotateImage(image, direction: .right)
                            DispatchQueue.main.async {
                                self.image = img
                            }
                        }
                    }
                    .cyberpunkFont(.title)
                }
            }
            Button {
                clipObject.toggle()
            } label: {
                Text("Clip the object")
                    .cyberpunkFont(.title)
                    .foregroundStyle(Color.white)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .border(Color.softBlue, width: 3)
                    .opacity(clipObject ? 1 : 0.5)
            }
            Button("Select from gallery") {
                selectFromGallery.toggle()
            }
            .cyberpunkStyle(.pinkPurple)
            Button("Paste from clipboard") {
                selectFromGallery.toggle()
            }
            .cyberpunkStyle(.indigo)
            if image != nil {
                Button("Save") {
                    self.imageBinding = image
                    presentationMode.wrappedValue.dismiss()
                }
                .cyberpunkStyle(.green)
            }
            Spacer()
        }
        .sheet(isPresented: $selectFromGallery) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: .init(get: {
                UIImage()
            }, set: { image in
                if clipObject {
                    DispatchQueue.global(qos: .userInitiated).async {
                        let img = cutObject(image)
                        DispatchQueue.main.async {
                            self.image = img
                        }
                    }
                } else {
                    self.image = image
                }
            }))
        }
        .padding()
        .presentationCornerRadius(0)
        .backgroundWithoutSafeSpace(.darkPurple)
        .depthBorderUp(noBottom: true)
        .presentationDetents([.large])
    }
}

#Preview {
    Color.black
        .sheet(isPresented: .constant(true), content: {
            SelectImageOptionsView(imageBinding: .constant(nil))
        })
        
        .previewWrapper()
}
