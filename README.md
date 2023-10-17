# Personal Blog

Hello there! This is JT's digital corner. While this blog has been continuously
evolving, I never hopped onto the "Under Construction" gif bandwagon. Every
piece of content you see here is my own expression.

🔗 **For the latest articles and updates, head over to
[jtarchie.com](https://jtarchie.com).**

## Getting Started

If you're curious about the tech behind the scenes, this site leverages a
personal site tool I developed named
[builder](https://github.com/jtarchie.builder).

### Local Setup (Mac OS)

To set things up locally or contribute:

```bash
brew bundle            # Install required packages
# Make your changes in posts
task                    # Preview them at http://localhost:8080
```

Once you're happy with the changes:

```bash
git add -A
git commit -m 'your helpful message here'
git push
```

### Deployment

The magic of deploying this site is orchestrated using Github Actions.
Cloudflare Pages serves as our trusted platform for static site hosting.
