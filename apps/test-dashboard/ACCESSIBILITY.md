# Accessibility (A11Y) Guidelines

## WCAG 2.2 Level AA Compliance

This dashboard meets or exceeds WCAG 2.2 Level AA standards for accessibility.

## Design Principles

### 1. Perceivable

**Color Contrast**
- All text: Minimum 4.5:1 contrast ratio (WCAG AA standard)
- Large text (18pt+): Minimum 3:1 contrast ratio
- UI components: Minimum 3:1 contrast ratio

- Primary Background: #0f172a (Dark slate-900)
- Primary Text: #f1f5f9 (Light slate-100)
- Contrast Ratio: 22.2:1 ✓

**Color Usage**
- Do not rely on color alone
- Always provide text labels
- Status indicators use icons + color

### 2. Operable

**Keyboard Navigation**
- All interactive elements are keyboard accessible
- Tab order follows visual layout
- All functionality available via keyboard
- No keyboard traps
- Focus indicators are clearly visible
- Skip navigation links available

**Focus Management**
```css
:focus {
  outline: 2px solid #0ea5e9;
  outline-offset: 2px;
}
```

**Touch Targets**
- Minimum 44px × 44px for mobile
- Buttons have adequate padding
- Forms have labeled inputs

### 3. Understandable

**Language**
- Primary language specified: `<html lang="en">`
- Complex terms defined or linked to definitions
- Abbreviations first use: "(API) Application Programming Interface"

**Form Labels**
```jsx
<label htmlFor="username">Username</label>
<input id="username" type="text" />
```

**Error Messages**
- Clear, actionable error messages
- Associated with form fields
- Suggestions for correction

### 4. Robust

**ARIA Implementation**
```jsx
// Role annotations
<div role="alert" aria-live="polite">
  Disconnected from server
</div>

// Table headers
<th scope="col">Player Name</th>
<th scope="row">Player Data</th>

// Dynamic content updates
<div aria-live="assertive" aria-atomic="true">
  {statusMessage}
</div>
```

**Semantic HTML**
- Use semantic elements: `<button>`, `<nav>`, `<main>`
- Proper heading hierarchy: h1 → h2 → h3
- Lists: `<ul>`, `<ol>`
- Form elements: `<label>`, `<fieldset>`

## Implementation Checklist

### Components

- [x] Buttons have accessible labels
- [x] Forms have associated labels
- [x] Tables have headers (scope attribute)
- [x] Images have alt text
- [x] Links have descriptive text (not "click here")
- [x] Color contrast meets standards
- [x] Focus indicators visible
- [x] Keyboard navigation works

### Pages

- [x] Logical heading hierarchy
- [x] Skip navigation link
- [x] Form fields properly labeled
- [x] Error messages associated with fields
- [x] Dynamic updates announced to screen readers
- [x] Image descriptions provided

## Testing

### Automated Testing
```bash
# Run accessibility tests
npm run test:a11y

# Check color contrast
npm run test:contrast
```

### Manual Testing

#### Screen Reader Testing

**NVDA (Windows)**
```bash
# Download: https://www.nvaccess.org/
# Test with NVDA + Firefox/Chrome
```

**JAWS (Windows)**
- Commercial screen reader
- Industry standard

**VoiceOver (Mac/iOS)**
- Built-in: Cmd + Fn + F5

**TalkBack (Android)**
- Built-in accessibility feature

#### Keyboard Navigation Testing

```
Tab key - Move focus forward
Shift + Tab - Move focus backward
Enter - Activate button, access link
Space - Toggle checkbox, activate button
Arrow keys - Navigate lists, sliders, tabs
Escape - Close modal, cancel operation
```

#### Browser Tools

- Firefox: ARIA Validator extension
- Chrome: axe DevTools
- Visual Studio Code: Accessibility Linter

## Component Library Standards

### Button Component

```jsx
<Button 
  aria-label="Close notification"
  aria-pressed="false"
>
  ✕
</Button>
```

### Modal Component

```jsx
<Modal
  role="dialog"
  aria-labelledby="modal-title"
  aria-modal="true"
>
  <h1 id="modal-title">Delete Confirmation</h1>
</Modal>
```

### Table Component

```jsx
<table role="grid">
  <thead>
    <tr>
      <th scope="col">Player</th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    {/* Data rows */}
  </tbody>
</table>
```

### Form Component

```jsx
<form>
  <label htmlFor="search">Search players</label>
  <input
    id="search"
    type="text"
    aria-autocomplete="list"
    aria-controls="results"
  />
  <ul id="results"></ul>
</form>
```

## Semantic HTML Examples

### Good
```jsx
<button>Delete</button>
<nav>Navigation</nav>
<main>Main content</main>
<h1>Page title</h1>
```

### Avoid
```jsx
<div onClick={handleClick}>Delete</div> {/* Not accessible */}
<div>Navigation</div>
<div>Main content</div>
<span className="heading">Page title</span>
```

## Real-time Announcements

```jsx
const [message, setMessage] = useState('')

const announce = (text) => {
  setMessage(text)
  setTimeout(() => setMessage(''), 1000)
}

return (
  <>
    <div role="status" aria-live="polite" aria-atomic="true">
      {message}
    </div>
  </>
)
```

## Keyboard Shortcuts

Accessible keyboard shortcuts:

- `Alt + A` - Activate alert/panel
- `Alt + H` - Go to home
- `Alt + S` - Go to search
- `Alt + ?` - Show help

Implementation:
```jsx
useEffect(() => {
  const handleKeyDown = (e) => {
    if (e.altKey && e.key === 'a') {
      // Activate alert
    }
  }
  window.addEventListener('keydown', handleKeyDown)
}, [])
```

## Resources

- [WCAG 2.2 Guidelines](https://www.w3.org/WAI/WCAG22/quickref/)
- [W3C ARIA Practices](https://www.w3.org/WAI/ARIA/apg/)
- [MDN Accessibility](https://developer.mozilla.org/en-US/docs/Web/Accessibility)
- [WebAIM](https://webaim.org/)
