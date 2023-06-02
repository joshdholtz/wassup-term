//
//  ContentView.swift
//  WassupTerm
//
//  Created by Josh Holtz on 6/2/23.
//

import SwiftUI

import SwiftTerm

struct ContentView: View {
    var body: some View {
        VStack {
            Terminal()
        }
    }
}

struct Terminal: NSViewRepresentable {
    let terminalView = LocalProcessTerminalView(frame: CGRectZero)

    func makeNSView(context: Context) -> SwiftTerm.LocalProcessTerminalView {
        let shell = getShell()
        let shellIdiom = "-" + NSString(string: shell).lastPathComponent

        FileManager.default.changeCurrentDirectoryPath (FileManager.default.homeDirectoryForCurrentUser.path)
        terminalView.startProcess (executable: shell, execName: shellIdiom)

        return terminalView
    }

    func updateNSView(_ nsView: SwiftTerm.LocalProcessTerminalView, context: Context) {
        print("update")
    }

    typealias NSViewType = LocalProcessTerminalView

    func getShell () -> String
    {
        let bufsize = sysconf(_SC_GETPW_R_SIZE_MAX)
        guard bufsize != -1 else {
            return "/bin/bash"
        }
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: bufsize)
        defer {
            buffer.deallocate()
        }
        var pwd = passwd()
        var result: UnsafeMutablePointer<passwd>? = UnsafeMutablePointer<passwd>.allocate(capacity: 1)

        if getpwuid_r(getuid(), &pwd, buffer, bufsize, &result) != 0 {
            return "/bin/bash"
        }
        return String (cString: pwd.pw_shell)
    }
}
