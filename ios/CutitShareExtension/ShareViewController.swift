//
//  ShareViewController.swift
//  CutitShareExtension
//
//  Created by Innocent on 18/08/2025.
//

import AVFoundation
import Foundation
import Social
import UIKit
import UniformTypeIdentifiers

class ShareViewController: SLComposeServiceViewController {
    let appGroupId = "group.com.meetsum.cutit"
    let sharedKey = "ShareKey"
    var sharedMedia: [SharedMediaFile] = []

    enum SharedMediaType: Int, CaseIterable, Codable {
        case video
    }

    enum RedirectionType {
        case media
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

        if let content = extensionContext!.inputItems[0] as? NSExtensionItem {
            if let contents = content.attachments {
                for (index, attachment) in (contents).enumerated() {
                    if attachment.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                        handleVideos(content: content, attachment: attachment, index: index)
                        return
                    }
                }
            }
        }

        self.redirectToHostApp(type: .media)
    }

    private func handleVideos(content: NSExtensionItem, attachment: NSItemProvider, index: Int) {
        attachment.loadItem(forTypeIdentifier: UTType.movie.identifier, options: nil) {
            [weak self] data, error in

            if error == nil, let url = data as? URL, let this = self {

                // Always copy
                let fileName = this.getFileName(from: url, type: .video)
                let newPath = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: this.appGroupId)!
                    .appendingPathComponent(fileName)
                let copied = this.copyFile(at: url, to: newPath)
                if copied {
                    guard let sharedFile = this.getSharedMediaFile(forVideo: newPath) else {
                        return
                    }
                    this.sharedMedia.append(sharedFile)
                }

                // If this is the last item, save imagesData in userDefaults and redirect to host app
                if index == (content.attachments?.count)! - 1 {
                    let userDefaults = UserDefaults(suiteName: this.appGroupId)
                    userDefaults?.set(this.toData(data: this.sharedMedia), forKey: this.sharedKey)
                    userDefaults?.synchronize()
                    this.redirectToHostApp(type: .media)
                }

            } else {
                self?.dismissWithError()
            }
        }
    }

    private func dismissWithError() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Erreur", message: "Erreur lors du partage de la vidéo",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }

    private func redirectToHostApp(type: RedirectionType) {
        let url = URL(string: "cutit://media")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")

        while responder != nil {
            if responder?.responds(to: selectorOpenURL) == true {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    private func getFileName(from url: URL, type: SharedMediaType) -> String {
        var name = url.lastPathComponent

        if name.isEmpty {
            name = UUID().uuidString + "." + (type == .video ? "mp4" : "jpg")
        }

        return name
    }

    private func copyFile(at srcURL: URL, to dstURL: URL) -> Bool {
        do {
            if FileManager.default.fileExists(atPath: dstURL.path) {
                try FileManager.default.removeItem(at: dstURL)
            }
            try FileManager.default.copyItem(at: srcURL, to: dstURL)
        } catch (let error) {
            print("Cannot copy item at \(srcURL) to \(dstURL): \(error)")
            return false
        }
        return true
    }

    private func getSharedMediaFile(forVideo: URL) -> SharedMediaFile? {
        let asset = AVURLAsset(url: forVideo)
        let duration = (CMTimeGetSeconds(asset.duration) * 1000).rounded()

        if FileManager.default.fileExists(atPath: forVideo.path) {
            return SharedMediaFile(
                path: forVideo.absoluteString, thumbnail: nil, duration: duration, type: .video)
        }
        return nil
    }

    class SharedMediaFile: Codable {
        var path: String
        var thumbnail: String?
        var duration: Double?
        var type: SharedMediaType

        init(path: String, thumbnail: String?, duration: Double?, type: SharedMediaType) {
            self.path = path
            self.thumbnail = thumbnail
            self.duration = duration
            self.type = type
        }
    }

    func toData(data: [SharedMediaFile]) -> Data {
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuration par défaut
    }
}
