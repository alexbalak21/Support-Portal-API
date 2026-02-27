
# API Documentation

Base URL: `http://localhost:8100`

---

## Authentication Endpoints

### Register User
**POST /api/auth/register**

Request: `{ "name": string, "email": string, "password": string }`

Response: `201 Created` — `{ "message": "User registered successfully", "data": string }`

Errors: 400 (Email in use/validation)

---

### Login
**POST /api/auth/login**

Request: `{ "email": string, "password": string }`

Response: `200 OK` — `{ "message": "Login successful", "data": { user, access_token, refresh_token } }`

Errors: 401 (Invalid credentials)

---

### Refresh Token
**POST /api/auth/refresh**

Request: `{ "refresh_token": string }`

Response: `200 OK` — `{ "message": "Token refreshed successfully", "data": { access_token, refresh_token } }`

Errors: 401 (Invalid/expired refresh token)

---

### Get Current User
**GET /api/auth/me**

Headers: `Authorization: Bearer {access_token}`

Response: `200 OK` — User info object

Errors: 401 (Unauthorized)

---

## User Endpoints

### List Users
**GET /api/users?role={roleId}**

Permission: `user.read`

Response: List of users (id, name)

---

### Get My User Info
**GET /api/users/me**

Permission: `user.read`

Response: User info with profile image

---

### Update My Info
**PATCH /api/users/me**

Request: `{ "name": string, "email": string }`

Response: `{ "name": string, "email": string }`

---

### Change My Password
**PATCH /api/users/me/password**

Request: `{ "currentPassword": string, "newPassword": string }`

Response: `{ "status": "success", "message": "Password updated" }`

---

### User Profile Image
**POST /api/users/profile-image** — Upload (multipart/form-data, field: file)
**GET /api/users/profile-image/{id}** — Get by id
**GET /api/users/profile-image/me** — Get my image
**DELETE /api/users/profile-image** — Delete my image

---

## Admin Endpoints

### Permissions
**GET /api/admin/permissions** — List (Permission: `admin.manage`)
**POST /api/admin/permissions** — Create (Permission: `admin.manage`)

### Roles
**GET /api/admin/roles** — List (Permission: `admin.manage`)
**POST /api/admin/roles** — Create (Permission: `admin.manage`)
**GET /api/admin/roles/{roleId}** — Get by id (Permission: `admin.manage`)
**PUT /api/admin/roles/{roleId}** — Update (Permission: `admin.manage`)

### Users
**GET /api/admin/users?role={roleId}** — List (Permission: `admin.manage`)
**POST /api/admin/users** — Create (Permission: `admin.manage`)
**GET /api/admin/users/{userId}** — Get by id (Permission: `admin.manage`)
**POST /api/admin/users/{userId}/roles** — Assign roles (Permission: `admin.manage`)
**DELETE /api/admin/users/{userId}/roles** — Remove roles (Permission: `admin.manage`)

### Priorities
**GET /api/admin/priorities** — List
**POST /api/admin/priorities** — Create
**GET /api/admin/priorities/{id}** — Get by id
**PUT /api/admin/priorities/{id}** — Update
**DELETE /api/admin/priorities/{id}** — Delete

---

## Ticket Endpoints

### Tickets
**GET /api/tickets** — List (Permission: `ticket.read`)
**GET /api/tickets/{id}** — Details (Permission: `ticket.read`)
**POST /api/tickets** — Create (Permission: `ticket.create`)
**PUT /api/tickets/{id}** — Update (Permission: `ticket.write` or self)
**GET /api/tickets/assigned/me** — Assigned to me (Permission: `ticket.read`)
**GET /api/tickets/assigned/{userId}** — Assigned to user (Permission: `ticket.read`)
**GET /api/tickets/status/{statusId}** — By status (Permission: `ticket.read`)
**GET /api/tickets/priority/{priorityId}** — By priority (Permission: `ticket.read`)
**GET /api/tickets/search?keyword=...** — Search by title (Permission: `ticket.read`)
**POST /api/tickets/create-for-user** — Create for user (Permission: `ticket.manage`)

---

### Ticket Messages
**GET /api/tickets/{ticketId}/messages** — List (Permission: `conversation.read`)
**POST /api/tickets/{ticketId}/messages** — Add (Permission: `conversation.reply`)

---

### Ticket Notes
**GET /api/notes/{ticketId}** — List (Permission: `note.read`)
**POST /api/notes** — Create (Permission: `note.create`)
**PUT /api/notes/{noteId}** — Update (Permission: `note.create` or `note.manage`)
**DELETE /api/notes/{noteId}** — Delete (Permission: `note.create` or `note.manage`)

---

## Status & Priority Endpoints

### Status
**GET /api/status** — List (Permission: `status.read` or `status.manage`)
**GET /api/status/{id}** — Get by id (Permission: `status.read` or `status.manage`)
**POST /api/status** — Create (Permission: `status.write` or `status.manage`)
**PUT /api/status/{id}** — Update (Permission: `status.write` or `status.manage`)

### Priorities
**GET /api/priorities** — List

---

## Miscellaneous

### Home & Health
**GET /** — Home message
**GET /health** — Health check

---

## Response Format

All API responses follow this structure:

```json
{
  "message": "Description of the result",
  "data": {}  // Optional, contains response data
}
```

## Token Information

- **Access Token:** Short-lived token for API requests (configured expiration)
- **Refresh Token:** Long-lived token to obtain new access tokens
- Access tokens must be included in the `Authorization` header as `Bearer {token}`
