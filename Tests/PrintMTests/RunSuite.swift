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

struct RunSuite {

    // Note: this test assumes termimal width of 80
    @Test func runTest1() {
        let input = """
           "Simplicity is complexity resolved."
           """
        let expected = """
           Simplicity is complexity resolved.
           """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func runTest2() {
        let input = """
           "Well done is better than well said." -lu --count 2
           """
        let expected = """
           WELL DONE IS BETTER THAN WELL SAID.
           WELL DONE IS BETTER THAN WELL SAID.
           """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func runTest3() {
        let input = """
           -ul "The key to performance is elegance, not battalions of special cases."
           """
        let expected = """
           the key to performance is elegance, not battalions of special cases.
           """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }
}

struct RunBadArgsSuite {

    @Test func runTest4() {
       let input = """
           """
       let expected = """
           Error:
             missing value: "<phrase>"
           See "test-print-m --help" for more information.
           """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }

    @Test func runTest5() {
       let input = """
           -ULux "Oops" --count 2.1
           """
       let expected = """
           Errors:
             unrecognized options: "-U", "-L" and "-x", in "-ULux"
             "2.1" is not a valid <int> after --count
           See "test-print-m --help" for more information.
           """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }
}
