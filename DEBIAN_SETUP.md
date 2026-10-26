# HƯỚNG DẪN CẤU HÌNH & KHÔI PHỤC MÔI TRƯỜNG DEBIAN (WSL2)
> **Tài liệu sao lưu toàn bộ Config, Tools, Dependencies và Git Repositories**  
> *Được tạo để khi cài lại Debian có thể khôi phục lại 100% môi trường làm việc mà không mất công cấu hình lại.*

---

## 1. Danh sách các Git Repositories (Đã Push lên GitHub)

Khi cài mới Debian, clone lại các repository sau:

| Thư mục | Remote URL | Mô tả |
| :--- | :--- | :--- |
| `~/dotfiles` | `https://github.com/minhtanz1/dotfiles.git` | Chứa toàn bộ dotfiles (`.bashrc`, `.bash_sysinit`, `.profile`, `.tmux.conf`, `.vimrc`, `starship.toml`, `zathurarc`) |
| `~/.config/nvim` | `https://github.com/minhtanz1/nvchad-config.git` | Toàn bộ cấu hình Neovim (NvChad, LSP, plugins, snippets, TeXpresso) |
| `~/thesis-template` | `https://github.com/minhtanz1/do-an-mau.git` | Template đồ án tốt nghiệp |
| `~/online-GIS-programming-course` | `https://github.com/Shadrock/online-GIS-programming-course.git` | Khóa học lập trình GIS |
| `~/Obsidian-Omd2Typst` | `https://github.com/minhtanz1/Obsidian-Omd2Typst.git` | Công cụ chuyển Markdown sang Typst |

```bash
# Clone Dotfiles
git clone https://github.com/minhtanz1/dotfiles.git ~/dotfiles

# Clone Neovim Config
git clone https://github.com/minhtanz1/nvchad-config.git ~/.config/nvim

# Clone Project Repositories
git clone https://github.com/minhtanz1/do-an-mau.git ~/thesis-template
git clone https://github.com/Shadrock/online-GIS-programming-course.git ~/online-GIS-programming-course
git clone https://github.com/minhtanz1/Obsidian-Omd2Typst.git ~/Obsidian-Omd2Typst
```

---

## 2. Cài đặt các gói hệ thống qua APT (1 Lệnh duy nhất)

Chạy lệnh cập nhật và cài đặt tất cả các gói manually installed trên Debian:

```bash
sudo apt update && sudo apt install -y \
  build-essential git curl wget tmux fzf ripgrep fd-find xclip unzip lsof fuse \
  neovim hx nano starship \
  python3 python3-pip python3-setuptools python3-tk python3-venv ipython3 \
  nodejs npm \
  r-base r-base-dev \
  postgresql sqlitebrowser libsqlite3-0 \
  pandoc plantuml graphviz zathura mupdf poppler-utils img2pdf \
  tesseract-ocr tesseract-ocr-eng tesseract-ocr-vie \
  osmctools k6 \
  dbus dbus-bin dbus-daemon dbus-session-bus-common dbus-system-bus-common \
  libmupdf-dev libmujs-dev libjbig2dec0-dev libopenjp2-7-dev \
  libmagickcore-dev libmagick++-dev libmagickwand-dev \
  libsdl2-dev libfontconfig-dev libfreetype-dev libharfbuzz-dev \
  libcurl4-openssl-dev libssl-dev libgumbo-dev
```

### Tạo symlink cần thiết:
```bash
# Tạo symlink fd cho fdfind (chuẩn của Debian)
mkdir -p ~/.local/bin
ln -sf /usr/bin/fdfind ~/.local/bin/fd
```

---

## 3. Cài đặt các Tools & Runtimes độc lập (Ngoài APT)

### 3.1. Rust & Cargo
```bash
# Cài đặt Rustup
curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Cài đặt các Cargo tools
cargo install cargo-deb tinymist-cli tree-sitter-cli typst-cli
```

### 3.2. Bun (JavaScript Runtime)
```bash
curl -fsSL https://bun.sh/install | bash
mkdir -p ~/.local/bin
ln -sf ~/.bun/bin/bun ~/.local/bin/bunx
```

### 3.3. Python UV & Libraries
```bash
# Cài đặt UV Package Manager
curl -LsSf https://astral.sh/uv/install.sh | sh

# Cài đặt các package Python thường dùng:
uv pip install --user \
  numpy pandas scipy matplotlib seaborn statsmodels numba \
  pillow ImageHash pydantic PyYAML requests tqdm \
  django sqlparse ydata-profiling puremagic pyautoreloadserver
```

