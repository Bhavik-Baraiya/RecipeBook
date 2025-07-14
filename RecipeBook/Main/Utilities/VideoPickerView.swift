//
//  VideoPicker.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 14/07/25.
//

import SwiftUI
import PhotosUI

struct VideoPickerView: UIViewControllerRepresentable {
    var onComplete: (URL) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onComplete: onComplete)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .videos
        config.selectionLimit = 0 // Multiple selection

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onComplete: (URL) -> Void

        init(onComplete: @escaping (URL) -> Void) {
            self.onComplete = onComplete
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            for result in results {
                if result.itemProvider.hasItemConformingToTypeIdentifier("public.movie") {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: "public.movie") { url, error in
                        if let url = url {
                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent)
                            try? FileManager.default.copyItem(at: url, to: tempURL)
                            DispatchQueue.main.async {
                                self.onComplete(tempURL)
                            }
                        }
                    }
                }
            }
        }
    }
}
