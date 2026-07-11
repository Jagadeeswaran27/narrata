# Product Requirement Document (PRD)

## Project Name: Narrata

**Version:** 1.0.1

**Target Audience:** Parents and Children (Ages 3–10)

**Core Value Proposition:** An interactive, serverless-hybrid mobile app that generates personalized bedtime stories with high-fidelity, synchronized word-level audio narration and text highlighting to foster children's reading alignment.

---

## 1. Executive Summary & Goals

Narrata aims to revolutionize bedtime routines by allowing parents to generate bespoke, child-centric stories using Generative AI. Unlike static audiobooks, the app provides real-time word highlighting synchronized with AI-synthesized speech.

### Key Objectives:

* **Zero Infrastructure Overhead for Text AI:** Leverage direct client-to-cloud LLM architecture to eliminate proxy server costs.
* **Millisecond-Accurate Read-Along:** Utilize a specialized, self-hosted open-source Text-to-Speech microservice to obtain word-level token alignment data.
* **Low Operational Costs:** Keep ongoing compute costs minimal by using highly optimized, CPU-friendly open-source speech models running on basic cloud instances.

---

## 2. Target Architecture Overview

The system utilizes a **Serverless-Hybrid Architecture** split into two primary domains:

1. **The Serverless Core (Client + Firebase):** The Flutter application authenticates users via Firebase Auth, generates stories directly via Vertex AI for Firebase (Firebase AI Logic), and handles cloud storage/database syncing.
2. **The Microservice Compute (Self-Hosted TTS):** A dedicated, containerized Python FastAPI app hosting the `Kokoro-82M` text-to-speech model. It is responsible for returning both the audio payload and the token timestamps.

---

## 3. Functional Requirements

### User Management & Authentication

* **FR-1.1:** Parents must be able to sign up and authenticate securely using Firebase Authentication (Email/Password & Google Sign-In).
* **FR-1.2:** Every request sent from the client to the self-hosted TTS server must contain a valid Firebase ID Token in the authorization header for security validation.

### Story Generation Wizard

* **FR-2.1:** The app must provide a configuration interface for parents to choose story parameters: Child's Name, Story Genre (e.g., Space Adventure, Magical Forest, Animals), and Core Theme/Moral.
* **FR-2.2:** Text generation must use the Firebase AI Logic SDK to query `Gemini 1.5 Flash` natively from the device.
* **FR-2.3:** Firebase App Check must be enforced to ensure only legitimate, non-tampered client requests can consume the Gemini API allocation.

### Synchronized Audio & Highlighting (The Core Feature)

* **FR-3.1:** The client app must send generated story text to the self-hosted TTS microservice endpoint `/dev/captioned_speech`.
* **FR-3.2:** The microservice must return an MP3 audio file encoded as a Base64 string along with a sequential array of word tokens containing accurate `start_ts` and `end_ts` markers in seconds.
* **FR-3.3:** The reader UI must stream the audio buffer and dynamically update the style (highlighting) of the word corresponding to the active timestamp position of the player.
* **FR-3.4:** The TTS engine must utilize a target playback speed modifier of `0.85x` to `0.9x` to ensure clear, soothing narration suitable for bedtime environments.

### Personal Library (Bookshelf)

* **FR-4.1:** Generated stories (Text, Timestamp JSON arrays, and Metadata) must be saved immediately to Cloud Firestore.
* **FR-4.2:** Users must be able to browse their historical "Bookshelf" offline using Firestore’s local caching capabilities.

---

## 4. Technical Specifications & API Contracts

### TTS Microservice Payload Contracts

**Request Contract (`POST /dev/captioned_speech`):**

```json
{
  "model": "kokoro",
  "input": "Once upon a time in a magical forest.",
  "voice": "af_bella",
  "response_format": "mp3",
  "speed": 0.85,
  "stream": false,
  "return_timestamps": true,
  "lang_code": "en-us",
  "normalization_options": {
    "normalize": true
  }
}

```

**Response Contract (`200 OK`):**

```json
{
  "audio": "BASE64_ENCODED_MP3_STRING...",
  "text": "Once upon a time in a magical forest.",
  "segments": [
    {
      "text": "Once upon a time in a magical forest.",
      "tokens": [
        { "text": "Once", "start_ts": 0.0, "end_ts": 0.32 },
        { "text": "upon", "start_ts": 0.32, "end_ts": 0.58 }
      ]
    }
  ]
}

```

---

## 5. Non-Functional Requirements

* **Scalability:** The TTS microservice must be isolated inside a standalone Docker container (`ghcr.io/remsky/kokoro-fastapi-cpu:latest`) to allow horizontal deployment on cost-effective CPU compute layers (e.g., Railway or DigitalOcean Droplets).
* **Latency:** Text generation to initial read readiness should take less than 4.5 seconds complete end-to-end.
* **Security:** The FastAPI server must leverage the `firebase-admin` Python SDK to inspect JWT headers, blocking unauthenticated public scrapers from abusing the endpoint.