// Copyright (c) 2025-2026 Peter Summerland LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
