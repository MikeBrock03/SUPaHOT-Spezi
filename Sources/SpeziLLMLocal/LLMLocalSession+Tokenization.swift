//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import llama


/// Extension of ``LLMLocalSession`` handling the text tokenization.
extension LLMLocalSession {
    /// Converts the current context of the model to the individual `LLMLocalToken`'s based on the model's dictionary.
    /// This is a required tasks as LLMs internally processes tokens.
    ///
    /// - Returns: The tokenized `String` as `LLMLocalToken`'s.
    func tokenize() async throws -> [LLMLocalToken] {
        // Format the chat into a prompt that conforms to the prompt structure of the respective LLM
        let formattedChat = try await schema.formatChat(self.context)
        
        var tokens: [LLMLocalToken] = .init(
            llama_tokenize_with_context(self.modelContext, std.string(formattedChat), schema.parameters.addBosToken, true)
        )
        
        // Truncate tokens if there wouldn't be enough context size for the generated output
        if tokens.count > Int(schema.contextParameters.contextWindowSize) - schema.parameters.maxOutputLength {
            tokens = Array(tokens.suffix(Int(schema.contextParameters.contextWindowSize) - schema.parameters.maxOutputLength))
        }
        
        // Output generation shouldn't run without any tokens
        if tokens.isEmpty {
            tokens.append(llama_token_bos(self.model))
            Self.logger.warning("""
            SpeziLLMLocal: The input prompt didn't map to any tokens, so the prompt was considered empty.
            To mediate this issue, a BOS token was added to the prompt so that the output generation
            doesn't run without any tokens.
            """)
        }
        
        return tokens
    }
    
    /// Converts an array of `LLMLocalToken`s to an array of tupels of `LLMLocalToken`s as well as their `String` representation.
    ///
    /// - Parameters:
    ///     - tokens: An array of `LLMLocalToken`s that should be detokenized.
    /// - Returns: An array of tupels of `LLMLocalToken`s as well as their `String` representation.
    ///
    /// - Note: Used only for debug purposes
    func detokenize(tokens: [LLMLocalToken]) -> [(LLMLocalToken, String)] {
        tokens.reduce(into: [(LLMLocalToken, String)]()) { partialResult, token in
            partialResult.append((token, String(llama_token_to_piece(self.modelContext, token))))
        }
    }
}
