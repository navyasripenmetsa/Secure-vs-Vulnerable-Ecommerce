# 🛡️ Demonstrating SQL Injection Attacks and Secure Defenses in an E-Commerce Web Application

> A basic e-commerce web application demonstrating real-world **SQL Injection vulnerabilities** and their **secure implementations** — built with React, Flask, and MySQL.

![Security](https://img.shields.io/badge/Focus-SQL%20Injection-red?style=flat-square)
![Stack](https://img.shields.io/badge/Stack-React%20%7C%20Flask%20%7C%20MySQL-blue?style=flat-square)
![Purpose](https://img.shields.io/badge/Purpose-Educational-green?style=flat-square)
![Course](https://img.shields.io/badge/Course-CSL6010%20Cybersecurity-purple?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)

---

## 👩‍💻 Contributors

This project is part of our **Cybersecurity CSL6010 Course Project** at IIT Jodhpur.

| Name | Email |
|---|---|
| Penmetsa Navyasri | [b23cs1052@iitj.ac.in](mailto:b23cs1052@iitj.ac.in) |
| Polimetla Eshikha | [b23cs1053@iitj.ac.in](mailto:b23cs1053@iitj.ac.in) |

> Feel free to reach out for any collaborations, questions, or discussions around web security and secure development practices.

---

## 📖 Table of Contents

- [Security Concepts](#-security-concepts)
- [Project Overview](#-project-overview)
- [Architecture](#-architecture)
- [SQL Injection Attacks Demonstrated](#-sql-injection-attacks-demonstrated)
- [Secure Version — Defense Techniques](#-secure-version--defense-techniques)
  - [Parameterized Queries](#1-parameterized-queries-prepared-statements)
  - [SQL Injection Pattern Detector](#2-sql-injection-pattern-detector)
  - [Attack Logger](#3-attack-logger)
  - [Security Monitoring Dashboard](#4-security-monitoring-dashboard)
  - [bcrypt Password Hashing](#5-bcrypt-password-hashing)
  - [JWT-Based Authentication](#6-jwt-based-authentication-with-expiry)
  - [Role-Based Access Control](#7-role-based-access-control-rbac)
  - [Whitelist-Only Field Updates](#8-whitelist-only-field-updates)
  - [Input Length Validation](#9-input-length-validation)
  - [Query Execution Timeout](#10-query-execution-timeout)
  - [Environment Variable Configuration](#11-environment-variable-configuration)
  - [Transactional Integrity](#12-transactional-integrity-with-autocommitfalse)
- [Secure vs Vulnerable Comparison](#-secure-vs-vulnerable-comparison)
- [Tech Stack](#-tech-stack)
- [Getting Started](#-getting-started)
- [Disclaimer](#-disclaimer)

---

## 🔐 Security Concepts

Before diving into the project, here are the foundational concepts that underpin everything demonstrated here.

### What is SQL Injection?

SQL Injection (SQLi) is one of the oldest and most dangerous web security vulnerabilities. It happens when an application takes user-supplied input and directly embeds it into a SQL query without sanitization. Because the database cannot tell the difference between the developer's intended query structure and the attacker's injected content, the attacker can rewrite the logic of the query entirely.

**Why it happens:**
- User input is concatenated directly into query strings
- Input validation is absent or incomplete
- Parameterized queries are not used
- Error messages expose database structure

**What an attacker can achieve:**
- Bypass authentication and log in as any user, including admins
- Extract sensitive data — usernames, passwords, emails, payment info
- Modify or delete database records
- Escalate their own privileges to administrator level
- In some configurations, execute commands on the underlying server

### Types of SQL Injection

**In-Band SQLi** is the most straightforward type. The attacker sends a malicious query and the result comes back directly in the HTTP response — they can read data on screen immediately.

**Boolean-Based Blind SQLi** is used when the application does not show query results directly but behaves differently depending on whether the injected condition is true or false. By asking a series of yes/no questions through crafted payloads, an attacker can reconstruct the entire database one bit at a time.

**Time-Based Blind SQLi** is used when the application shows no visible difference at all in its response. The attacker instead injects a command that forces the database to pause for a fixed number of seconds. By measuring response time, they get a binary signal — delay means true, no delay means false — allowing the same character-by-character extraction as boolean-based, but purely through timing.

**Second-Order SQLi** is the most deceptive type. The malicious input is stored safely in the database on the first request, appearing harmless. It only executes when that stored data is later retrieved and re-used unsafely in a second, different database query — often in a backend process the attacker never directly interacts with.

### Core Defense Principles

**Parameterized Queries** — The single most important defense. SQL structure and user data are kept completely separate. The database receives the query shape first, and the user values second. No matter what the input contains, it can never alter the query's structure.

**Input Validation** — Reject or sanitize input that does not conform to expected shape, length, or character set before it ever reaches query-building logic.

**Principle of Least Privilege** — Database users should only have the permissions they actually need. An application that only reads and writes data should never have permission to drop tables or create admin accounts.

**Defense in Depth** — No single control is relied upon exclusively. Parameterized queries, pattern detection, access control, logging, and timeouts are all layered so that bypassing one layer does not mean the attack succeeds.

**Bcrypt Password Hashing** — Passwords should never be stored in plaintext. Bcrypt is an adaptive, salted hashing algorithm built specifically for passwords — computationally expensive by design to slow down brute-force cracking.

**JWT-Based Authentication** — After login, a cryptographically signed token is issued to the user. The server verifies this signature on every protected request, ensuring no one can forge their identity or tamper with their role.

---

## 🔍 Project Overview

This project is a basic e-commerce platform built **twice** — once with intentional SQL Injection vulnerabilities, and once with a fully hardened secure backend. It serves as a hands-on reference for understanding how SQLi attacks work and how each one is specifically prevented.

**Features of the simulated platform:**
- User Registration & Login
- Product Browsing & Search
- Order Placement & History
- Product Reviews
- Admin Panel

---

## 🏗️ Architecture

```
Secure-and-Vulnerable-ECommerce/
│
├── Vulnerable_Website/
│   ├── frontend/        # React.js
│   ├── backend/         # Flask (intentionally insecure)
│   └── database/        # MySQL schema & seed data
│
└── Secure_Website/
    ├── frontend/        # React.js
    ├── backend/         # Flask (hardened)
    └── database/        # MySQL schema & seed data
```

---

## 💉 SQL Injection Attacks Demonstrated

### 1. Login Bypass

**Target:** Login Page

**What is happening in plain English:**

When you log in to a website, the backend typically runs a database query to check whether your username and password match a record. In the vulnerable version, the application takes whatever the user types and directly drops it into that query — no checks, no filtering.

An attacker can type a specially crafted string as the username — something like `' OR '1'='1' --` — which completely changes the meaning of the SQL query. Instead of looking for a specific user, the query now asks: *"Give me a user where the username is blank OR where 1 equals 1"*. Since 1 always equals 1, this condition is always true for every row in the database. The `--` at the end comments out the rest of the query, including the password check — so the password becomes completely irrelevant.

The result: the attacker is logged in as the first user in the database, often the admin, without knowing any real username or password.

| | Code |
|---|---|
| **Vulnerable Query** | `SELECT * FROM users WHERE username = '{username}' AND password = '{password}'` |
| **Malicious Payload** | `' OR '1'='1' --` |
| **Resulting Query** | `SELECT * FROM users WHERE username = '' OR '1'='1' -- AND password = 'anything'` |

---

### 2. Boolean-Based SQLi — TRUE Condition

**Target:** Product Search

**What is happening in plain English:**

Boolean-based injection is how an attacker first *confirms* that a website is vulnerable before launching a bigger attack. The attacker does not try to steal data right away — they just observe whether the application behaves differently depending on whether an injected condition is true or false.

In this case, the attacker injects `%' AND 1=1 -- -` into the search box. The `1=1` part is a condition that is always true — like saying *"show me results where a product matches my search AND where the sky is blue"*. Since the sky is always blue, the second condition never filters anything out. The page loads normally and returns all products.

This tells the attacker: *"The application is executing my injected SQL, and it worked."* It is the green light to attempt more dangerous payloads.

| | Code |
|---|---|
| **Vulnerable Query** | `SELECT * FROM products WHERE name LIKE '%{product_name}%'` |
| **Payload** | `%' AND 1=1 -- -` |
| **Resulting Query** | `SELECT * FROM products WHERE name LIKE '%%' AND 1=1 -- -` |

---

### 3. Boolean-Based SQLi — FALSE Condition

**Target:** Product Search

**What is happening in plain English:**

This is the second half of the boolean-based confirmation technique. The attacker now injects a condition that is always false — `1=2` — which is like saying *"show me results where a product matches AND where 2 equals 1"*. Since 2 never equals 1, every row gets filtered out and the page returns no results at all.

On their own, zero results mean nothing. But when the attacker compares the TRUE response (all products shown) with the FALSE response (no products shown), they have hard proof that the application is blindly running their injected SQL. This behavioral difference is the foundation for extracting real database information character by character — a technique called blind SQL injection.

| | Code |
|---|---|
| **Payload** | `%' AND 1=2 -- -` |
| **Resulting Query** | `SELECT * FROM products WHERE name LIKE '%%' AND 1=2 -- -` |

---

### 4. Time-Based SQLi — TRUE Condition

**Target:** Product Search

**What is happening in plain English:**

Sometimes a vulnerable application is configured to hide all error messages and never shows any visual difference in the output — making boolean-based injection ineffective. Time-based injection solves this. Instead of looking at *what* the page returns, the attacker looks at *how long* the page takes to respond.

The attacker injects a payload containing `SLEEP(5)`, which is a database command that pauses execution for 5 seconds. When the injected condition is true, the database actually runs `SLEEP(5)` before returning results — causing the page to take 5 seconds longer to load than usual.

To the attacker watching with a stopwatch, a 5-second delay is all the confirmation they need. The injection worked. From here, they can craft payloads that ask yes/no questions about the database — *"Does the admin's password start with the letter A?"* — and use timing to get the answer, even when the page looks identical either way.

| | Code |
|---|---|
| **Payload** | `%' AND (SELECT COUNT(*) FROM (SELECT SLEEP(5))a) --` |
| **Resulting Query** | `SELECT * FROM products WHERE name LIKE '%%' AND (SELECT COUNT(*) FROM (SELECT SLEEP(5))a) --` |

---

### 5. Time-Based SQLi — FALSE Condition

**Target:** Product Search

**What is happening in plain English:**

This is the counterpart to the TRUE time-based test above. The attacker injects a payload where the overall condition is false — `1=2` — which means the `SLEEP(5)` command never actually runs. The page responds instantly, with no delay.

Taken together with the TRUE case, this gives the attacker a reliable binary signal: *5-second delay means TRUE, instant response means FALSE*. With this technique, an attacker can slowly reconstruct entire tables of data — usernames, passwords, credit card numbers — one character at a time, purely by measuring response times, even on an application that reveals absolutely nothing on screen.

| | Code |
|---|---|
| **Payload** | `%' AND (1=2 AND (SELECT COUNT(*) FROM (SELECT SLEEP(5))a)) --` |
| **Resulting Query** | `SELECT * FROM products WHERE name LIKE '%%' AND (1=2 AND (SELECT COUNT(*) FROM (SELECT SLEEP(5))a)) --` |

---

### 6. Second-Order SQLi + Privilege Escalation

**Target:** Admin Review Processing

**What is happening in plain English:**

This is the most sophisticated attack in this project because the malicious input does not cause damage immediately — it hides harmlessly in the database and strikes later when an admin processes it.

Here is how it unfolds: an attacker registers an account or submits a review using a username or input field that contains a fragment of a SQL statement — something like `navyasri', role='admin' --`. The application stores this in the database without issue because at that point it may be handling input correctly.

However, when an administrator later reviews or processes this submission, the backend fetches that stored value and re-inserts it into a new SQL query — this time unsafely. The injected SQL fragment wakes up and executes in this new context, escalating the attacker's account role to `admin`.

What makes this especially dangerous is that standard input scanning tools often miss it. The vulnerability does not lie where the data enters the system — it lies where the data is *reused*. An application can appear completely safe on registration but still be compromised the moment stored data touches a second, unprotected query.

```sql
UPDATE users 
SET last_processed = NOW(), username = 'navyasri', role='admin' 
WHERE user_id = 10;
```

---

## 🛡️ Secure Version — Defense Techniques

The secure version does not rely on a single fix — it layers multiple independent defenses so that bypassing one layer does not mean the attack succeeds. Here is every technique applied and exactly how it stops each attack.

---

### 1. Parameterized Queries (Prepared Statements)

The single most important defense in the entire backend. Instead of building a SQL string by gluing user input directly into it, parameterized queries keep the SQL structure and the user-supplied values completely separate. The query's shape is defined first using placeholders. The actual user values are only passed in at execution time as a separate argument — the database driver handles escaping automatically, never allowing input to alter query structure.

**How it stops each attack:**

- **Login Bypass** — Even if someone types `' OR '1'='1' --` as their username, the database treats the entire string as a literal value to look up, not SQL to execute. The quotes and operators mean nothing to the query engine. No user matching that string exists, so login fails.
- **Boolean-Based SQLi** — `%' AND 1=1 -- -` becomes a plain product name search for the literal string `%' AND 1=1 -- -`. The `AND 1=1` never executes as a SQL condition — it is just characters inside a string value.
- **Time-Based SQLi** — `SLEEP(5)` is treated as a literal string value, not a function call. The database never interprets it as SQL, so no delay occurs and no timing signal is available to the attacker.
- **Second-Order SQLi** — Even when malicious content is already stored in the database and retrieved later, every subsequent query that uses that retrieved data is still parameterized. The stored SQL fragment is always treated as data, never executed.

---

### 2. SQL Injection Pattern Detector

Every incoming input is scanned by a regex-based detector before it ever reaches the database layer. It checks against a list of known attack signatures — boolean conditions like `OR 1=1`, SQL keywords like `UNION SELECT`, time-based functions like `SLEEP()` and `BENCHMARK()`, SQL comment markers like `--` and `/* */`, and statement chaining with `;`. If any pattern matches, the request is classified by attack type and immediately rejected with a 403 response.

**How it stops each attack:**

- **Login Bypass** — The payload `' OR '1'='1' --` matches both the boolean condition pattern and the SQL comment pattern. The request is blocked before any database call is made.
- **Boolean-Based SQLi** — `%' AND 1=1 -- -` matches the boolean condition pattern. The `--` suffix also triggers the comment injection pattern independently.
- **Time-Based SQLi** — `SLEEP(5)` directly matches the time-based function pattern. `BENCHMARK()` has its own dedicated pattern. Both are caught before the query runs.
- **UNION-Based SQLi** — Any `UNION SELECT` attempt is matched and stopped at this layer before it can probe database structure.

This acts as a second, independent line of defense. Even if a parameterized query would have safely neutralized the payload anyway, suspicious inputs never reach the database at all.

---

### 3. Attack Logger

Every time the pattern detector blocks a suspicious input, a structured log entry is written to an `attack_logs` database table. Each entry captures the attacker's IP address, the endpoint targeted, the exact payload submitted, the classified attack type, and the outcome status of the request. The logger itself uses parameterized queries for its own database write — it cannot be exploited to corrupt the log table.

**How it supports defense:**

This does not stop an attack in the moment, but it serves three critical functions. It gives administrators a full forensic audit trail of every attack attempt. It makes attack patterns visible — repeated attempts from the same IP, probing of the same endpoint, escalating payload complexity — so infrastructure-level responses like IP banning or rate limiting can be applied. Without logging, attacks are completely invisible.

---

### 4. Security Monitoring Dashboard

The secure version includes a built-in Security Monitoring Dashboard that simulates how real-world systems detect, record, and surface malicious activity. Rather than silently blocking attacks and moving on, the application maintains a persistent audit trail of every suspicious request made against it.

The `attack_logs` table serves as the backbone of this system. Every time the pattern detector intercepts a suspicious input, a structured record is written to this table before the request is rejected. The dashboard then exposes this data to administrators through two protected endpoints — one showing a chronological log of recent attack attempts, and one showing an aggregated summary of attack types ranked by frequency.

**Each log entry captures:**

- Timestamp of the attack attempt
- IP address of the requester
- User ID, if the request was made by an authenticated session
- The endpoint that was targeted
- The exact payload that was submitted
- The classified attack type — boolean SQLi, time-based SQLi, comment injection, and so on
- The outcome status of the request

**What this enables:**

The dashboard gives administrators visibility that would otherwise not exist. Without it, every blocked attack is silent — the application refuses the request and leaves no trace. With it, security teams can spot repeated probing from a single IP address, identify which endpoints are being targeted most aggressively, observe how payloads evolve across multiple attempts, and build a factual picture of the attack surface. It also demonstrates a foundational concept in real-world security operations: detection and response are just as important as prevention. Stopping an attack is necessary, but understanding that it happened — and who was responsible — is what makes a system defensible over time.

---

### 5. bcrypt Password Hashing

User passwords are never stored as plaintext or with a weak, fast hash like MD5 or SHA-1. Instead, bcrypt is used — an adaptive hashing algorithm built specifically for passwords. It automatically generates and embeds a random salt so two users with identical passwords produce completely different hashes. It is also intentionally computationally slow, making brute-force cracking impractically expensive even with dedicated hardware.

**How it stops attacks:**

This defense applies after an attack rather than during one. If an attacker successfully extracts the users table through SQL injection — bypassing every other layer — they still cannot recover the original passwords from bcrypt hashes within any practical timeframe. This converts a catastrophic credential breach into a far more contained incident, and prevents password reuse attacks across other services.

---

### 6. JWT-Based Authentication with Expiry

After a successful login, the server issues a signed JSON Web Token containing the user's ID, username, role, and a 12-hour expiry timestamp. This token is cryptographically signed with a server-side secret key. On every subsequent request to a protected route, the backend verifies the token's signature before trusting any of the claims inside it. If the signature is invalid, expired, or absent, the request is rejected immediately.

**How it stops attacks:**

- **Privilege Escalation via Forged Tokens** — The role embedded in the token is set from the database at login time and cryptographically locked. Even if an attacker decodes the token and manually changes `role` from `user` to `admin`, the signature verification will fail because they do not have the server's secret key. The modified token is rejected.
- **Unauthorized Route Access** — Every protected endpoint requires a valid token. There is no way to reach admin functionality by guessing a session ID, replaying an expired token, or making unauthenticated requests.
- **Stolen Token Damage Window** — Tokens expire after 12 hours, limiting the window of damage if a token is ever stolen.

---

### 7. Role-Based Access Control (RBAC)

Two decorator functions enforce who can access which endpoints at the route level. One checks that a valid token exists. The other additionally checks that the authenticated user carries an `admin` role. The role check is always performed against the cryptographically signed JWT — never against user-supplied input. Beyond role checks, individual routes also enforce ownership — a logged-in user can only access their own orders and profile, not any other user's data, regardless of their token being valid.

**How it stops attacks:**

- **Second-Order Privilege Escalation** — An attacker who manipulates their username during registration cannot reach admin endpoints because the role check happens on the JWT, not the username. Even if they somehow altered their database record, their token still encodes `role: user` from the original login.
- **Horizontal Privilege Escalation** — A regular user cannot view another user's order or profile by guessing their ID in the URL. The backend checks that the requesting user owns the resource before returning any data.

---

### 8. Whitelist-Only Field Updates

The profile update endpoint hardcodes exactly which columns are written on every update — username, email, and a timestamp. The `role` column is deliberately absent from the UPDATE statement and can never be reached through this endpoint. No matter what fields an attacker includes in their request body, only the permitted columns are ever written to the database.

**How it stops attacks:**

- **Second-Order Privilege Escalation via Profile Update** — In the vulnerable version, an attacker could submit `{"username": "x", "role": "admin"}` and have the role blindly written to the database. Here, the role field is simply never read from the request. The SQL statement is static, immutable, and exclusively updates safe fields.

---

### 9. Input Length Validation

Before any processing happens, all inputs are checked against maximum and minimum length thresholds. Search queries are capped at 50 characters. Reviews are capped at 500 characters. Usernames require at least 3 characters and passwords at least 6. Inputs that exceed or fall short of these bounds are rejected immediately, and oversized inputs on sensitive endpoints are also logged as attack attempts.

**How it stops attacks:**

Complex SQL injection payloads are almost always longer than a legitimate input. A `SLEEP` payload, a `UNION SELECT` chain, or a boolean injection with multiple conditions virtually always exceeds 50 characters. The length cap eliminates a significant portion of attack payloads before they reach the detector or the database. It also provides protection against denial-of-service attempts using extremely large inputs.

---

### 10. Query Execution Timeout

The product search query includes a MySQL optimizer hint that caps the query's maximum runtime directly at the database engine level. If any query on that endpoint takes longer than 1 second to execute, the database itself terminates it.

**How it stops attacks:**

Time-based SQL injection relies entirely on the database executing a `SLEEP()` command for a measurable duration. Even if a time-based payload somehow bypassed the pattern detector — through obfuscation or an encoding variant not yet covered — the database would kill the query before the sleep completes. The attacker receives a timeout error instead of a timed response. With no delay signal, time-based blind injection is rendered non-functional on this endpoint entirely.

---

### 11. Environment Variable Configuration

Database credentials — host, user, password, and database name — are never written in source code. They are loaded from environment variables at runtime, and the repository contains only a template file showing which variables are expected, with no real values present.

**How it stops attacks:**

If the source code is ever exposed — through an accidental public commit, a directory traversal vulnerability, or a misconfigured server — the attacker finds only variable names, not real credentials. They cannot connect directly to the database to bypass the application layer entirely. This enforces the foundational security principle of keeping secrets out of code.

---

### 12. Transactional Integrity with `autocommit=False`

Every database connection is opened with auto-commit disabled. No query result is permanently written to the database until an explicit commit is called. If an error occurs mid-operation, the connection is rolled back, undoing any partial changes before the connection is closed.

**How it stops attacks:**

If an attacker partially succeeds in executing a multi-step injection — for example, one that modifies a user's role as a side effect before the operation fails — auto-commit being disabled means the partial change is never persisted. The database is automatically restored to its state before the operation began, preventing it from being left in a corrupted or escalated state following a failed attack.

---

## 📊 Secure vs Vulnerable Comparison

| Attack | Vulnerable Approach | Secure Fix |
|---|---|---|
| Login Bypass | String concatenation in SQL | Parameterized queries + pattern detection |
| Boolean SQLi (TRUE) | Raw user input in LIKE clause | Parameterized queries + length validation + pattern detection |
| Boolean SQLi (FALSE) | No query sanitization | Parameterized queries + pattern detection |
| Time-Based SQLi (TRUE) | No query sanitization | Parameterized queries + pattern detection + query timeout |
| Time-Based SQLi (FALSE) | No query sanitization | Parameterized queries + pattern detection + query timeout |
| Second-Order SQLi | Stored data re-used directly in queries | Parameterized queries on retrieval + whitelist-only updates + RBAC |
| Privilege Escalation | Role field writable via update | Whitelist-only updates + JWT role locking + RBAC |
| Attack Visibility | No logging — attacks are silent | Attack logger + admin dashboard with full audit trail |

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Frontend | React.js |
| Backend | Python (Flask) |
| Database | MySQL |
| Security Focus | SQL Injection Prevention |

---

## 🚀 Getting Started

### Prerequisites

- Node.js & npm
- Python 3.x & pip
- MySQL Server

---

### Database Setup

```bash
mysql -u root -p
```

```sql
CREATE DATABASE ecommerce_security;
USE ecommerce_security;
SOURCE schema.sql;
```

---

### Running the Vulnerable Website

**Step 1 — Frontend**

```bash
cd Vulnerable_Website/frontend
npx create-react-app .
# Replace the generated /src folder with the repository's /src folder
npm install
npm start
```

**Step 2 — Backend**

```bash
cd Vulnerable_Website/backend
pip install -r requirements.txt
python app.py
```

---

### Running the Secure Website

**Step 1 — Frontend**

```bash
cd Secure_Website/frontend
npx create-react-app .
# Replace the generated /src folder with the repository's /src folder
npm install
npm start
```

**Step 2 — Backend**

```bash
cd Secure_Website/backend
pip install -r requirements.txt
python app.py
```

---

## ⚠️ Disclaimer

This project is built **strictly for educational purposes**, security research, and demonstrating secure coding practices as part of the CSL6010 Cybersecurity course.

> Do NOT use these techniques against real systems without explicit authorization.
> Unauthorized exploitation of vulnerabilities is **illegal and unethical**.

---

*Built by Penmetsa Navyasri & Polimetla Eshikha — IIT Jodhpur, CSL6010 Cybersecurity.*
