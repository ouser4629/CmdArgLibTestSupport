// Copyright (c) 2025-2026 Peter Buenafuente Summerland
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

import CmdArgLibCore
import Foundation

public typealias MainFunctionRun<R> = (String) throws -> R
public typealias AsyncMainFunctionRun<R> = (String) async throws -> R
public typealias CommandRun<T> = (String, [T], [CommandNode<T>]) throws -> ([T], [String])
public typealias AsyncCommandRun<T> = (String, [T], [CommandNode<T>]) async throws -> ([T], [String])

// MARK: - TestOutput for MainFunction<R>

public func testOutput<R>(
    of command: MainFunctionRun<R>, with input: String, expecting: String,
    file: StaticString = #file, line: UInt = #line) -> Bool
{
    do {
        let _ = try command(input)
    }
    catch  {
        return checkException(for: error, expected: expecting, file: "\(file)", line: line)
    }
    return true
}

public func testOutput<R>(
    of command: AsyncMainFunctionRun<R>, with input: String, expecting: String,
    file: StaticString = #file, line: UInt = #line) async -> Bool
{
    do {
        let _ = try await command(input)
    }
    catch {
        return checkException(for: error, expected: expecting, file: "\(file)", line: line)
    }
    return true
}

public func testOutput<T>(
    of command: CommandRun<T>,
    with input: String,
    state: [T] = [],
    parentNodes: [CommandNode<T>] = [],
    expecting: String,
    file: StaticString = #file,
    line: UInt = #line) -> Bool
{
    do {
        let _ = try command(input, state, parentNodes)
    }
    catch {
        return checkException(for: error, expected: expecting, file: "\(file)", line: line)
    }
    return true
}

public func testOutput<T>(
    of command: AsyncCommandRun<T>,
    with input: String,
    state: [T] = [],
    parentNodes: [CommandNode<T>] = [],
    expecting: String,
    file: StaticString = #file,
    line: UInt = #line) async -> Bool
{
    do {
        let _ = try await command(input, state, parentNodes)
    }
    catch {
        return checkException(for: error, expected: expecting, file: "\(file)", line: line)
    }
    return true
}

// MARK: - testReturn for MainFunctionRun<R>

public func testReturn<R: CustomStringConvertible>(
    of command: MainFunctionRun<R>,
    with input: String, expecting: R ) -> Bool where R: Equatable
{
    do {
        let ret = try command(input)
        return checkReturnMatch(got: ret, expected: expecting)
    }
    catch {
        return true
    }
}

public func testReturn<R: CustomStringConvertible>(
    of command: AsyncMainFunctionRun<R>,
    with input: String, expecting: R ) async -> Bool where R: Equatable
{
    do {
        let ret = try await command(input)
        return checkReturnMatch(got: ret, expected: expecting)
    }
    catch {
        return true
    }
}

// MARK: - testReturn for CommandRun<T>

public func testReturn<T>(
    of command: CommandRun<T>,
    with input: String,
    state: [T] = [],
    parentNodes: [CommandNode<T>] = [],
    expecting: [T] ) -> Bool where T: Equatable
{
    do {
        let ret = try command(input, state, parentNodes)
        return checkReturnMatch(got: ret.0, expected: expecting)
    }
    catch {
        return true
    }
}

public func testReturn<T>(
    of command: AsyncCommandRun<T>,
    with input: String,
    state: [T] = [],
    parentNodes: [CommandNode<T>] = [],
    expecting: [T]) async -> Bool where T: Equatable
{
    do {
        let ret = try await command(input, state, parentNodes)
        return checkReturnMatch(got: ret.0, expected: expecting)
    }
    catch {
        return true
    }
}

// MARK: - Helpers

let mismatchEnd = #"------ END MISMATCH --- ("+" and "-" indicate changes to expected to match actual)"#

private func checkMatch(got: String, expected: String, file: String, line: UInt) -> Bool
{
    if got == expected { return true }
    let output = diff(expected: "\(expected)", actual: "\(got)").joined(separator: "\n")
    let fileAndLine = file.isEmpty ? "" : "at \(file):\(line) "
    print("------ OUTPUT MISMATCH \(fileAndLine)")
    print(output)
    print(mismatchEnd)
    return false
}

private func checkReturnMatch<R: CustomStringConvertible>(
    got: R, expected: R, file: String = "", line: UInt = 0) -> Bool where R: Equatable
{
    if got == expected {
        return true
    }
    let output = diff(expected: "\(expected)", actual: "\(got)").joined(separator: "\n")
    let fileAndLine = file.isEmpty ? "" : "at \(file):\(line) "
    print("------ RETURN VALUE MISMATCH \(fileAndLine)")
    print(output)
    print(mismatchEnd)
    return false
}

/// Return true if the exception message is as expected
private func checkException(for error: Error, expected: String, file: String, line: UInt) -> Bool
{
    var got: String = ""
    if let exception = error as? Exception {
        switch exception {
        case .stdout(let output): got = output
        case .stderr(let output): got = output
        case .error(let message): got = message
        case .errors(let messages): got = messages.joined(separator: "\n")
        }
    }
    else {
        got = showError(error)
    }
    return checkMatch(got: got, expected: expected, file: file, line: line)
}

/// Add prefixed lines that need to be added or removed from expected to ge to actual
///    "+" means add line to expected
///    "-" means remove life from expected
///
public func diff(expected expectedString: String, actual actualString: String) -> [String]
{
    let expected = expectedString.components(separatedBy: .newlines)
    let actual = actualString.components(separatedBy: .newlines)
    let m = actual.count
    let n = expected.count

    // Build LCS table
    var dp = Array(
        repeating: Array(repeating: 0, count: n + 1),
        count: m + 1
    )

    for i in 0..<m {
        for j in 0..<n {
            if actual[i] == expected[j] {
                dp[i + 1][j + 1] = dp[i][j] + 1
            } else {
                dp[i + 1][j + 1] = max(dp[i][j + 1], dp[i + 1][j])
            }
        }
    }

    // Walk backwards to build diff
    var result: [String] = []
    var i = m
    var j = n

    while i > 0 || j > 0 {
        if i > 0 && j > 0 && actual[i - 1] == expected[j - 1] {
            result.append("  \(actual[i - 1])")
            i -= 1
            j -= 1
        } else if j > 0 && (i == 0 || dp[i][j - 1] >= dp[i - 1][j]) {
            result.append("- \(expected[j - 1])")
            j -= 1
        } else if i > 0 {
            result.append("+ \(actual[i - 1])")
            i -= 1
        }
    }

    return result.reversed()
}

