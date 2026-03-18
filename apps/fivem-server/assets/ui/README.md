# UI Assets

This directory contains user interface elements, icons, backgrounds, and resources.

## Structure

```
ui/
├── icons/           # UI icons (16x16 to 256x256)
├── backgrounds/     # Menu and UI backgrounds
├── hud/             # HUD elements and overlays
├── fonts/           # Custom fonts (.ttf, .otf)
├── images/          # Logos, badges, decorative images
├── components/      # NUI component files
├── html/            # HTML UI files
├── css/              # Stylesheets
└── js/              # JavaScript files
```

## File Guidelines

- **Icons**: 16, 32, 48, 64, 128, 256 pixel variants
- **Backgrounds**: 16:9 aspect ratio, 1920x1080 minimum
- **HUD**: Transparent PNG with alpha channel
- **Fonts**: TTF/OTF format, optimized subset
- **Images**: PNG for quality, JPG for backgrounds

## UI Categories

### Icons
```
icons/
├── job/             # Job-specific icons
├── inventory/       # Item icons
├── status/          # Status indicators
├── actions/         # Action buttons
└── misc/            # Miscellaneous icons
```

### Backgrounds
```
backgrounds/
├── menus/           # Menu backgrounds
├── loading/         # Loading screens
├── notifications/   # Notification panels
└── hud/             # HUD backgrounds
```

### HUD Elements
```
hud/
├── health/          # Health indicators
├── minimap/         # Minimap UI
├── speedometer/     # Speed displays
├── compass/         # Compass elements
└── timers/          # Timer displays
```

## Example Usage

### HTML/CSS UI
```lua
-- Send message to NUI
SendNUIMessage({
    show = true,
    type = 'menu',
    title = 'Server Menu',
    items = items_table,
})

-- Focus NUI
SetNuiFocus(true, true)
```

### Icon Usage
```lua
-- Display icon in menu
local iconPath = 'assets/ui/icons/job/police.png'
-- Use in NUI via img src or CSS background
```

### Font Integration
```css
@font-face {
    font-family: 'CustomFont';
    src: url('assets/ui/fonts/sans.ttf');
}

.menu {
    font-family: 'CustomFont';
}
```

## NUI Component Libraries

Recommended folder structure for component organization:

```
ui/components/
├── buttons/         # Button styles
├── inputs/          # Input fields
├── cards/           # Card components
├── modals/          # Modal dialogs
├── lists/           # List components
└── tables/          # Table components
```

## Asset Optimization

- Images: Compress to <100KB each
- Fonts: Subset to required characters only
- Total UI: Keep under 50MB
- Resolution: Use SVG where possible for scaling

## Color Schemes

Standard palette:

```javascript
const colors = {
    primary: '#0052CC',      // Blue
    secondary: '#6C757D',    // Gray
    success: '#28A745',      // Green
    warning: '#FFC107',      // Yellow
    danger: '#DC3545',       // Red
    info: '#17A2B8',         // Cyan
    light: '#F8F9FA',        // Light Gray
    dark: '#343A40',         // Dark Gray
};
```

## Performance Tips

- Lazy load UI components
- Cache frequently used images
- Minimize CSS/JS file sizes
- Use CSS sprites for multiple icons
- Optimize font loading with subsetting

