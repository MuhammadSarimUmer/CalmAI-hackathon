# CalmFlow AI 🌪️➡️🧘

> **Aggressively Organized. Brutally Effective. Completely Calm.**

CalmFlow AI is an intelligent, neo-brutalist productivity ecosystem designed to eliminate decision fatigue, prevent cognitive overload, and force you into a flow state. It doesn't just list your tasks—it mathematically ranks them, breaks them down, and schedules them around your life.

Built for the modern knowledge worker who is drowning in tools, tabs, and unread emails.

---

## ⚡ Core Features (The Engine)

### 🧠 1. AI Priority Engine
Stop guessing what to work on next. The Priority Engine acts as your ruthless execution hub.
- **Intelligent Intake:** Designed to ingest tasks manually or seamlessly extract action items, deadlines, and urgent keywords directly from your **Gmail**.
- **Mathematical Ranking:** AI calculates an exact priority score using a custom formula: `(Urgency × 2) + Difficulty - Resistance`.
- **Reasoning Log:** Gives you a transparent, natural-language explanation of *why* a specific task is your #1 priority right now.

### 🌅 2. AI Daily Intelligence Briefing
Your morning executive assistant. 
- **Smart Scheduling:** Analyzes your **Google Calendar** commitments and your current task load to automatically generate a tailored, hour-by-hour schedule.
- **Cognitive Overload Warning:** The AI actively protects your mental health. If it detects too many meetings or tasks in a single day, it throws a proactive warning to prevent burnout.
- **Inbox Triage:** Alerts you to unread email spikes before you begin deep work.

### 🔨 3. Micro-Task Decomposer
Overwhelm is the enemy of execution.
- Enter a massive, vague goal (e.g., "Launch Hackathon Project"), and the AI instantly shatters it into highly actionable, bite-sized micro-tasks.
- Lowers the activation energy required to start working.

### 🌀 4. Open Loop Cleaner
Get fleeting thoughts out of your working memory.
- A rapid-capture brain dump interface.
- AI automatically categorizes thoughts, assigns urgency, and prompts you to either schedule them or discard them.

### ⚡ 5. Calm Mode (Flow State)
When it's time to execute, the noise disappears.
- A distraction-free, full-screen focus environment.
- Single-tasking enforcement: it only shows you your absolute #1 priority.
- Built-in Pomodoro-style focus timers and ambient soundscapes.

---

## 🛠️ Technology Stack

CalmFlow AI was built for speed, reliability, and instant AI inference.

### **Frontend**
- **React (Vite):** Lightning-fast component rendering.
- **Neo-Brutalist Design:** Custom UI/UX built from the ground up using raw, high-contrast CSS (Space Grotesk & Space Mono fonts) to enforce focus and clarity.

### **Backend & Infrastructure**
- **Supabase:** The backbone of the application.
  - **PostgreSQL:** Fully relational, master database schema handling profiles, tasks, and analytics.
  - **Supabase Auth:** Secure user authentication.
  - **Deno Edge Functions:** Serverless functions deployed globally to handle API requests, OAuth flows, and AI prompt engineering securely.

### **AI & Intelligence**
- **Groq API (Llama 3.1 8B):** Chosen for its blistering-fast inference speed. We use Groq to parse JSON arrays, extract context from emails, and generate cognitive warnings in milliseconds.

### **External Integrations**
- **Google Identity Services (GIS) / OAuth 2.0:** Secure authentication protocol.
- **Gmail API:** Architecture designed to read unread threads and extract urgent tasks.
- **Google Calendar API:** Designed to fetch daily commitments to build context-aware schedules.
- **Google Drive API:** Explored for deep document context retrieval.

---

## 💡 The Philosophy

Modern productivity tools are passive—they wait for you to organize them. CalmFlow AI is **active**. It reads your environment (emails, meetings), tells you exactly what to do, and warns you when you are doing too much. 

By combining the raw aesthetic of brutalism with the hyper-intelligence of Llama 3.1, CalmFlow doesn't just manage your work; it manages your psychology.

---

*Created during the hackathon. Built with React, Supabase, Groq, and a lot of caffeine.* ☕
