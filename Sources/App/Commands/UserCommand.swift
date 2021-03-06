//
//  HelloCommand.swift
//  App
//
//  Created by Podvorniy Ivan on 01.06.2020.
//

import Vapor

struct UserCommand: Command {
    struct Signature: CommandSignature {
        @Argument(name: "username")
        var username: String

        @Option(name: "password", short: "p")
        var password: String?
    }

    var help: String {
        "Crete new superuser"
    }

    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func run(using context: CommandContext, signature: Signature) throws {
        let password = signature.password ?? randomString(length: 10)
        let new_user = User(username: signature.username, name: "", surname: "", passwordHash: try Bcrypt.hash(password), isAdmin: true, apiLevel: .admin)
        try new_user.save(on: context.application.db).wait()
        
        context.console.print("Your username is \(signature.username), your password is \(password)")
    }
}
