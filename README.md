<picture>
  <source media="(prefers-color-scheme: dark)" srcset=".github/assets/banner-dark.png">
  <img src=".github/assets/banner.png" alt="Garage" width="100%">
</picture>

<p align="center">
  <a href="https://github.com/junkerderprovinz/garage/actions/workflows/build.yml"><img src="https://img.shields.io/github/actions/workflow/status/junkerderprovinz/garage/build.yml?branch=main&label=Build&style=for-the-badge&logo=githubactions&logoColor=white" alt="Build" height="36"></a>&nbsp;
  <a href="https://git.deuxfleurs.fr/Deuxfleurs/garage"><img src="https://img.shields.io/badge/Upstream-Garage-e8873a?style=for-the-badge&logo=rust&logoColor=white" alt="Upstream Garage" height="36"></a>&nbsp;
  <a href="https://github.com/khairul169/garage-webui"><img src="https://img.shields.io/badge/WebUI-garage--webui-1d99f3?style=for-the-badge&logo=go&logoColor=white" alt="garage-webui" height="36"></a>&nbsp;
  <a href="https://ca.unraid.net/apps/garage-17mn9vl03a3cot"><img src="https://img.shields.io/badge/Unraid-Template-f15a2c?style=for-the-badge&logo=unraid&logoColor=white" alt="Unraid" height="36"></a>&nbsp;
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-AGPL--3.0-yellow?style=for-the-badge&logo=gnu&logoColor=white" alt="License" height="36"></a>
</p>

<p align="center">
<b>Garage</b>, a lightweight, S3-compatible distributed object store, plus its
web admin panel, bundled into <b>one container</b> for Unraid. Both are the
official upstream binaries, unmodified, wired together with s6-overlay. No
manual CLI setup: single-node layout, S3 key and bucket are all created
automatically on first boot.
</p>

<!-- download-buttons: written by scripts/gen_download_buttons.py -->
<p align="center">
  <a href="https://ca.unraid.net/apps/garage-17mn9vl03a3cot"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(0,0,841.9,245.3))" alt="Install from Unraid&#x27;s Community Applications" width="160" height="46.618"></a>
  &nbsp;
  <a href="https://hub.docker.com/r/junkerderprovinz/garage/"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(866,0,841.9,245.3))" alt="Run it with Docker" width="160" height="46.618"></a>
  &nbsp;
  <a href="https://github.com/junkerderprovinz/garage/releases/latest"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(1732,0,841.9,245.3))" alt="Download the source archive" width="160" height="46.618"></a>
</p>
<!-- /download-buttons -->

<br>

<p align="center">
A one-knight job: I build it, keep it running, work through the issues and add what people ask for, until nothing is missing. It is free, with no accounts, no telemetry, no ads and no paid tier. No asterisk anywhere. Nothing readable ever leaves your own walls. Forged on evenings and weekends, with heart and stubbornness.
</p>

<p align="center">
If it has earned a place on your server or computer, toss a coin to your knight: it helps cover the costs and keeps the project alive. It also makes this knight's heart beat a little faster. Three ways below, whichever suits you.
</p>

<!-- give-buttons: written by scripts/gen_download_buttons.py -->
<p align="center">
  <a href="https://buymeacoffee.com/junkerderprovinz"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(2598,0,841.9,245.3))" alt="Buy me a coffee" width="160" height="46.618"></a>
  &nbsp;
  <a href="https://www.paypal.com/donate/?hosted_button_id=76FVV52TKXTUS"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(3464,0,841.9,245.3))" alt="PayPal" width="160" height="46.618"></a>
  &nbsp;
  <a href="https://junkerderprovinz.github.io/junkerderprovinz/"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(4330,0,841.9,245.3))" alt="Donate with crypto" width="160" height="46.618"></a>
</p>
<!-- /give-buttons -->

<br>

## Table of Contents

