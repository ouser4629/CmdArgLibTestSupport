//  Copyright (c) 2025-2026 Psummerland2 LLC.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

//import CmdArgLibCore
import Foundation

/// Creates temporary directory cd's to it and calls a closure. Deletes the directory, and cd's back on exit.
public func withinTemporaryDirectory(body: (() async throws -> Void)) async throws
{
    let name = "NEW"
    let fm = FileManager.default
    let startDir = fm.currentDirectoryPath
    let newDirURL = fm.temporaryDirectory.appendingPathComponent(name, isDirectory: true)
    defer {
        fm.changeCurrentDirectoryPath(startDir)
        try? fm.removeItem(at: newDirURL)
    }
    try fm.createDirectory(at: newDirURL, withIntermediateDirectories: true )
    fm.changeCurrentDirectoryPath(newDirURL.path)
    try await body()
}

/// Creates temporary directory cd's to it and calls a closure. Deletes the directory, and cd's back on exit.
public func withinTemporaryDirectory(body: (() throws -> Void)) throws
{
    let name = "NEW"
    let fm = FileManager.default
    let startDir = fm.currentDirectoryPath
    let newDirURL = fm.temporaryDirectory.appendingPathComponent(name, isDirectory: true)
    defer {
        fm.changeCurrentDirectoryPath(startDir)
        try? fm.removeItem(at: newDirURL)
    }
    try fm.createDirectory(at: newDirURL, withIntermediateDirectories: true )
    fm.changeCurrentDirectoryPath(newDirURL.path)
    try body()
}
