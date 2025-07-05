# 🧠 MultiCoached Backend

This is the backend system for the MultiCoached mobile mental health application. Built using FastAPI and SQLAlchemy, it handles all core logic, authentication, chatbot processing, mood tracking, resource management, and forum features.

---

## 🚀 Features

- User registration and JWT-based authentication
- OTP verification (simulated)
- Daily mood check-in and tracking
- GPT-powered chatbot with distress signal alerts
- Admin panel for managing resources (PDFs, videos)
- Discussion forum and peer chat backend
- Swagger API documentation

---

## 🛠️ Tech Stack

- FastAPI
- Python 3.11+
- SQLAlchemy ORM
- SQLite
- Uvicorn
- Pydantic
- OpenAI API (Chatbot)
- SMTP for email alerts

---

## 🏗️ Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/rosisneupane/backend
   cd backend
2️ **Create Virtual Environment**
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate

3️.**Install Dependencies**
    ```bash
    pip install -r requirements.txt
    
4️ **Run the Server**
    ```bash  
    uvicorn main:app --reload
Swagger docs: http://localhost:8000/docs

## 💡 Distress Detection Logic
The chatbot monitors user messages. If certain keywords (e.g., "hurt", "die", "alone") are detected:
A distress signal is triggered.
An email alert is automatically sent to the guardian’s registered email.

## 🗄️ Database Info
Database: SQLite (auto-generated app.db)

ORM: SQLAlchemy

Models: User, DailyCheckIn, ChatLog, Resources, etc.