1. [What it looks like](#1-what-it-looks-like)
2. [What it does](#2-what-it-does)
3. [Getting started](#3-getting-started)
4. [How AI is used here](#4-how-ai-is-used-here)
5. [Support this project](#5-support-this-project)

<br>

## 1. What it looks like

The buckets, keys and files in these pictures are made up.

<p align="center">
  <img src=".github/assets/screenshots/garage-1.png" alt="The Garage admin panel in a browser, listing four buckets with their size and object count" width="100%">
  <br><em>The admin panel lists every bucket with its size and object count</em>
</p>

<p align="center">
  <img src=".github/assets/screenshots/garage-2.png" alt="The object browser of the admin panel inside a bucket, showing three backup archives" width="100%">
  <br><em>The object browser opens any bucket, with upload and download in the browser</em>
</p>

<br>

## 2. What it does

- **Garage and its admin panel in one install.** [Garage](https://git.deuxfleurs.fr/Deuxfleurs/garage) is a lightweight, S3-compatible object store. [garage-webui](https://github.com/khairul169/garage-webui) runs beside it in the same container, so buckets, keys and cluster health are one click away. Garage's own Community Applications listings split the server and the panel across three templates; this is one.
- **No terminal step.** The container runs Garage in single-node mode, which creates the cluster layout by itself. The access key, the secret key and a first bucket come from the template fields on the first start.
- **The official binaries, unmodified.** Both are copied from their upstream images and wired together with s6-overlay. None of it is rebuilt from source.
- **Any S3 client works.** rclone, restic, Kopia, Duplicati or your backup tool of choice talk to port 3900.

<br>

## 3. Getting started

On Unraid, install Garage from [Community Applications](https://ca.unraid.net/apps/garage-17mn9vl03a3cot), fill in an access key and a secret key, and start it. Anywhere else, one container is enough:

```sh
docker run -d --name garage -p 3900:3900 -p 3909:3909 \
  -e ACCESS_KEY=GK$(openssl rand -hex 12) \
  -e SECRET_KEY=$(openssl rand -hex 32) \
  -e BUCKET=backups \
  -v /path/to/config:/config \
  -v /path/to/data:/data \
  junkerderprovinz/garage:latest
```

The log says `GARAGE IS READY` once it is up. The S3 endpoint is `http://<server>:3900` with the region `garage`, and the admin panel is on port 3909. An rclone remote for it looks like this:

```ini
[garage]
type = s3
provider = Other
access_key_id = YOUR_ACCESS_KEY
secret_access_key = YOUR_SECRET_KEY
endpoint = http://<server>:3900
region = garage
```

Back up `/config` and `/data` together. Losing `/config` keeps your objects but generates a new admin token and RPC secret on the next start.

<br>

## 4. How AI is used here

One knight builds this, and AI is one of the tools I work with, the same way I work with an editor or a compiler. It helps me write code and documentation and it checks my work, and that saves me a good many evenings. It does not make the decisions, though. I read and understand everything before it ships, and if something here breaks, that is on me and not on the tool.

You do not have to take my word for it. The code is open and every release note is written by hand. The issue tracker shows how problems actually get handled, including the ones I got wrong the first time. If you find something that is not right, open an issue and I will look at it.

<br>

## 5. Support this project

Questions? Check the [support thread](https://forums.unraid.net/topic/198811-support-junkerderprovinz-unraid-apps/). Bugs, ideas or feature requests? Please [open a GitHub issue](https://github.com/junkerderprovinz/garage/issues).

A one-knight job: I build it, keep it running, work through the issues and add what people ask for, until nothing is missing. It is free, with no accounts, no telemetry, no ads and no paid tier. No asterisk anywhere. Nothing readable ever leaves your own walls. Forged on evenings and weekends, with heart and stubbornness.

If it has earned a place on your server or computer, toss a coin to your knight: it helps cover the costs and keeps the project alive. It also makes this knight's heart beat a little faster. Three ways below, whichever suits you.

<!-- give-buttons: written by scripts/gen_download_buttons.py -->
<p align="center">
  <a href="https://buymeacoffee.com/junkerderprovinz"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(2598,0,841.9,245.3))" alt="Buy me a coffee" width="160" height="46.618"></a>
  &nbsp;
  <a href="https://www.paypal.com/donate/?hosted_button_id=76FVV52TKXTUS"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(3464,0,841.9,245.3))" alt="PayPal" width="160" height="46.618"></a>
  &nbsp;
  <a href="https://junkerderprovinz.github.io/junkerderprovinz/"><img src="https://raw.githubusercontent.com/junkerderprovinz/garage/main/.github/assets/download-buttons/buttons.svg?v=a82cc8264e34#svgView(viewBox(4330,0,841.9,245.3))" alt="Donate with crypto" width="160" height="46.618"></a>
</p>
<!-- /give-buttons -->

<sub>Garage is made by Deuxfleurs and garage-webui by khairul169; both ship here unmodified under their own licences.</sub>
