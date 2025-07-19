# Dotfiles Improvement Tickets

This document contains all improvement tickets for the indie-dawg-dots repository, organized by priority and category. Each ticket is self-contained and can be worked on independently.

## 🚨 Critical Fixes (P0)

## ⚡ Performance Optimizations (P1)

## 🔒 Security Improvements (P2)

### TICKET-013: Add SSH Secrets Validation

**Priority:** P2 - Medium  
**Effort:** 20 minutes  
**Files:** `.config/zsh/.zshrc`  
**Problem:** Sources SSH secrets without validation  
**Solution:**

```bash
SSH_SECRETS="$HOME/.ssh/load_secrets.sh"
if [[ -f "$SSH_SECRETS" ]] && [[ -r "$SSH_SECRETS" ]] && [[ "$(stat -c %a "$SSH_SECRETS" 2>/dev/null || stat -f %p "$SSH_SECRETS")" == *"00" ]]; then
    source "$SSH_SECRETS"
else
    echo "Warning: SSH secrets file missing or has incorrect permissions"
fi
```

**Acceptance Criteria:**

- [ ] Validates file exists and is readable
- [ ] Checks file permissions (owner-only)
- [ ] Provides helpful warning if validation fails

---

### TICKET-014: Enable Git Commit Signing

**Priority:** P2 - Medium  
**Effort:** 30 minutes  
**Files:** `.gitconfig`  
**Problem:** No GPG signing configured for commits  
**Solution:**

- Add GPG configuration section
- Document GPG key setup process

```ini
[user]
    signingkey = YOUR_GPG_KEY_ID
[commit]
    gpgsign = true
[tag]
    gpgsign = true
```

**Acceptance Criteria:**

- [ ] GPG signing configuration added
- [ ] Documentation for key setup included
- [ ] Signing can be disabled per-repo if needed

---

## 🌍 Cross-Platform Compatibility (P2)

### TICKET-015: Create Platform-Specific Alias Files

**Priority:** P2 - Medium  
**Effort:** 45 minutes  
**Files:** `.config/zsh/.alias*`  
**Problem:** Platform-specific aliases mixed with common ones  
**Solution:**

1. Create `.config/zsh/.alias.common` for shared aliases
2. Move Linux-specific aliases to `.config/zsh/.alias.linux`
3. Move macOS-specific aliases to `.config/zsh/.alias.macos`
4. Update `.zshrc` to source appropriate files based on platform
   **Acceptance Criteria:**

- [ ] Three separate alias files created
- [ ] Aliases properly categorized
- [ ] Platform detection loads correct files

---

### TICKET-016: Add Command Existence Checks to Aliases

**Priority:** P2 - Medium  
**Effort:** 30 minutes  
**Files:** `.config/zsh/.alias`  
**Problem:** Aliases created for potentially missing commands  
**Solution:**

```bash
# Example pattern
command -v waybar &>/dev/null && alias rwaybar="killall waybar && waybar & disown"
command -v hyprpaper &>/dev/null && alias rpaper="killall hyprpaper && hyprpaper & disown"
```

**Acceptance Criteria:**

- [ ] All tool-specific aliases check command existence
- [ ] No errors when commands are missing
- [ ] Aliases only created when tools are available

---

## 📁 Organization & Cleanup (P3)

### TICKET-021: Expand README.md

**Priority:** P3 - Low  
**Effort:** 45 minutes  
**Files:** `README.md`  
**Problem:** README is only 27 bytes  
**Solution:**

- Add repository description
- Include installation instructions
- List required dependencies
- Add screenshots of configured tools
- Include troubleshooting section
  **Acceptance Criteria:**
- [ ] Comprehensive README created
- [ ] Installation steps documented
- [ ] Dependencies listed by platform
- [ ] Basic troubleshooting included

---

### TICKET-022: Clean Up Font Directory

**Priority:** P3 - Low  
**Effort:** 20 minutes  
**Files:** `fonts/` directory  
**Problem:** 33 font files with unclear usage  
**Solution:**

