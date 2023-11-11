//
// This source file is part of the Stanford Spezi Template Application project
//
// SPDX-FileCopyrightText: 2023 Stanford University
//
// SPDX-License-Identifier: MIT
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Spezi
import SpeziAccount


class FireStoreVisitor: AccountValueVisitor {
    private var values: [String: Any] = [:]

    private var errors: [String: Error] = [:]

    init() {}

    func visit<Key: AccountKey>(_ key: Key.Type, _ value: Key.Value) {
        let encoder = Firestore.Encoder()
        do {
            values["\(Key.self)"] = try encoder.encode(value)
        } catch {
            errors["\(Key.self)"] = error
        }
    }

    func final() -> [String: Any] {
        values // TODO: errors?
    }
}


class ValueParser: AccountKeyVisitor {
    private let builder: PartialAccountDetails.Builder
    private let value: Any


    init(value: Any, builder: PartialAccountDetails.Builder) {
        self.value = value
        self.builder = builder
    }


    func visit<Key: AccountKey>(_ key: Key.Type) {
        let decoder = Firestore.Decoder()

        do {
            // TODO: do we need to pass the reference?
            try builder.set(key, value: decoder.decode(Key.Value.self, from: value))
        } catch {
            // TODO: record errors!
        }
    }
}


actor AccountStorage: Module, DefaultInitializable { // TODO rename: FirebaseAccountStorage
    init() {}

    nonisolated func userDocument(for accountId: String) -> DocumentReference {
        Firestore
            .firestore()
            .collection("users")
            .document(accountId)
    }

    func create(_ identifier: AdditionalRecordId, _ details: SignupDetails) async throws {
        print("Created? \(identifier)")
        let encoded = details.acceptAll(FireStoreVisitor()) // TODO: map firestore erros!
        try await userDocument(for: identifier.accountId)
            .setData(encoded)
    }

    func load(_ identifier: AdditionalRecordId, _ keys: [any AccountKey.Type]) async throws -> PartialAccountDetails {
        let builder = PartialAccountDetails.Builder()

        let data = try await userDocument(for: identifier.accountId)
            .getDocument()
            .data()

        if let data {
            for key in keys {
                guard let value = data["\(key)"] else {
                    continue
                }

                let parser = ValueParser(value: value, builder: builder)
                key.accept(parser)
            }
        }
        // TODO: visit keys

        return builder.build()
    }

    func modify(_ identifier: AdditionalRecordId, _ modifications: AccountModifications) async throws {
        let encoded = modifications.modifiedDetails.acceptAll(FireStoreVisitor())
        try await userDocument(for: identifier.accountId)
            .setData(encoded, merge: true)


        let removedFields: [String: Any] = modifications.removedAccountDetails.keys.reduce(into: [:]) { result, key in
            result["\(key)"] = FieldValue.delete() // TODO: does the naming work?
        }

        try await userDocument(for: identifier.accountId)
            .updateData(removedFields)
    }

    func clear(_ identifier: AdditionalRecordId) async {}

    func delete(_ identifier: AdditionalRecordId) async throws {
        try await userDocument(for: identifier.accountId)
            .delete()

        // TODO: delete the other collections
    }
}
