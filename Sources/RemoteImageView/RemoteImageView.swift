/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

public struct RemoteImageView<Content: View>: View {
    @ObservedObject var imageFetcher: RemoteImageFetcher
    var content: (_ image: Image) -> Content
    let placeholder: Image
    
    @State var previousUrl: URL? = nil
    @State var imageData: Data = Data()
    
    public init(
        placeholder: Image,
        imageFetcher: RemoteImageFetcher,
        content: @escaping (_ image: Image) -> Content
    ) {
        self.placeholder = placeholder
        self.imageFetcher = imageFetcher
        self.content = content
    }
    
    public var body: some View {
        DispatchQueue.main.async {
            if self.previousUrl != self.imageFetcher.getUrl() {
                self.previousUrl = self.imageFetcher.getUrl()
            }
            
            if !self.imageFetcher.imageData.isEmpty {
                self.imageData = self.imageFetcher.imageData
            }
        }
        
        let uiImage = imageData.isEmpty ? nil : UIImage(data: imageData)
        let image = uiImage != nil ? Image(uiImage: uiImage!) : nil
        
        return ZStack() {
            if image != nil {
                content(image!)
            } else {
                content(placeholder)
            }
        }
        .onAppear(perform: loadImage)
    }
    
    private func loadImage() {
        imageFetcher.fetch()
    }
}
