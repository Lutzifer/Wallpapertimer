//
// WallpaperManager.swift
// wallpaperTimer
//
// Created by Wolfgang Lutz on 25.12.15.
// Copyright © 2015 wlutz. All rights reserved.
//

import Cocoa

struct WallpaperManager {
  let useDaytime: Bool
  let baseFolderPath: String

  func setWallpapers() {
    if let screens = NSScreen.screens() {
      let wallpaperGroups = groups(at: URL(fileURLWithPath: self.baseFolderPath), usingDaytime: useDaytime)

      let eligibleGroups = wallpaperGroups.filter { group -> Bool in
        group.wallpapers.count >= screens.count
      }

      let groupIndex = randomWithMax(eligibleGroups.count)
      let selectedGroup = wallpaperGroups[groupIndex]

      setWallpapers(selectedGroup, screens: screens)
    }
  }

  func setWallpapers(_ wallpaperGroup: WallpaperGroup, screens: [NSScreen]) {
    var wallpapers = wallpaperGroup.wallpapers

    for screen in screens {

      let index = randomWithMax(wallpapers.count)
      screen.setDesktopImage(at: wallpapers[index].url)
      wallpapers.remove(at: index)
    }
  }

  private func randomWithMax(_ max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
  }

  private func groups(at baseUrl: URL, usingDaytime: Bool) -> [WallpaperGroup] {
    return [
      baseUrl.appendingPathComponent(DayTime.currentDayTimeName),
      baseUrl.appendingPathComponent("all")
    ]
    .flatMap { FileManager.default.visibleFolderURLsAtURL($0) }
    .flatMap { WallpaperGroup(groupFolderURL: $0) }
  }
}
