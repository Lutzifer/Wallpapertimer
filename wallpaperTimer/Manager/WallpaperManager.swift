//
// WallpaperManager.swift
// wallpaperTimer
//
// Created by Wolfgang Lutz on 25.12.15.
// Copyright © 2015 wlutz. All rights reserved.
//

import Cocoa

class WallpaperManager {
	var useDaytime = false
	var folderManager: FolderManager
	
	init(baseFolderPath: String) {
		self.folderManager = FolderManager(baseFolderPath: baseFolderPath)
	}
	
	func setImageAtUrl(url: NSURL, screen: NSScreen) {
		do {
			try NSWorkspace.sharedWorkspace().setDesktopImageURL(url, forScreen: screen, options: Dictionary<String, AnyObject>())
		} catch let err as NSError {
			print(err)
		}
	}
	
	func setWallpapers() {
		if let screens = NSScreen.screens() {
			let groups = self.folderManager.groupsUsingDaytime(self.useDaytime)
			
			let eligibleGroups = groups.filter({ group -> Bool in
					return group.numberOfWallpapers() >= screens.count
				})
			
			let groupIndex = randomWithMax(eligibleGroups.count)
			let selectedGroup = groups[groupIndex]
			
			self.setWallpapers(selectedGroup, screens: screens)
		}
	}
	
	func setWallpapers(wallpaperGroup: WallpaperGroup, screens: Array<NSScreen>) {
		var wallpapers = wallpaperGroup.wallpapers
		
		for screen in screens {
			let index = randomWithMax(wallpapers.count)
			setImageAtUrl(wallpapers[index].url, screen: screen)
			wallpapers.removeAtIndex(index)
		}
	}
	
	func randomWithMax(max: Int) -> Int {
		return Int(arc4random_uniform(UInt32(max)))
	}
	
}
