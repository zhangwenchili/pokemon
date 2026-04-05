# Description of the Application Flow

This document summarizes how the Pokémon web app and its JSON API behave from a user and system perspective. It reflects the current routes, controllers, and domain rules in this repository.

## Purpose

Authenticated players browse wild Pokémon, catch them into a personal **repo**, move up to six of them onto a **team**, view species in a **Pokédex**, and manage their **profile** (avatar). The **Phase 2 API** (`/api/v1`) exposes the same gameplay for a separate client using Devise session cookies.

## Core Concepts

| Concept | Meaning |
|--------|---------|
| **Species** | A Pokédex entry (name, artwork URL, Pokédex number, elemental types). |
| **Instance** | A concrete Pokémon: nickname, level, HP (`instance_statuses.hit_point`), linked to one **species**. |
| **Wild** | `instances.user_id` is `NULL` — anyone signed in may catch it. |
| **Repo** | Instances **owned** by the user but **not** assigned to a team slot. |
| **Team** | Up to **six** instances linked via `user_team_slots` with `slot_index` 0–5. |

## Entry and Authentication (Web)

1. **Root (`/`)** renders the Devise sign-in page (`Users::SessionsController#new`).
2. **Register (`/register`)** creates a user; Devise signs them in and redirects to the wild list.
3. **Sign in (`/login`)** uses **username** + password (Devise/Warden). Success redirects to **`/wild`**.
4. **Sign out (`DELETE /logout`)** clears the Devise session and returns to sign-in.
5. All gameplay routes are protected by **`authenticate_user!`** in `ApplicationController`. Unauthenticated requests redirect to `/login`.

The API uses the same `User` model but establishes identity via **Devise `sign_in`** on `/api/v1/auth/login` and `/api/v1/auth/register`; it does **not** rely on the legacy `session[:user_id]` pattern.

## Main Navigation (Signed-In Web)

After login, the layout shows tabs:

- **Wild Pokémon** (`GET /wild`) — paginated list (50 per page) of **wild** instances (`user_id` null).
- **Team** (`GET /team`) — up to six instances ordered by `slot_index` (not paginated).
- **Repo** (`GET /repo`) — owned instances **not** on the team (50 per page).
- **Pokédex** (`GET /species`, `GET /species/:id`) — species list (50 per page) and detail.

The header also links to **Profile** (`GET /patch /profile`) and **Log out**.

## Instance Detail Page (`GET /instances/:id`)

**Visibility**

- **Wild** instances: any signed-in user may open the page.
- **Owned** instances: only the owning user may open the page; others are redirected to `/wild`.

**Actions (POST member routes)**

State on the page drives which buttons apply (mirrored in the API `meta` object):

1. **Catch** — Only if the instance is **wild**. Sets `user` to the current user (instance lands in **repo**). On the **API**, a catch notification email is enqueued (`deliver_later`).
2. **Move to repo** — Only if the instance is on the **team** for this user. Removes the `user_team_slot` row.
3. **Move to team** — Only if the instance is in the **repo** (owned, not on team) **and** the user has **fewer than six** team slots. Creates a `user_team_slot` with the next free `slot_index` in 0..5.
4. **Release** — Only if owned and either on **team** or in **repo**. Destroys the instance (and dependent status/slot). Web flow redirects to **repo** after success.

Each action redirects back to the instance show page with flash feedback (except release → repo).

## Profile Flow

- **`GET /profile`** — Shows current user, avatar, and a form to upload a new avatar (PNG/JPEG/GIF/WebP, max 5 MB per model validation).
- **`PATCH /profile`** — Updates `avatar` via Active Storage; on failure re-renders the form with errors.

## API Flow (Phase 2, `/api/v1`)

The JSON API parallels the web app:

| Area | Endpoints (summary) |
|------|---------------------|
| Auth | `POST /auth/register`, `POST /auth/login`, `DELETE /auth/logout` |
| Profile | `GET` / `PATCH /profile` (multipart avatar on patch) |
| Lists | `GET /wild_pokemons`, `GET /team`, `GET /repo`, `GET /species` (+ pagination meta where applicable) |
| Instance | `GET /instances/:id` with `data` + `meta` for UI rules; `POST` catch / move_to_repo / move_to_team / release |

Responses use structured JSON (see `openapi/openapi.yaml`). Clients must send **session cookies** for protected routes (`credentials: 'include'` from browsers).

## Email

When an instance is **caught via the API**, `CatchNotificationMailer` sends a notification to the user’s **email** asynchronously. Outbound delivery requires SMTP environment variables as described in `.env.example` and `config/initializers/smtp_mail.rb`.

## Pagination

- **Wild list, repo, species index:** 50 items per page (Pagy offset).
- **Team list:** not paginated (max six rows by design).

## Health Check

`GET /up` is used for load balancer / platform health checks and does not require authentication.
