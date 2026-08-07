# Password Reset Implementation Plan

## Goal
Implement a password reset flow that mirrors the current login page design. It will send a secure OTP to the user's email using a Google App email integration. The OTP and its expiration (default 5 minutes) will be backed by a new database table and configured via `.env` variables.

## Socratic Gate (Open Questions)

### [P0] **OTP Database Design**
**Question:** Should we create a single `PasswordResets` table that references users polymorphically (since you have separate `admins`, `stock_managers`, and `order_receivers` tables), or add `reset_otp` and `reset_expires_at` columns directly to each of those existing tables?
**Why This Matters:**
- Polymorphic table keeps the auth logic centralized.
- Columns on existing tables avoid joins but duplicate schema.
**Options:**
| Option | Pros | Cons | Best For |
|--------|------|------|----------|
| Polymorphic Table | Centralized logic, cleaner schema | Requires polymorphic relationships | Scalable auth |
| Add Columns | Simpler queries | Schema duplication across 3 tables | Quick implementation |

**If Not Specified:** We will create a `PasswordResets` table with `user_type`, `user_id`, `otp_digest`, `expires_at` to keep the user tables clean.

### [P1] **Reset Flow UX**
**Question:** Should the email contain a 6-digit code that the user manually types into the reset page, or a "magic link" that automatically verifies the OTP when clicked?
**Why This Matters:**
- Magic link requires a specific GET route to handle the token.
- Manual entry requires a 2-step UI on the reset password page.
**Options:**
| Option | Pros | Cons | Best For |
|--------|------|------|----------|
| 6-Digit Code | Simple state, easy to debug | User has to copy-paste | High security |
| Magic Link | Best UX (1-click) | URL might expire/be truncated by email clients | Seamless UX |

**If Not Specified:** We will implement a 6-digit numeric code for manual entry, which is the most robust and secure approach.

### [P2] **Email Delivery Mechanism**
**Question:** By "Google app mail", do you mean standard SMTP via ActionMailer using a Google App Password, or using the official Google Workspace/Gmail API gem?
**Why This Matters:**
- SMTP only needs 2 `.env` variables (`SMTP_USERNAME`, `SMTP_APP_PASSWORD`).
- Gmail API requires Google Cloud Console setup and OAuth JSON keys.
**Options:**
| Option | Pros | Cons | Best For |
|--------|------|------|----------|
| SMTP App Password | Extremely simple setup | Google sometimes restricts SMTP | Standard apps |
| Gmail API | Enterprise reliability | Complex OAuth setup | High volume |

**If Not Specified:** We will use standard ActionMailer SMTP with a Google App Password, adding variables like `GMAIL_USERNAME` and `GMAIL_APP_PASSWORD` to `.env`.

---

## Proposed Changes

### 1. Database & Models
- `PasswordReset` Model: Create a migration for a new table.
  - Fields: `user_type` (string), `user_id` (string), `otp_digest` (string), `expires_at` (datetime).
  - Include an index on `[user_type, user_id]`.
- Logic in model: Add `valid_otp?` method, hash the OTP before saving (using `bcrypt` or `Digest::SHA256`).

### 2. UI / Views
- **Reset Password Page (`app/views/login/forgot_password.html.erb`)**:
  - Mirror the `login-container` and SVG curves from `login/index.html.erb`.
  - Multi-step JS form:
    1. Enter Email.
    2. Enter OTP (shown after email is verified).
    3. Enter New Password.

### 3. Controllers
- `PasswordResetsController`:
  - `POST /password_resets` (generate OTP and send email).
  - `POST /password_resets/verify` (verify OTP and update password).

### 4. Mailer
- `UserMailer`: Create a `password_reset_email(user, otp)` mailer action.
- Configure `config/environments/development.rb` and `production.rb` to use SMTP via `.env` variables.

### 5. Environment Variables (`.env`)
- `GMAIL_USERNAME`
- `GMAIL_APP_PASSWORD`
- `OTP_EXPIRATION_MINUTES` (default 5)

## Verification Plan
1. Ensure the reset page visually matches the login page perfectly.
2. Generate an OTP for a stock manager account and verify it is saved securely (hashed) in the database.
3. Test that entering an incorrect OTP or an expired OTP (simulated via DB manipulation) correctly returns an error.
4. Verify password is successfully updated and user can subsequently log in.
