![Elixir CI](https://github.com/BreadBlog/core/workflows/Elixir%20CI/badge.svg)

# Blog Core

This is the API for my personal blogging platform. It was created using Phoenix Framework, a powerful web framework for Elixir.

# Privacy

TODO: link to blog post

# Deployment

I was initially toying with the idea of deploying the application using Gigalixir, a managed solution that is designed specifically for Elixir. My go to VPS solution has typically been Upcloud, so after getting it deploying on Gigalixir I decided to look into the pricing more. Here is a quick comparison:

| Memory (GB) | Database (GB) | Gigalixir ($/month) | Upcloud ($/month) |
|-------------|---------------|---------------------|-------------------|
| 1           | 20            | 450                 | 5                 |
| 8           | 128           | 3600                | 40                |

As you can see, not only is Gigalixir more expensive, but *magnitudes* more expensive. Since a lot of this work has been exploration of the Elixir/Phoenix stack, and whether it would be a good fit for consulting/freelancing, I wasn't ecstatic about the idea of future clients potentially paying $3600/month if they have to scale. There is no denying these managed solutions simplify a lot of the process though. So I gave it some thought:

1) Elixir (more specifically OTP) has high uptime & reliability, with built-in support for handling unhealthy processes
2) I have experience using the Nix Package Manager, so deploying via NixOps wouldn't be a stretch and would be a better fit for Elixir than Docker/Kubernetes
3) Upcloud has support for backing up the entire VM regularly, while still being magnitudes cheaper, guaranteeing data security
4) Elixir & OTP has services such as redis built-in, so managing said services becomes a development problem as opposed to a devops problem

Given all of this, it seemed like a no-brainer to try out VPS when there was such potential to provide future value to clients.

# Security

## Secrets

As mentioned above, one of the goals when building this API was to establish a potential workflow for future clients. So when it came to dealing with secrets, I gave it some thought and came up with the following properties I wanted my solution to satisfy:

- It had to be easily distributed
  - I want my future client to have complete access to all the resources they would need to deploy the application themselves. Not because I expect they will, but because I never want to hold a client hostage because of information I have withheld
- It had to be secure
  - Ideally multiple layers of security
- It must be easily injected into a nix derivation at deploy time as deploy keys

This narrowed down my ideas to the following:

1) Bitwarden (the password manager I use personally)
2) A gpg/git based solution (such as [git-crypt](https://github.com/AGWA/git-crypt) or [pass](https://www.passwordstore.org/))

I decided to go with (2), as it is more developer friendly and designed for this workflow. However, I didn't like the idea of committing secrets, even encrypted ones, in a public repo, and instead opted for a private `.secrets` submodule. This way other people are still free to checkout this code, but can't access the secrets, keeping my users safe.
