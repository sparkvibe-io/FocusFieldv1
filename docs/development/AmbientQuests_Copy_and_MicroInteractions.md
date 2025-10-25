# Ambient Quests – Copy and Micro-Interactions (v1)

Tone: Friendly, compassionate, minimal. Avoid shame. Encourage small wins.

## Onboarding
- Title: "Make a gentle pocket of quiet."
- Body: "We never record audio. We only measure loudness to help you shape your space."

## Start session
- Primary: "Start quiet time"
- Sub: "We’ll track the calm, you enjoy the focus."

## Spike detected (subtle toast)
- "Noise bumped up — you’re okay. Try closing a door or taking a breath."

## Recovery
- "Nice recovery — calm returned."

## End sheet (success)
- "You earned {quietMin} Quiet Minutes • Ambient Score {score}%"
- Tip (1-liner): "Your best sessions are under {db} dB."

## End sheet (missed)
- "Showing up counts. Want to try a shorter goal next?"
- CTAs: "Shorten tomorrow’s goal" / "Done"

## Quest capsule
- "Today: Earn {goalMin} Quiet Minutes at {requiredScore}% calm or higher."

## Threshold suggestion
- "Want to try {db} dB today? You’ve been nailing it."

## Freeze day
- "We saved today for you. Your streak is safe."

## Share card caption
- "I earned {quietMin} Quiet Minutes with an {score}% Ambient Score this week."

---

# Micro-Interactions & Haptics

- Start session: light impact (iOS .light, Android KEYBOARD_TAP)
- Spike: subtle tick once per 15s max (rate-limited)
- Recovery: soft success tap
- Goal reached: gentle success + confetti micro-burst on ring (≈600ms)
- End session: medium impact; if success, slow ring glow (≈1.2s)

Animations
- Ring progress eases with cubic in/out.
- Ambient Score ticks appear as tiny dots along the ring every 5% recoveries.
- Quest capsule fills horizontally with subtle shimmer on completion.

Accessibility
- All haptics mirrored with toasts/VoiceOver/TalkBack labels.
- High-contrast mode swaps shimmer for solid fill.
- Dynamic Type scales labels; ring retains legibility at smallest width.
