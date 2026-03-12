# Login Screen UI Design

**Feature**: 001-user-auth  
**Reference**: InTimePro login screen (mobile-first; responsive for web/tablet)

## Layout Overview

- **Top (~35–40%)**: Header/banner with gradient and optional illustration.
- **Bottom (~60–65%)**: White form area with rounded transition from banner.

## Header / Banner

- **Background**: Gradient from deep red/magenta (left) to blue/purple (right).
- **Bottom edge**: Subtle curve into the white form section (e.g. rounded clip or custom shape).
- **Content**: Optional illustration (e.g. laptop, character, communication motifs). If no asset, use gradient only.
- **Status bar**: System status bar (time, wifi, battery) remains visible; banner sits below it.

## Form Section (White Background)

- **Title**: "Login" — large, bold, black, left-aligned.
- **Spacing**: Ample horizontal padding; vertical spacing between sections.

### Email

- **Label**: "Email", smaller black text.
- **Field**: Single line, light gray border, rounded corners.
- **Placeholder**: "Enter your email" (light gray).

### Password

- **Label**: "Password", smaller black text.
- **Field**: Same style as email; input masked by default.
- **Trailing**: Eye icon to toggle show/hide password.
- **Placeholder**: "Enter your password" (light gray).

### Remember Me & Forgot Password

- **Row**: Horizontal layout.
- **Left**: Checkbox (unchecked by default) + label "Remember me" (black).
- **Right**: Text link "Forgot Password?" (reddish-orange), right-aligned.

### Primary Action

- **Button**: Full-width, rounded corners, solid blue background.
- **Label**: "Login", white, bold, centered.

### Separator

- **Line**: Horizontal rule with centered text "or with" in light gray.

### Social Login

- **Layout**: Two buttons side by side, equal width, small gap.
- **Style**: White background, light gray border, rounded corners.
- **Left button**: Microsoft logo + "Microsoft" (black text).
- **Right button**: Google "G" logo + "Google" (black text).

## Styling Notes

- **Colors**: Banner gradient (red/magenta → blue/purple); primary button blue; Forgot Password link reddish-orange; borders and secondary text light gray.
- **Accessibility**: Sufficient contrast; touch targets ≥ 44pt; support dynamic text and high contrast where applicable.
- **Loading/errors**: Show loading on primary button during submit; show error message below form or above button (per Phase 3 tasks).

## Assets (Optional)

- Header illustration: place under `assets/images/` and reference from login screen when available.
- Microsoft and Google logos: use official icon assets or packaged icons (e.g. from design system or `flutter_svg`/image assets).

## Implementation Reference

- **Screen**: `lib/features/auth/presentation/login/login_screen.dart`
- **Tasks**: T016 (form UI), T028 (Forgot Password link), T032 (social buttons).
