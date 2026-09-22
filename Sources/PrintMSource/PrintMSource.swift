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
import CmdArgLibMacros
import CmdArgLibHelpScreen

public struct PrintMSource {
    public typealias Phrase = String

    @MainFunctionMacro(shadowGroups: ["u l"])
    public static func testPrintM(
        h__help help: MetaFlag = MetaFlag(helpElements: helpLayout),
        l: Flag,
        u: Flag,
        count: Int = 1,
        _ phrase: Phrase) throws
    {
        guard count >= 1 else { throw Exception.error("count must be >= 1") }
        var output: [String] = []
        let line = u ? phrase.uppercased() : l ? phrase.lowercased() : phrase
        for _ in 1...count { output.append(line) }
        throw Exception.stdout(output.joined(separator: "\n"))
    }

    public static let helpLayout: [ShowElement] = [
        .text("DESCRIPTION\n", "Print a $D{phrase} multiple times."),
        .synopsis("\nUSAGE\n"),
        .text("\nPARAMETERS"),
        .parameter("help", "Show help information"),
        .parameter("l", "Lowercase the output"),
        .parameter("u", "Uppercase the output"),
        .parameter("count", "The number of times to print the $D{phrase}"),
        .parameter("phrase", "The $D{phrase} to print"),
        .text("\nNOTE\n", "The $S{l} and $S{u} flags shadow each other. The last one specified takes precedence."),
    ]
}
