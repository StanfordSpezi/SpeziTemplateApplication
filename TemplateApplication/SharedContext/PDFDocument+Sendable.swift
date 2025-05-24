//
// This source file is part of the Stanford Spezi Template Application open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University
//
// SPDX-License-Identifier: MIT
//

@preconcurrency import PDFKit.PDFDocument


// Remove as soon as Apple implemented a proper Sendable conformance of PDFDocument.
extension PDFDocument: @unchecked @retroactive Sendable {}
