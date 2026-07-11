---
name: flutter-widget-theming
description: >-
  REQUIRED for widget/UI in lib/. Load .cursor/rules/flutter-widget-theming.mdc,
  map every Text to a TextTheme extension getter from fonts.dart (full table in
  rule), import fonts.dart, use ThemeColors/Gradients/Responsiveness. Use when
  creating widgets, screens, Figma UI, TextTheme, or design tokens.
---

# Flutter widget theming

## When this skill applies

Any new or edited **widget, screen, or layout** under `lib/` that contains `Text`, `Icon`, `Padding`, `Container` decoration, or colors.

## Step 0 — Load the rule

Read **`.cursor/rules/flutter-widget-theming.mdc`** end-to-end. The **ThemeExtension table** there lists all **36** `textTheme.<getter>` names in the same order as `lib/core/presentation/themes/fonts.dart`.

## Step 1 — Typography mapping (required output before code)

For **each** `Text` (or `TextSpan`) you will add, write one line:

```text
<widget/label> → textTheme.<getterFromTable> [+ copyWith(height/overflow only if needed]
```

Rules:

- **Search the ThemeExtension table first** — use an existing getter; do not skip to `copyWith(color: …)`.
- Import: `import 'package:ardent_mds/core/presentation/themes/fonts.dart';`
- In `build`: `final textTheme = Theme.of(context).textTheme;`
- Use: `style: textTheme.bodyLargeGrey800` (example)

Common picks (see full table in the rule):

| UI need | Getter |
|---------|--------|
| Filled button label | `bodyLarge500` |
| Outlined / secondary button label (14px w600) | `bodyMedium600` |
| Card title / bookmark name (16px grey800) | `bodyLargeGrey800` |
| Card emphasis 16px w600 | `bodyLarge600` |
| Subject / secondary 16px grey | `bodyLargeGrey500`, `bodyLargeGrey600`, `bodyLargeGrey700` |
| Meta / chapter / question ID (14px grey600) | `bodyMediumGrey600` |
| Compact title (14px grey500, w500 base) | `titleSmallGrey500` |
| Compact title semibold (14px) | `titleSmall600` |
| Section title 20px grey | `titleLargeGrey800` |
| Semibold section title 20px | `titleLarge600` |
| Auth / status hero (30px w700) | `displayMedium700` |
| Greeting / page title | `displaySmallGrey800` |
| Drawer name | `headlineSmallGrey600` |
| Drawer footer / chip | `titleSmall600` |
| Tab chip label | `titleSmallGrey800` |
| Badge / chip 12px w600 | `labelLarge600` |
| Link / accent small | `bodySmallPrimary600` |
| Snackbar on colored surface | `titleLargeWhite` |
| Text on primary button (14px white) | `bodyMediumWhite` |
| Form label / input text | `bodyLargeGrey600` |
| Form hint | `bodyMediumGrey600` |
| Watermark / legal italic | `labelSmallBlackItalic` |

## Step 2 — Colors, gradients, spacing

- Colors → `ThemeColors.*` (never raw hex unless user confirmed exception).
- Gradients → `Gradients.*`.
- Width/height/padding/radius/icon → `16.w`, `12.s`, `20.ics`, etc. from `responsiveness.dart`.

## Step 3 — Confirm with user

Present the Step 1 table + spacing/color tokens. Wait for confirmation (unless user said to proceed without asking).

## Step 4 — Implement

```dart
import 'package:ardent_mds/core/presentation/themes/fonts.dart';

// in build:
final textTheme = Theme.of(context).textTheme;

Text('Hello', style: textTheme.bodyLargeGrey800);
Text('Save', style: textTheme.bodyLarge500);
Text(
  'Long copy…',
  style: textTheme.bodyMediumGrey600.copyWith(height: 1.4), // copyWith OK for height only
);
```

## Step 5 — Self-check before finishing

- [ ] `fonts.dart` imported in every UI file with `Text`
- [ ] No `TextStyle(fontSize:` / `fontWeight:` / `color:` literals for themed text
- [ ] No `textTheme.bodyX!.copyWith(color: ThemeColors.Y)` when `bodyXGreyY` or `bodyX600` exists
- [ ] No `titleSmall!.copyWith(fontWeight: FontWeight.w500)` — base `titleSmall` is already w500; use `titleSmallGrey500`
- [ ] ThemeExtension getters named in reply match the rule table (36 rows)
- [ ] Layout uses `.w` / `.s` / `.ics` etc., not raw doubles

## Wrong vs right

```dart
// ❌ WRONG
Text('Title', style: textTheme.titleMedium!.copyWith(color: ThemeColors.grey800));
Text('Subject', style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w500));
Text('Title', style: TextStyle(fontSize: 18.f, fontWeight: FontWeight.w500, color: ThemeColors.grey800));

// ✅ RIGHT
Text('Title', style: textTheme.titleMediumGrey800);
Text('Subject', style: textTheme.titleSmallGrey500);
```

## New getter

If the same style appears 2+ times and no row fits: add getter to `fonts.dart` `extension ThemeExtension on TextTheme`, add a row to `.cursor/rules/flutter-widget-theming.mdc` (keep table order matching `fonts.dart`), then use it.