### 3.4. TeX Live (Bản đầy đủ từ TUG)
TeX Live trong máy hiện tại được cài đặt độc lập tại `/usr/local/texlive/2026`:
```bash
# Tải và chạy installer của TeX Live:
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar -xzf install-tl-unx.tar.gz
cd install-tl-*
sudo ./install-tl --no-interaction
```
*Đường dẫn PATH đã được cấu hình sẵn trong `.bashrc`:*
`export PATH=/usr/local/texlive/2026/bin/x86_64-linux:$PATH`

### 3.5. Neovim v0.12+ (AppImage / Prebuilt)
Debian APT có thể có phiên bản Neovim cũ, nên dùng binary mới nhất đặt tại `~/.local/bin/nvim`:
```bash
mkdir -p ~/.local/bin
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
mv squashfs-root/usr/bin/nvim ~/.local/bin/nvim
rm -rf squashfs-root nvim-linux-x86_64.appimage
```

### 3.6. TeXpresso (Live LaTeX Previewer cho Neovim)
Được cấu hình tương thích với `~/.config/nvim/lua/texpresso.lua`:
```bash
git clone https://github.com/let-def/texpresso.git ~/.config/nvim/texpresso
cd ~/.config/nvim/texpresso
make
```

### 3.7. Flyline (Enhanced Bash Experience)
Thư viện `libflyline.so` đặt tại `~/.local/lib/`:
```bash
mkdir -p ~/.local/lib
# Sau khi copy/build libflyline.so vào ~/.local/lib/:
ln -sf ~/.local/lib/libflyline.so.1.2.2 ~/.local/lib/libflyline.so
```

### 3.8. Tmux Plugin Manager (TPM)
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Mở tmux và ấn: Prefix (Ctrl+b) + I để tự động tải các plugin
```

### 3.9. R Packages
Cài đặt các gói R cơ bản và nvimcom phục vụ R.nvim:
```bash
R -e "install.packages(c(  'tidyverse', 'rmarkdown', 'shiny', 'ggplot2', 'plotly',   'data.table', 'tinytex', 'patchwork', 'summarytools', 'httpuv'), repos='https://cloud.r-project.org')"
```

### 3.10. Fonts
Copy các font chữ (Myriad Pro OTF) vào `~/.fonts/`:
```bash
mkdir -p ~/.fonts
# Sau khi copy font vào ~/.fonts/
fc-cache -fv ~/.fonts
```

---

## 4. Chi tiết các File Cấu hình (Dotfiles & Configs)

Tất cả các file này đã được commit vào `~/dotfiles`. Nếu cần triển khai nhanh bằng tay:

### 4.1. `~/.bashrc`
```bash
# ~/.bashrc: executed by bash(1) for non-login shells.
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

. "$HOME/.cargo/env"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export TMPDIR=/tmp
eval "$(starship init bash)"
export PATH=/usr/local/texlive/2026/bin/x86_64-linux:$PATH

# Flyline - enhanced Bash experience (nếu có libflyline.so)
[ -f /home/minhtan/.local/lib/libflyline.so ] && enable -f /home/minhtan/.local/lib/libflyline.so flyline

export PATH="$HOME/.local/bin:$PATH"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 4.2. `~/.bash_sysinit` (Thiết lập D-Bus / GUI cho WSL2)
```bash
# X410 WSL2 Helper
# Setting up D-Bus for Ubuntu/Debian

sudo_autopasswd()
{
    echo "1" | sudo -Svp ""
}

sudo_resetpasswd()
{
    sudo -k
}

export XDG_RUNTIME_DIR=/run/user/$(id -u)
if [ ! -d "$XDG_RUNTIME_DIR" ]; then
{
    sudo_autopasswd
    sudo mkdir -p $XDG_RUNTIME_DIR && sudo chmod 700 $XDG_RUNTIME_DIR && sudo chown $(id -un):$(id -gn) $XDG_RUNTIME_DIR
    sudo service dbus start
    sudo_resetpasswd
}
fi

set_session_dbus()
{
    local bus_file_path="$XDG_RUNTIME_DIR/bus"
    export DBUS_SESSION_BUS_ADDRESS=unix:path=$bus_file_path
    if [ ! -e "$bus_file_path" ]; then
    {
        /usr/bin/dbus-daemon --session --address=$DBUS_SESSION_BUS_ADDRESS --nofork --nopidfile --syslog-only &
    }
    fi
}

set_session_dbus
```

### 4.3. `~/.profile`
```bash
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

if [ -f ~/.bash_sysinit ]; then
    . ~/.bash_sysinit
fi
```

### 4.4. `~/.vimrc`
```vim
set encoding=utf8 
vim.g.vimtex_view_method='zathura'
```

