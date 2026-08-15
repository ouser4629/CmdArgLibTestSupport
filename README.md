
<!-- 
//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.
-->

## CmdArgLibTestSupport

CmdArgLibTestSupport is part of the [Command Argument Library](https://github.com/ouser4629/cmd-arg-lib.git). 

It provides functions for invoking commands with command-line input and comparing their output with expected output.

---

## Sample

This sample, `print-m`, simply prints phrases. The complete implementaion, including tests, is included in this repository.

<details>

<summary>Code</summary>

```swift
public struct PrintMSource {
    public typealias Phrase = String

    @MainFunctionMacro(shadowGroups: ["u l"])
    public static func PrintM(
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

    public static let helpLayout: [ShowElement] = [ ]
```

Notice that the program throws Exception.stdout(_:) to produce standard output. This is a useful CAL
idiom for command functions that need to produce output while retaining normal control flow for their callers.

The key function provided by `CmdArgLibTestSupport`, `testOutput(of:with:expecting:)`, requires the tested
program to produce output by throwing an Exception rather than calling print.

</details>

<details>

<summary>Help Screen</summary>

```
> print-m --help
DESCRIPTION
  Print a phrase multiple times.

USAGE
  print-m [-hlu] [--count <int>] <phrase>

PARAMETERS
  -h/--help             Show help information.
  -l                    Lowercase the output.
  -u                    Uppercase the output.
  --count <int>         The number of times to print the phrase (default: 1).
  <phrase>              The phrase to print.

NOTE
  The -l and -u flags shadow each other. The last one specified takes
  precedence.
```

</details>

---

## Test Failure

<details>

<summary>Unit Test</summary>

```swift
import CmdArgLibTestSupport
import PrintMSource
import Testing

struct HelpSuite {

    @Test func helpTest2() {
        let input = """
            --help
            """
        let expected = """
            DESCRIPTION
              Print a phrase multiple times.

            USAGE
              print-m [-hlu] [--count <int>] <phrase>

            PARAMETERS
              -h/--help             Show help info.
              -l                    Lower the output.
              -u                    Uppercase the output.
              --count <int>         The number of times to print the phrase (default: 1).
              <phrase>              The phrase to print.

            NOTES
              The -l and -u flags shadow each other. The last one specified takes
              precedence.
            """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }
}
```

Note: It is recommended that all expected text reflect a terminal width of 80. In debug mode, `testOutput`
imposes a termial width of 80 for line wrapping instead of the actual terminal width.

</details>

<details>

<summary>Test Output</summary>

```
> swift test
...
------ OUTPUT MISMATCH at PrintMTests/HelpSuite.swift:65 
  DESCRIPTION
    Print a phrase multiple times.
  
  USAGE
    print-m [-hlu] [--count <int>] <phrase>
  
  PARAMETERS
+   -h/--help             Show help information.
+   -l                    Lowercase the output.
-   -h/--help             Show help info.
-   -l                    Lower the output.
    -u                    Uppercase the output.
    --count <int>         The number of times to print the phrase (default: 1).
    <phrase>              The phrase to print.
  
+ NOTE
- NOTES
    The -l and -u flags shadow each other. The last one specified takes
    precedence.
------ END MISMATCH --- "+" and "-" indicate changes to expected to match actual
```

</details>

---

## Test Success

You can run a command in the terminal and copy its input and output for use 
as test input and expected output.

### Command Calls

<details>

<summary>Command Calls</summary>

```
> print-m "Simplicity is complexity resolved."
Simplicity is complexity resolved.

> print-m "Well done is better than well said." -lu --count 2
WELL DONE IS BETTER THAN WELL SAID.
WELL DONE IS BETTER THAN WELL SAID.

> print-m -ULux "Oops" --count 2.1 
Errors:
  unrecognized options: "-U", "-L" and "-x", in "-ULux"
  "2.1" is not a valid <int> after --count
See "print-m --help" for more information.

```
</details>

### Corresponding Tests

<details>

<summary>Tests</summary>

```swift
import CmdArgLibCore
import CmdArgLibTestSupport
import PrintMSource
import Testing

struct RunSuite {

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
    
    @Test func runTest5() {
       let input = """
           -ULux "Oops" --count 2.1
           """
       let expected = """
           Errors:
             unrecognized options: "-U", "-L" and "-x", in "-ULux"
             "2.1" is not a valid <int> after --count
           See "print-m --help" for more information.
           """
        let ok = testOutput(of: PrintMSource.run, with: input, expecting: expected)
        #expect(ok)
    }
}
```

</details>

---

## Example

[Command Argument Library](https://github.com/ouser4629/cmd-arg-lib.git) has an
example, `Ex03_Run`, that shows the use of this module, along with various uses
of [`Exception`](https://github.com/ouser4629/cmd-arg-lib/blob/main/REFERENCE.md#exception).

---

## Project Status

This software is licensed under the [Mozilla Public License, v. 2.0 "MPL-2.0"](https://mozilla.org/MPL/2.0).

It is currently in beta (version 0.5.0), and has only been tested for macOS.

---

