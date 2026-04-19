#!/bin/bash
# =====================================================
# Laravel Tools - One-Script Installer
# Author: Donny Iskandarsyah
# Credits: ChatGPT (GPT-5) & Claude (Sonnet 4.6)
# =====================================================
# Usage:
#   curl -sSL https://raw.githubusercontent.com/donnebanget/laravel-tools/main/install.sh | bash
# =====================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

REPO_RAW="https://raw.githubusercontent.com/donnebanget/laravel-tools/main"
INSTALL_DIR="/usr/local/bin"
TOOLS=("deploy" "worker")

echo -e "\n${CYAN}🚀 Laravel Tools Installer${NC}"
echo -e "${CYAN}================================${NC}\n"

# Check root or sudo
if [ "$(id -u)" -ne 0 ]; then
  if ! sudo -n true 2>/dev/null; then
    echo -e "${YELLOW}⚠️  This installer needs sudo to write to ${INSTALL_DIR}.${NC}"
    echo -e "${YELLOW}You may be prompted for your password.${NC}\n"
  fi
  SUDO="sudo"
else
  SUDO=""
fi

# Check dependencies
for dep in curl chmod; do
  command -v "$dep" >/dev/null 2>&1 || { echo -e "${RED}Error: '${dep}' is required but not installed.${NC}"; exit 1; }
done

# Install each tool
for tool in "${TOOLS[@]}"; do
  echo -e "${YELLOW}📥 Installing '${tool}'...${NC}"

  TMP_FILE=$(mktemp)

  if curl -sSLf "${REPO_RAW}/bin/${tool}" -o "$TMP_FILE"; then
    # Validate it's a bash script (basic check)
    if ! head -1 "$TMP_FILE" | grep -q "^#!"; then
      echo -e "${RED}❌ Downloaded file for '${tool}' looks invalid. Aborting.${NC}"
      rm -f "$TMP_FILE"
      exit 1
    fi

    $SUDO mv "$TMP_FILE" "${INSTALL_DIR}/${tool}"
    $SUDO chmod +x "${INSTALL_DIR}/${tool}"
    echo -e "${GREEN}✅ '${tool}' installed to ${INSTALL_DIR}/${tool}${NC}"
  else
    echo -e "${RED}❌ Failed to download '${tool}' from ${REPO_RAW}/bin/${tool}${NC}"
    rm -f "$TMP_FILE"
    exit 1
  fi
done

echo -e "\n${GREEN}🎉 All tools installed successfully!${NC}\n"

echo -e "${CYAN}Available commands:${NC}"
echo -e "  ${YELLOW}deploy${NC}              — Quick Laravel optimization (no Git/NPM rebuild)"
echo -e "  ${YELLOW}deploy --init${NC}       — First-time deployment with full initialization"
echo -e "  ${YELLOW}deploy --update${NC}     — Pull from Git and rebuild everything"
echo -e "  ${YELLOW}deploy --help${NC}       — Show deploy help"
echo ""
echo -e "  ${YELLOW}worker create [user] [domain?] [queue?]${NC}  — Create a supervisor worker"
echo -e "  ${YELLOW}worker remove [user] [--force]${NC}            — Remove a worker"
echo -e "  ${YELLOW}worker list${NC}                               — List all workers"
echo -e "  ${YELLOW}worker restart [user]${NC}                     — Restart a worker"
echo -e "  ${YELLOW}worker status [user?]${NC}                     — Show worker status"
echo -e "  ${YELLOW}worker logs [user] [out|err]${NC}              — Tail worker logs"
echo ""
echo -e "${CYAN}Run '${YELLOW}deploy --help${CYAN}' or '${YELLOW}worker --help${CYAN}' for full documentation.${NC}\n"