### 4.5. `~/.config/zathura/zathurarc`
```conf
set synctex true
set synctex-editor-command "nvim +%{line} %{input}"
set selection-clipboard clipboard
```

### 4.6. `~/.tmux.conf`
```tmux
# ── TPM Plugins ─────────────────────────
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'Morantron/tmux-fingers'
set -g @plugin 'tmux-plugins/tmux-open'
set -g @plugin 'sainnhe/tmux-fzf'
set -g @plugin 'egel/tmux-gruvbox'

# ── Theme ───────────────────────────────
set -g @tmux-gruvbox 'dark'
set -g prefix C-b
set-window-option -g mode-keys vi

# ── General Settings ────────────────────
set -g history-limit 5000
set -g base-index 1
set -g pane-base-index 1
setw -g automatic-rename on
setw -g automatic-rename-format '#{b:pane_current_path}'

# ── Status Bar ──────────────────────────
set -g status-position bottom
set -g status-interval 5
set -g status-left " #S "
set -g status-right " %H:%M %d-%b "

# ── Pane Borders ────────────────────────
set -g pane-border-style "fg=#3b4261"
set -g pane-active-border-style "fg=#7aa2f7"

# ── Continuum & Resurrect ───────────────
set -g @continuum-restore 'on'
set -g @continuum-save-interval '10'
set -g default-terminal "xterm-256color"

# ── Initialize TPM ──────────────────────
run '~/.tmux/plugins/tpm/tpm'
```

### 4.7. `~/.gitconfig`
```gitconfig
[user]
    email = masterminhtan@gmail.com
    name = minhtanz1
```

---

## 5. Script khôi phục môi trường tự động (`restore_debian.sh`)

Để tiết kiệm thời gian nhất khi cài lại Debian, bạn chỉ cần lưu script sau và chạy `bash restore_debian.sh`:

```bash
#!/usr/bin/env bash
set -e

echo "==> 1. Cập nhật APT và cài đặt gói cần thiết..."
sudo apt update && sudo apt install -y \
  build-essential git curl wget tmux fzf ripgrep fd-find xclip unzip lsof fuse \
  neovim hx nano starship \
  python3 python3-pip python3-setuptools python3-tk python3-venv ipython3 \
  nodejs npm \
  r-base r-base-dev \
  postgresql sqlitebrowser libsqlite3-0 \
  pandoc plantuml graphviz zathura mupdf poppler-utils img2pdf \
  tesseract-ocr tesseract-ocr-eng tesseract-ocr-vie \
  osmctools k6 \
  dbus dbus-bin dbus-daemon dbus-session-bus-common dbus-system-bus-common \
  libmupdf-dev libmujs-dev libjbig2dec0-dev libopenjp2-7-dev \
  libmagickcore-dev libmagick++-dev libmagickwand-dev \
  libsdl2-dev libfontconfig-dev libfreetype-dev libharfbuzz-dev \
  libcurl4-openssl-dev libssl-dev libgumbo-dev

echo "==> 2. Cài đặt Rust & Cargo tools..."
if ! command -v rustup >/dev/null 2>&1; then
  curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi
cargo install cargo-deb tinymist-cli tree-sitter-cli typst-cli

echo "==> 3. Cài đặt Bun & UV..."
if ! command -v bun >/dev/null 2>&1; then
  curl -fsSL https://bun.sh/install | bash
fi
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

echo "==> 4. Cài đặt TPM (Tmux Plugin Manager)..."
mkdir -p ~/.tmux/plugins
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "==> 5. Khôi phục Dotfiles từ GitHub..."
if [ ! -d ~/dotfiles ]; then
  git clone https://github.com/minhtanz1/dotfiles.git ~/dotfiles
fi

# Liên kết dotfiles vào HOME
cp ~/dotfiles/.bashrc ~/.bashrc
cp ~/dotfiles/.bash_sysinit ~/.bash_sysinit
cp ~/dotfiles/.profile ~/.profile
cp ~/dotfiles/.tmux.conf ~/.tmux.conf
cp ~/dotfiles/.vimrc ~/.vimrc
cp ~/dotfiles/.gitconfig ~/.gitconfig
mkdir -p ~/.config/zathura
cp ~/dotfiles/.config/zathura/zathurarc ~/.config/zathura/zathurarc
cp ~/dotfiles/.config/starship.toml ~/.config/starship.toml

echo "==> 6. Khôi phục NvChad Config..."
mkdir -p ~/.config
if [ ! -d ~/.config/nvim ]; then
  git clone https://github.com/minhtanz1/nvchad-config.git ~/.config/nvim
fi

echo "==> Hoàn tất cài đặt! Hãy khởi động lại terminal hoặc chạy: source ~/.bashrc"
```
