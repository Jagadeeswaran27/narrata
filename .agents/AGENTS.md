# Workspace Rules

## Widget Rules
- **Modular Widgets**: Widgets must be aggressive about modularity. Break down complex widgets into smaller, reusable components.
- **Reusable Widgets**: Aggressively extract common UI patterns (like dividers, text prompts, buttons, etc.) into reusable widgets in `lib/core/widgets/` to avoid code duplication across screens. Always check if a widget exists before building a new one.
- **File Length**: Files should not be lengthy. If a file grows too large, extract components or logic into separate files to maintain readability and modularity.

## Import Ordering
Imports in Dart/Flutter files must strictly follow this order:
1. Flutter's internal package imports (e.g., `dart:`, `package:flutter/`)
2. *Empty Line*
3. External package imports (e.g., `package:provider/`, `package:http/`)
4. *Empty Line*
5. Local file imports (must use absolute paths `package:app_name/`, no relative paths)
