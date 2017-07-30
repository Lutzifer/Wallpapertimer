//
// NSFilemanager+VisibleFiles.swift
// wallpaperTimer
//
// Created by Wolfgang Lutz on 25.12.15.
// Copyright © 2015 wlutz. All rights reserved.
//

import Foundation

extension FileManager {
  func visibleFileURLsAtURL(_ url: URL) -> [URL] {
    var result = [URL]()

    do {
      var folderResult: [String]

      try folderResult = contentsOfDirectory(atPath: url.path)

      // filter dotfiles
      result = folderResult.filter({ filename -> Bool in
        !filename.hasPrefix(".")
      }).map({ fileName -> URL in
        url.appendingPathComponent(fileName)
      })

      return result
    } catch let err as NSError {
      print(err)
      return result
    }
  }
}
