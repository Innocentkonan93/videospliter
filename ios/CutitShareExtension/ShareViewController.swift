//
//  ShareViewController.swift
//  CutitShareExtension
//
//  Created by Innocent on 18/08/2025.
//

import AVFoundation
import Foundation
import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    let appGroupId = "group.com.meetsum.cutit"
    let sharedUrlKey = "shared_video_url"
    let sharedTimestampKey = "shared_video_timestamp"
    
    private var isProcessing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoader()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard !isProcessing else { return }
        isProcessing = true
        
        handleSharedVideo()
    }
    
    private func setupLoader() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = UIColor(red: 25/255, green: 25/255, blue: 27/255, alpha: 0.95)
        container.layer.cornerRadius = 20
        container.layer.masksToBounds = true
        view.addSubview(container)
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .white
        spinner.startAnimating()
        container.addSubview(spinner)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Traitement de la vidéo..."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        container.addSubview(label)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 220),
            container.heightAnchor.constraint(equalToConstant: 140),
            
            spinner.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            spinner.topAnchor.constraint(equalTo: container.topAnchor, constant: 28),
            
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 16)
        ])
    }
    
    private func handleSharedVideo() {
        guard let items = extensionContext?.inputItems as? [NSExtensionItem],
              let item = items.first,
              let attachments = item.attachments else {
            dismissWithError(message: "Aucun élément de partage trouvé.")
            return
        }
        
        // Find video attachment
        var videoAttachment: NSItemProvider? = nil
        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                videoAttachment = attachment
                break
            }
        }
        
        guard let attachment = videoAttachment else {
            dismissWithError(message: "Veuillez partager un fichier vidéo valide.")
            return
        }
        
        attachment.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                self.dismissWithError(message: "Erreur lors du chargement de la vidéo: \(error.localizedDescription)")
                return
            }
            
            // data can be URL
            guard let url = data as? URL else {
                self.dismissWithError(message: "Le type de données partagé n'est pas supporté.")
                return
            }
            
            self.processVideoURL(url)
        }
    }
    
    private func processVideoURL(_ url: URL) {
        let fileName = getFileName(from: url)
        
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupId) else {
            dismissWithError(message: "Impossible d'accéder au dossier partagé de l'application.")
            return
        }
        
        let destinationURL = containerURL.appendingPathComponent(fileName)
        
        let success = copyFile(at: url, to: destinationURL)
        if success {
            // Save to UserDefaults
            if let userDefaults = UserDefaults(suiteName: appGroupId) {
                userDefaults.set(destinationURL.path, forKey: sharedUrlKey)
                userDefaults.set(Date().timeIntervalSince1970, forKey: sharedTimestampKey)
                userDefaults.synchronize()
                
                // Redirect and complete request
                self.redirectToHostApp()
            } else {
                dismissWithError(message: "Erreur lors de la sauvegarde des paramètres.")
            }
        } else {
            dismissWithError(message: "Erreur lors de la copie du fichier vidéo.")
        }
    }
    
    private func getFileName(from url: URL) -> String {
        var name = url.lastPathComponent
        if name.isEmpty {
            name = UUID().uuidString + ".mp4"
        }
        return name
    }
    
    private func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
            return true
        } catch {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
    }
    
    private func redirectToHostApp() {
        let url = URL(string: "cutit://media")!
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        DispatchQueue.main.async {
            while responder != nil {
                if responder?.responds(to: selectorOpenURL) == true {
                    let _ = responder?.perform(selectorOpenURL, with: url)
                }
                responder = responder!.next
            }
            self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    private func dismissWithError(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Erreur",
                message: message,
                preferredStyle: .alert
            )
            let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.extensionContext?.cancelRequest(withError: NSError(domain: "com.meetsum.cutit", code: 1, userInfo: [NSLocalizedDescriptionKey: message]))
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}