1. Audit which fonts are actually used
2. Remove unused font variants
3. Create fonts/README.md explaining font purposes
4. Consider moving to system fonts with symlinks
   **Acceptance Criteria:**

- [ ] Only necessary fonts retained
- [ ] Font usage documented
- [ ] Clear organization structure

---

### TICKET-023: Add Missing tmux Configuration

**Priority:** P3 - Low  
**Effort:** 30 minutes  
**Files:** `.config/tmux/.tmux.conf`  
**Problem:** No tmux config despite being mentioned as key tool  
**Solution:**
Create basic tmux configuration with:

- Modern keybindings
- Mouse support
- Better colors
- Status bar configuration
- Plugin management (TPM)
  **Acceptance Criteria:**
- [ ] tmux configuration created
- [ ] Works on both macOS and Linux
- [ ] Integrates with shell environment

---

## 🔧 Code Quality Improvements (P3)

### TICKET-024: Add LSP Error Handling

**Priority:** P3 - Low  
**Effort:** 30 minutes  
**Files:** `.config/nvim/lua/plugins/lsp.lua`  
**Problem:** No error handling when LSP servers fail  
**Solution:**

```lua
local function safe_setup(server, opts)
    local ok, err = pcall(lspconfig[server].setup, opts)
    if not ok then
        vim.notify(string.format("Failed to setup %s: %s", server, err), vim.log.levels.ERROR)
    end
end
```

**Acceptance Criteria:**

- [ ] All LSP setups wrapped in error handling
- [ ] User notified of failures
- [ ] Graceful degradation

---

### TICKET-025: Add Keybinding Descriptions

**Priority:** P3 - Low  
**Effort:** 15 minutes  
**Files:** `.config/nvim/lua/edo/keymaps.lua`  
**Problem:** Several keymaps lack descriptions  
**Solution:**

- Add descriptions to keymaps at lines 9, 24-25
- Ensure all keymaps have helpful descriptions
  **Acceptance Criteria:**
- [ ] All keymaps have descriptions
- [ ] Descriptions are clear and helpful
- [ ] Which-key integration works properly

---

### TICKET-026: Simplify Neovim Formatting Logic

**Priority:** P3 - Low  
**Effort:** 30 minutes  
**Files:** `.config/nvim/lua/plugins/lsp.lua`, `.config/nvim/lua/plugins/conform.lua`  
**Problem:** Complex formatting logic split between files  
**Solution:**

1. Remove formatting logic from lsp.lua (lines 215-256)
2. Configure conform.nvim to handle all formatting with LSP fallback
3. Simplify format-on-save configuration
   **Acceptance Criteria:**

- [ ] Single source of truth for formatting
- [ ] LSP formatting used as fallback only
- [ ] Simpler, more maintainable code

---

### TICKET-027: Fix Autocmd Group Naming

**Priority:** P3 - Low  
**Effort:** 5 minutes  
**Files:** `.config/nvim/lua/edo/autocmds.lua`  
**Problem:** Group named "auto-format" but handles yank highlighting  
**Solution:**

- Rename group from "auto-format" to "yank-highlight"
  **Acceptance Criteria:**
- [ ] Autocmd group name matches functionality
- [ ] No misleading names

---

### TICKET-028: Add Installation Script

**Priority:** P3 - Low  
**Effort:** 2 hours  
**Files:** New `install.sh` script  
**Problem:** No automated installation process  
**Solution:**
Create installation script that:

- Detects platform
- Checks dependencies
- Creates symlinks
- Backs up existing configs
- Provides rollback option
  **Acceptance Criteria:**
- [ ] Safe installation process
- [ ] Platform detection works
- [ ] Existing configs backed up
- [ ] Clear success/failure messages

---

## 📊 Summary

- **P0 (Critical):** 4 tickets - Fix breaking issues immediately
- **P1 (High):** 8 tickets - Performance optimizations
- **P2 (Medium):** 7 tickets - Security and compatibility
- **P3 (Low):** 9 tickets - Organization and polish

Total: 28 tickets

Each ticket is independent and can be assigned to different agents or contributors. Start with P0 tickets to fix critical issues, then move to P1 for performance improvements.
