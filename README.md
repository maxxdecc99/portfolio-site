# portfolio-site

My personal portfolio, live at **https://maxxdeceuninck.dev**

![Screenshot of the site](screenshot_site.png)

I first built this site in Framer, then rebuilt it by hand to learn the full path from code to a live cloud service. This repo has the site itself plus everything needed to build and deploy it.

## Stack

- Plain HTML and CSS, no framework, no JavaScript
- nginx in a Docker container
- Google Cloud Run (europe-west4, Netherlands)
- GitHub Actions for deploys
- Cloudflare for DNS

## Choices I made

- nginx runs as a non-root user. Site files and config are owned by root and read-only, so even a compromised web server can't change them.
- `.dockerignore` is an allowlist, so only the site files and nginx config get into the image.
- Strict security headers, including a Content Security Policy that blocks all scripts and external resources. Scores A+ on securityheaders.com.
- GitHub Actions logs in with Workload Identity Federation instead of a service account key. There's no long-lived secret that can leak, and only pushes to `main` in this repo can deploy.
- Three separate service accounts: one to deploy, one to build, one to run the site. Each has only what its job needs. The runtime account has no permissions at all, so a compromised container gets a token that can't do anything.
- Max 2 instances. Under heavy load the site may slow down, but the bill can't run away.
- The Cloudflare proxy is off, because Cloud Run domain mapping needs direct DNS for its certificate. That also means no Cloudflare DDoS protection, which I accept for a portfolio.
- The domain doesn't send email, so SPF and DMARC reject anything pretending to come from it.
- System fonts only, no external scripts or trackers.
- Respects reduced-motion settings and works with keyboard navigation.

## Run it locally

```bash
docker build -t portfolio-site .
docker run --rm -p 8080:8080 portfolio-site
```

Then open http://localhost:8080.

## Deploy

Every push to `main` that changes the site deploys automatically through GitHub Actions (`.github/workflows/deploy.yml`). README-only changes are skipped. The workflow authenticates to Google Cloud without stored keys, then Cloud Build builds the image and Cloud Run serves it with a Google-managed certificate.

## Known limitations

- Cloud Run domain mapping is still in Preview, and it doesn't let me disable TLS 1.0/1.1. Firebase Hosting or a load balancer would fix that.

## Next up

- Terraform for the infrastructure
- TLS 1.2+ only, through Firebase Hosting or a load balancer

---

Built with AI as a learning partner. The design decisions and debugging are mine, and I can explain every line.
