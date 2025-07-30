-- File Synchronization Solutions for Remote LSP
-- This file provides different approaches to keep files in sync between local and remote machines

-- ============================================================================
-- APPROACH 1: SSHFS (Mount Remote as Local Filesystem)
-- ============================================================================

--[[
SSHFS - Mount remote directory as local filesystem

SETUP:
1. Install sshfs:
   - macOS: brew install macfuse sshfs
   - Linux: sudo apt install sshfs

2. Mount remote directory:
   mkdir -p ~/remote-projects
   sshfs user@remote:/path/to/projects ~/remote-projects -o auto_cache,reconnect,defer_permissions,noappledouble,volname=RemoteProjects

3. Work on files in ~/remote-projects as if they were local
4. LSP runs on remote but sees the same paths

PROS:
- Transparent to Neovim
- No config changes needed
- Works with all tools

CONS:
- Can be slow on high latency connections
- Requires FUSE support
--]]

-- ============================================================================
-- APPROACH 2: Rsync + File Watchers
-- ============================================================================

--[[
Rsync with automatic sync on save

Add this to your Neovim config:
--]]

local function setup_rsync_sync()
  local rsync_group = vim.api.nvim_create_augroup("RsyncSync", { clear = true })

  -- Configuration
  local REMOTE_HOST = "user@remote-server"
  local REMOTE_PATH = "/home/user/projects/"
  local LOCAL_PATH = vim.fn.expand "~/projects/"

  -- Sync on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = rsync_group,
    pattern = LOCAL_PATH .. "*",
    callback = function(ev)
      local relative_path = vim.fn.fnamemodify(ev.file, ":.")
      local remote_file = REMOTE_PATH .. relative_path

      -- Sync single file (fast)
      vim.fn.jobstart({
        "rsync",
        "-avz",
        "--relative",
        ev.file,
        REMOTE_HOST .. ":" .. vim.fn.fnamemodify(remote_file, ":h"),
      }, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("Synced to remote", vim.log.levels.INFO)
          else
            vim.notify("Sync failed", vim.log.levels.ERROR)
          end
        end,
      })
    end,
  })

  -- Pull changes from remote
  vim.api.nvim_create_user_command("SyncFromRemote", function()
    vim.fn.jobstart({
      "rsync",
      "-avz",
      REMOTE_HOST .. ":" .. REMOTE_PATH,
      LOCAL_PATH,
    }, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("Synced from remote", vim.log.levels.INFO)
        else
          vim.notify("Sync failed", vim.log.levels.ERROR)
        end
      end,
    })
  end, {})
end

-- ============================================================================
-- APPROACH 3: Mutagen (Advanced Bidirectional Sync)
-- ============================================================================

--[[
Mutagen - High-performance file synchronization

SETUP:
1. Install mutagen: brew install mutagen-io/mutagen/mutagen

2. Create sync session:
   mutagen sync create \
     ~/projects/myproject \
     user@remote:/home/user/projects/myproject \
     --name=myproject \
     --sync-mode=two-way-resolved \
     --default-file-mode=0644 \
     --default-directory-mode=0755 \
     --ignore=node_modules \
     --ignore=.git

3. Start daemon: mutagen daemon start
4. Monitor: mutagen sync monitor

PROS:
- Bidirectional sync
- Very fast
- Handles conflicts well
- Works in background

CONS:
- Requires setup
- Another tool to manage
--]]

-- ============================================================================
-- APPROACH 4: Unison (Bidirectional Sync)
-- ============================================================================

--[[
Unison - Reliable bidirectional sync

Create ~/.unison/myproject.prf:
root = /Users/myuser/projects/myproject
root = ssh://user@remote//home/user/projects/myproject

ignore = Name node_modules
ignore = Name .git
ignore = Name *.pyc
ignore = Name __pycache__

batch = true
auto = true
repeat = watch
--]]

-- ============================================================================
-- APPROACH 5: Git Worktree with Auto-commit
-- ============================================================================

local function setup_git_auto_sync()
  local git_group = vim.api.nvim_create_augroup("GitAutoSync", { clear = true })

  -- Auto-commit and push on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = git_group,
    callback = function()
      -- Check if in git repo
      if vim.fn.system("git rev-parse --git-dir 2>/dev/null"):match "^%.git" then
        vim.fn.jobstart({
          "sh",
          "-c",
          "git add -A && git commit -m 'Auto-sync' --no-verify && git push origin HEAD --no-verify",
        }, {
          on_exit = function(_, code)
            if code == 0 then
              vim.notify("Pushed to remote", vim.log.levels.INFO)
            end
          end,
        })
      end
    end,
  })
end

-- ============================================================================
-- APPROACH 6: Remote Development Containers
-- ============================================================================

--[[
Docker/Podman with volume mounts

1. Create Dockerfile with development environment
2. Run container with volume mount:
   docker run -it \
     -v ~/projects:/workspace \
     -p 9999:9999 \
     mydev:latest

3. Configure LSP to connect to container:
   cmd = { "docker", "exec", "-i", "dev-container", "typescript-language-server", "--stdio" }
--]]

-- ============================================================================
-- APPROACH 7: Neovim Remote Plugins
-- ============================================================================

--[[
Use distant.nvim for full remote development

Install:
Plug 'chipsenkbeil/distant.nvim'

Setup:
require('distant').setup {
  servers = {
    ['myserver'] = {
      host = 'user@remote-server',
      -- Additional options
    }
  }
}

This handles both file editing and LSP remotely
--]]

-- ============================================================================
-- RECOMMENDED APPROACH BASED ON USE CASE
-- ============================================================================

--[[
1. OCCASIONAL REMOTE WORK:
   - Use SSHFS for simplicity
   - Mount when needed, unmount when done

2. FREQUENT REMOTE WORK:
   - Mutagen for automatic bidirectional sync
   - Works great with LSP on remote

3. TEAM COLLABORATION:
   - Git with feature branches
   - Each developer works on their branch

4. LARGE PROJECTS:
   - Work directly on remote via SSH + tmux
   - Use Neovim on the remote machine

5. RESTRICTED ENVIRONMENTS:
   - Rsync with file watchers
   - Simple and works everywhere
--]]

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Check if file is in sync
local function check_file_sync(local_file, remote_file, remote_host)
  local local_sum = vim.fn.system("md5sum " .. local_file .. " | cut -d' ' -f1")
  local remote_sum = vim.fn.system("ssh " .. remote_host .. " md5sum " .. remote_file .. " | cut -d' ' -f1")
  return vim.trim(local_sum) == vim.trim(remote_sum)
end

-- Create sync status indicator for statusline
local function sync_status()
  -- This would check sync status and return indicator
  return "⟳" -- or "✓" when synced
end

return {
  setup_rsync_sync = setup_rsync_sync,
  setup_git_auto_sync = setup_git_auto_sync,
  check_file_sync = check_file_sync,
  sync_status = sync_status,
}

