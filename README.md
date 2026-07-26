<div align="center">
  
  # ⚖️ LexCheck
  **Know the line before you cross it.**

  <p align="center">
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-blue?style=for-the-badge&logo=flutter" alt="Platform" />
    <img src="https://img.shields.io/badge/Tech-Flutter%20%7C%20AI%20%7C%20RAG-black?style=for-the-badge" alt="Tech Stack" />
    <img src="https://img.shields.io/badge/Track-Social%20Impact%20%C3%97%20LegalTech-success?style=for-the-badge" alt="Track" />
  </p>

  <p align="center">
    <i>An AI-powered legal companion that empowers Indian teenagers with instant, scenario-based legal awareness—turning complex laws and court judgments into plain-language answers, before a wrong decision becomes a permanent legal consequence.</i>
  </p>
</div>

---

## 📖 Table of Contents
- [The Problem](#-the-problem)
- [The Solution](#-the-solution)
- [Key Features](#-key-features)
- [Technical Architecture](#-technical-architecture)
- [Target Audience](#-target-audience)
- [Market Research & Insights](#-market-research--insights)
- [Competitive Advantage](#-competitive-advantage)
- [Future Vision](#-future-vision)

---

## 🚨 The Problem

Every day, Indian teenagers unknowingly cross legal boundaries. They act on dares, peer pressure, and impulse without knowing the legal limits. 

From recording and posting a classmate's fight on Instagram (IT Act Section 66E) to creating fake social media accounts (BNS/IPC Section 469), teenagers engage in activities they consider "harmless" or "normal teen behavior." They find out it was illegal only after the fact—often when an FIR is filed.

Under the Juvenile Justice Act (2015), teenagers aged 16–18 can be tried as adults for heinous offenses. **A mistake made at 17 can result in a criminal record that follows a person for life.** Currently, no tool exists to proactively bridge this awareness gap for Indian youth in their language and context.

---

## 💡 The Solution

**LexCheck** is a proactive decision companion—a judgment-free mobile application built with **Flutter** where a teenager can describe any situation, real or hypothetical, and receive an accurate, simple, India-law-grounded explanation of where they stand.

Instead of typing legal jargon, teenagers use a conversational AI interface. The AI translates complex Indian constitutional law, the Bharatiya Nyaya Sanhita (BNS), the IT Act, and POCSO into plain, friendly language that a 16-year-old can act on.

---

## ✨ Key Features

### 1. LexChat: Scenario Intelligence Engine
Users describe a situation in natural, everyday language. No legal terminology required. They can type freely or choose from relatable teen scenario starters ("My friend dared me to...", "Someone posted my photo without asking..."). The AI maps the situation to the relevant Indian law and responds like a knowledgeable friend.

### 2. RiskMeter: Visual Severity Classification
Every response includes a visual severity rating to give teenagers instant intuition without reading paragraphs of text:
- 🟢 **Safe / No Legal Risk** — Entirely lawful activity.
- 🟡 **Minor / Aware** — Technically regulated, civil matter or warning.
- 🟠 **Serious / Caution** — Bailable offense, potential FIR, consequences.
- 🔴 **Criminal** — Non-bailable, criminal offense, potential imprisonment.

### 3. CaseLens: Real Court Cases, Simply Told
Abstractions don't create impact; real stories do. Every legal explanation is grounded with a real Indian court case or reported incident. *(e.g., "In 2019, a teenager in Delhi was charged under Section 66E of the IT Act for sharing a classmate's photograph without consent. The High Court ruled...")*

### 4. Anonymous Mode
LexCheck is anonymous by default. No login is required for basic queries. No data is stored against user identity, and no query history is retained after the session. This privacy-first architecture guarantees zero judgment, encouraging proactive use.

---

## 🏗 Technical Architecture

LexCheck is a mobile-first platform built on a highly scalable AI architecture designed specifically to prevent AI hallucinations in legal contexts.

* **Frontend:** Flutter (Dart) — Ensuring a seamless, cross-platform native mobile experience (Android/iOS).
* **Backend:** Node.js / FastAPI — Handling API routing, session management, and AI orchestration.
* **AI & NLP Layer:** Large Language Models (LLMs) orchestrated via a **Retrieval-Augmented Generation (RAG)** pipeline.
* **Legal Corpus / Vector Database:** Pinecone or Chroma DB. The AI does not rely on general training data. It retrieves exact legal chunks from a curated, verified index of:
  * Bharatiya Nyaya Sanhita (BNS) 2023
  * Information Technology (IT) Act 2000
  * POCSO Act 2012
  * Juvenile Justice (JJ) Act 2015
  * Landmark Supreme Court & High Court judgments
* **Deployment:** Vercel (Web/Landing Page) + Railway/Render (Backend infrastructure).

---

## 🎯 Target Audience

* **Primary:** Indian teenagers (aged 15–21). Smartphone-native, highly active on social media, susceptible to peer pressure, and legally uninformed.
* **Secondary:** Parents seeking to educate their children about legal boundaries in the digital age.
* **Tertiary:** School counselors, NGOs, and legal aid clinics working in youth welfare and juvenile justice.

---

## 📊 Market Research & Insights

* **NCRB 2022:** Over 31,000 juveniles were apprehended for cognizable offenses in India, with cybercrime and assault categories rapidly rising. India recorded a 24% year-on-year increase in overall cybercrimes.
* **IAMAI 2023:** 72% of Indian teenagers are daily active internet users. Social media misuse is a growing concern.
* **Legal Literacy Gap:** Studies indicate that less than 12% of school-going youth can correctly identify what constitutes a cybercrime under Indian law.
* **The "Google" Problem:** When teens search for legal advice, they receive adult-facing, jargon-heavy documents with no contextual guidance. LexCheck solves this by being proactive, scenario-based, and youth-focused.

---

## 🏆 Competitive Advantage

| Feature | LexCheck | Google Search | Gov/Legal Portals | VakilSearch/LegalKart |
| :--- | :---: | :---: | :---: | :---: |
| **Youth-Targeted** | ✅ Yes | ❌ No | ❌ No | ❌ No |
| **Timing** | ⏳ Proactive (Before) | 🚨 Reactive (After) | 🚨 Reactive | 🚨 Reactive |
| **Input Style** | 💬 Scenario-first | 🔍 Keyword-first | 🔍 Query-first | 📄 Form-based |
| **Output Style** | 📊 RiskMeter + Plain Text | 📜 Jargon/Bare Acts | 📜 Complex Docs | 👨‍⚖️ Lawyer Consult |
| **Legal Grounding**| ⚖️ Curated RAG Corpus | 🕸 Unfiltered Web | ✅ Verified | ✅ Verified |
| **Privacy** | 🕵️‍♂️ Anonymous | 🍪 Tracked | 📝 Identity Req | 💳 Paid / Identified |

---

## 🚀 Future Vision

**Phase 1 (MVP):**
* Flutter mobile application with core LexChat interface.
* RAG backend covering BNS, IT Act, and POCSO.
* Anonymous querying and RiskMeter UI.

**Phase 2 (Growth):**
* Multilingual support (Hindi, Malayalam, Tamil) to empower vernacular-speaking youth.
* WhatsApp Bot integration for zero-friction access.
* School and NGO partnership programs.

**Phase 3 (Scale):**
* B2B licensing to schools and state governments for legal literacy curricula.
* Expansion into labor law for first-job youth (18–24).
* Scaling across South Asia as the definitive digital legal awareness platform.

---
*Disclaimer: LexCheck provides legal awareness, not legal advice. For specific legal situations, always consult a qualified advocate.*
