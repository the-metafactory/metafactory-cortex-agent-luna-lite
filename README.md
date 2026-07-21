# Luna-Light

**A ready-to-run assistant for your own [cortex](https://github.com/the-metafactory/cortex) stack — one `arc install` away.**

Luna-Light is the front door to running your own assistant. It ships a clean,
capable, general-purpose **Luna** persona + agent fragment that installs onto a
cortex stack you control. No Discord app required, no private data, no
federation — a real assistant you can talk to, and grow into your own.

## What you get

- A **Luna** agent (`@luna`) — a direct, warm, capable chat assistant.
- **Surface-neutral**: bind her to a web surface, a Discord channel, or dispatch
  to `@luna` over the bus directly. Your surface, your choice.
- **In-process**: she runs under your cortex daemon and shares your stack's
  identity. She mints no credentials and takes no privileged actions on her own.
- **Content-safe**: nothing here is specific to any person or org. It's yours to
  adopt and make your own.

## Prerequisites

You need a cortex stack. If you don't have one yet:

```bash
arc install cortex
cortex stack create <your-slug> --apply     # scaffolds a config-split stack
# stand up the bus + start the daemon — see cortex docs (bootstrap runbook)
```

Luna-Light requires **cortex >= 6.9.0**.

## Install

```bash
arc install luna-light
# or, from source:
arc install https://github.com/the-metafactory/metafactory-bundle-luna-light
```

This drops the persona + fragment into `~/.config/cortex/`, then signals your
running daemon to pick Luna up (`cortex agents reload`). Say hi to `@luna`.

## Bind her to a surface

Luna is surface-neutral. To put her on a surface, add her to your stack's
`surfaces/surfaces.yaml`. Discord example:

```yaml
surfaces:
  discord:
    - agent: luna
      stack: <your-slug>
      binding:
        token: __YOUR_BOT_TOKEN__
        guildId: ...
        agentChannelId: ...
```

Or leave her surface-unbound and dispatch to `@luna` over the bus.

## Growing into the full Luna

This is the *light* edition — deliberately a starting point:

- **Memory:** connect an AgentState blueprint (`state: { blueprint: AgentState }`
  on the fragment) so Luna remembers across sessions.
- **Your context + skills:** project your own identity, knowledge, and skills in
  via [soma](https://github.com/the-metafactory/soma) — that's what turns "a
  Luna" into *your* Luna.

## What this is built on

Modeled on the shipped `pier` onboarding-concierge bundle (the reference arc
`type: agent` bundle). Same pattern: an in-process cortex agent, persona +
fragment, lifecycle hooks, no self-minted credentials.

---

_Part of the metafactory ecosystem. Install with [arc](https://github.com/the-metafactory/arc)._
