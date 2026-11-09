# kwant on Railway

kwant — a self-hosted team of AI bots that share chats, hand work to each other and verify what they finish. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/TEMPLATE_CODE)

This repository packages [kwant](https://github.com/alexsergivan/kwant) (AGPL-3.0; upstream also offers a commercial licence) for Railway, following upstream's own `docker-compose.yml` (kwnt + Laya router + private Chromium). It is an independent community packaging, not affiliated with or endorsed by the kwant project.

## Services

| Service | Image | What it does |
|---|---|---|
| `kwnt` | `ghcr.io/onepush-dev/kwant:0.7.6` = official `ghcr.io/alexsergivan/kwnt:0.7.6` + start script | Web UI + API on port 8080 (`$PORT`), data on a volume at `/data` |
| `laya` | `ghcr.io/onepush-dev/kwant-laya:0.4.8` (upstream `docker/laya.Dockerfile`) | Model router that picks model/effort for bots set to `auto` (private only, ~2 GB RAM) |
| `browser` | `ghcr.io/onepush-dev/kwant-browser:0.7.6` (upstream `docker/browser.Dockerfile`) | The bots' private headless Chromium over CDP (private only) |

Changes from upstream: the kwnt start script chowns the root-owned Railway volume to uid 10001 and keeps CLI sign-ins on the same volume (`HOME=/data/.home`); Laya and the browser proxy listen dual-stack so they are reachable on Railway's IPv6 private network.

## Use it

1. Open `https://<your-domain>/`.
2. Choose to paste a token and use **`KWNT_API_TOKEN`** from the `kwnt` service's Variables tab (generated per deploy). The browser stays signed in for a year.
3. Add an Anthropic, OpenAI or xAI API key under **Settings → This space → Accounts** (or sign in to a CLI over `railway ssh`).
4. More devices: **Settings → Signed-in devices → Add a phone or browser**, or run `kwnt signin-link` over `railway ssh` on the `kwnt` service.

## Notes

- kwant's own `execute_shell` tool needs a Docker socket, so it is not available on Railway (same as upstream's Compose setup). The CLIs' own shell tools work inside the kwnt container.
- Laya is optional: if you remove the `laya` service, kwant falls back to keyword routing.
- Back up the `/data` volume (chats, bots, vault, token).
