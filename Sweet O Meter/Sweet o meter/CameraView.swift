import SwiftUI
import Vision
import AVFoundation

struct CameraView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var capturedImage: UIImage?
    @Binding var extractedText: String
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            print("Camera is not available.")
        }
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
                parent.performTextRecognition(on: image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    // Perform text recognition on the captured image
    func performTextRecognition(on image: UIImage) {
        // Ensure the image has a valid CGImage
        guard let cgImage = image.cgImage else {
            print("Failed to get cgImage from UIImage")
            return
        }

        // Prepare the text recognition request
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Text recognition failed: \(error.localizedDescription)")
                return
            }
            
            // Process recognized text
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text found")
                return
            }

            // Combine recognized text into a single string
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            
            // Normalize spaces (replace multiple spaces/tabs with a single space)
            let normalizedText = self.normalizeText(recognizedText)
            
            // Extract "Gula" or "Sugar" related values
            let extractedValue = self.extractGulaOrSugarValue(from: normalizedText)
            
            // Update the extractedText binding with the final value
            DispatchQueue.main.async {
                self.extractedText = extractedValue
            }
        }
        
        // Set recognition accuracy level
        request.recognitionLevel = .accurate
        
        // Perform the OCR request
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Error performing OCR: \(error.localizedDescription)")
        }
    }
    
    // Normalize spaces (replace multiple spaces/tabs with a single space)
    private func normalizeText(_ text: String) -> String {
        return text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
    
    // Extract values related to "Gula" or "Sugar" from the text
    private func extractGulaOrSugarValue(from text: String) -> String {
        let regex = try? NSRegularExpression(pattern: "(Gula|Sugar|Gula.*?)(\\s*[:|-]?\\s*(\\d+(?:\\.\\d+)?[\\s]*g))", options: .caseInsensitive)
        let range = NSRange(location: 0, length: text.utf16.count)
        if let match = regex?.firstMatch(in: text, options: [], range: range) {
            if let gulaRange = Range(match.range(at: 3), in: text) {
                return String(text[gulaRange]) // Return the numeric value with 'g'
            }
        }
        return "Nothing found" // Default if no match is found
    }
}
