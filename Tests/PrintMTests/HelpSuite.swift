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

import CmdArgLibCore
import CmdArgLibTestSupport
import PrintMSource
import Testing

struct HelpSuite {

    // Note: this test assumes termimal width of 80
    @Test func helpTest1() {
        let input = """
            --help
            """
        let expected = """
            DESCRIPTION
              Print a phrase multiple times.

            USAGE
              test-print-m [-hlu] [--count <int>] <phrase>

            PARAMETERS
              -h/--help             Show help information.
              -l                    Lowercase the output.
              -u                    Uppercase the output.
              --count <int>         The number of times to print the phrase (default: 1).
              <phrase>              The phrase to print.

            NOTE
              The -l and -u flags shadow each other. The last one specified takes
              precedence.
            """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }

//    // This test fails
//    @Test func helpTest2() {
//        let input = """
//            --help
//            """
//        let expected = """
//            DESCRIPTION
//              Print a phrase multiple times.
//
//            USAGE
//              test-print-m [-hlu] [--count <int>] <phrase>
//
//            PARAMETERS
//              -h/--help             Show help info.
//              -l                    Lower the output.
//              -u                    Uppercase the output.
//              --count <int>         The number of times to print the phrase (default: 1).
//              <phrase>              The phrase to print.
//
//            NOTES
//              The -l and -u flags shadow each other. The last one specified takes
//              precedence.
//            """
//        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
//        #expect(ok)
//    }
}
