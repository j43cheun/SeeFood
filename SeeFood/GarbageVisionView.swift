//
//  SeeFoodView.swift
//  SeeFood
//
//  Created by Justin Cheung on 12/24/20.
//

import SwiftUI

struct SeeFoodView: View {

    @ObservedObject
    var classifier: GarbageClassifier

    @State
    private var showImageSources: Bool

    @State
    private var showImagePicker: Bool

    @State
    private var imagePickerSourceType: UIImagePickerController.SourceType

    @State
    private var showConfidenceScores: Bool

    init() {
        self.classifier = GarbageClassifier()
        self._showImageSources = .init(initialValue: false)
        self._showImagePicker = .init(initialValue: false)
        self._imagePickerSourceType = .init(initialValue: UIImagePickerController.SourceType.photoLibrary)
        self._showConfidenceScores = .init(initialValue: false)
    }

    var body: some View {
        NavigationView {
            ZStack {
                self.imageView.zIndex(0)
                VStack {
                    Spacer()
                    self.identifyImageButton
                        .actionSheet(isPresented: self.$showImageSources) {
                            self.imageSources
                        }
                        .sheet(isPresented: self.$showImagePicker) {
                            self.imagePicker
                        }
                }
                .zIndex(1)
            }
            .navigationBarTitle(self.navigationBarTitle)
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    private var navigationBarTitle: String {
        var title = "Garbage Vision"

        if self.classifier.isProcessing {
            title = "Loading..."
        } else
        if self.classifier.label != nil {
            title = self.classifier.label!
        }

        return title.capitalized
    }

    private var identifyImageButton: some View {
        Button(action: {
            self.showImageSources = true
        }, label: {
            ZStack {
                Image(systemName: "viewfinder")
                    .font(.system(.largeTitle))
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color.white)
                Image(systemName: "trash.fill")
                    .font(.system(.title3))
                    .frame(width: 70, height: 70)
                    .foregroundColor(Color.white)
            }
        })
        .background(Color.blue)
        .cornerRadius(38.5)
    }

    private var imageSources: ActionSheet {
        ActionSheet(title: Text("Image Source"), buttons: self.imageSourceOptions)
    }

    private var imageSourceOptions: [ActionSheet.Button] {
        var buttons = [ActionSheet.Button]()

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            buttons.append(.default(Text("Camera")) {
                self.imagePickerSourceType = .camera
                self.showImagePicker = true
            })
        }

        buttons.append(.default(Text("File")) {
            self.imagePickerSourceType = .photoLibrary
            self.showImagePicker = true
        })

        buttons.append(.cancel())

        return buttons
    }

    private var imagePicker: ImagePicker {
        ImagePicker(sourceType: self.imagePickerSourceType) { image in
            if image != nil {
                self.classifier.classify(image: image!)
            }

            self.showImagePicker = false
        }
    }

    private var imageView: some View {
        VStack {
            if self.classifier.isProcessing {
                Text("Please wait...")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            } else {
                if let image = self.classifier.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .padding()
                    self.confidenceScoresButton
                        .sheet(isPresented: self.$showConfidenceScores) {
                            self.confidenceScoresView
                        }
                    Spacer()
                } else {
                    Text("Press the button below to identify garbage")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    private var confidenceScoresButton: some View {
        Button(action: {
            self.showConfidenceScores = true
        }, label: {
            Text("View confidence scores")
                .font(.system(size: 11))
        })
    }

    private var confidenceScoresView: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Confidence Scores").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        self.showConfidenceScores = false
                    }, label: { Text("Close") }).padding()
                }
            }
            Form {
                List {
                    if let classifications = self.classifier.classifications {
                        ForEach(classifications.indices) { index in
                            HStack {
                                Text(classifications[index].identifier.capitalized)
                                Spacer()
                                Text("\(classifications[index].confidence * 100, specifier: "%.2f")%")
                            }
                            .padding(5)
                        }
                    }
                }
            }
        }
    }
}
