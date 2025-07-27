#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
RESET='\033[0m'

LANGUAGE=""
DNS_PROVIDER=""

menu() {
    echo -e "${BOLD_MAGENTA}$1${RESET}"
}

question() {
    echo -e "${BOLD_CYAN}$1${RESET}"
}

info() {
    echo -e "${BOLD_CYAN}[INFO]${RESET} $1"
}

warn() {
    echo -e "${BOLD_YELLOW}[WARN]${RESET} $1"
}

error() {
    echo -e "${BOLD_RED}[ERROR]${RESET} $1"
}

success() {
    echo -e "${BOLD_GREEN}[SUCCESS]${RESET} $1"
}

get_string() {
    local key="$1"
    if [ "$LANGUAGE" = "en" ]; then
        case $key in
            "language_selection") echo "Language Selection" ;;
            "select_language") echo "Select language / Выберите язык:" ;;
            "english") echo "English" ;;
            "russian") echo "Русский" ;;
            "domain_prompt") echo "Enter your domain (e.g., example.com):" ;;
            "token_prompt_gcore") echo "Enter your Gcore API token:" ;;
            "token_prompt_cf") echo "Enter your Cloudflare API token:" ;;
            "email_prompt_cf") echo "Enter your Cloudflare email:" ;;
            "checking_docker") echo "Checking Docker installation..." ;;
            "docker_not_found") echo "Docker not found. Installing..." ;;
            "docker_installing") echo "Installing Docker..." ;;
            "docker_installed") echo "Docker installed successfully!" ;;
            "creating_directories") echo "Creating directories..." ;;
            "downloading_files") echo "Downloading files..." ;;
            "creating_docker_files") echo "Creating Docker files..." ;;
            "starting_container") echo "Starting Caddy container..." ;;
            "installation_complete") echo "Installation completed successfully!" ;;
            "press_any_key") echo "Press any key to continue..." ;;
            "invalid_choice") echo "Invalid choice. Please try again." ;;
            "exiting") echo "Exiting..." ;;
            "error_occurred") echo "An error occurred during installation." ;;
            "domain_required") echo "Domain is required!" ;;
            "token_required") echo "API token is required!" ;;
            "email_required") echo "Cloudflare email is required!" ;;
            "caddy_available_at") echo "Your site is now available at: https://" ;;
            "dns_provider_selection") echo "DNS Provider Selection" ;;
            "select_dns_provider") echo "Select DNS provider:" ;;
            "gcore") echo "Gcore DNS" ;;
            "cloudflare") echo "Cloudflare DNS" ;;
        esac
    else
        case $key in
            "language_selection") echo "Выбор языка" ;;
            "select_language") echo "Select language / Выберите язык:" ;;
            "english") echo "English" ;;
            "russian") echo "Русский" ;;
            "domain_prompt") echo "Введите ваш домен (например, example.com):" ;;
            "token_prompt_gcore") echo "Введите ваш Gcore API токен:" ;;
            "token_prompt_cf") echo "Введите ваш Cloudflare API токен:" ;;
            "email_prompt_cf") echo "Введите ваш Cloudflare email:" ;;
            "checking_docker") echo "Проверка установки Docker..." ;;
            "docker_not_found") echo "Docker не найден. Устанавливаем..." ;;
            "docker_installing") echo "Установка Docker..." ;;
            "docker_installed") echo "Docker успешно установлен!" ;;
            "creating_directories") echo "Создание директорий..." ;;
            "downloading_files") echo "Загрузка файлов..." ;;
            "creating_docker_files") echo "Создание Docker файлов..." ;;
            "starting_container") echo "Запуск контейнера Caddy..." ;;
            "installation_complete") echo "Установка успешно завершена!" ;;
            "press_any_key") echo "Нажмите любую клавишу для продолжения..." ;;
            "invalid_choice") echo "Неверный выбор. Попробуйте снова." ;;
            "exiting") echo "Выход..." ;;
            "error_occurred") echo "Произошла ошибка во время установки." ;;
            "domain_required") echo "Домен обязателен!" ;;
            "token_required") echo "API токен обязателен!" ;;
            "email_required") echo "Cloudflare email обязателен!" ;;
            "caddy_available_at") echo "Ваш сайт теперь доступен по адресу: https://" ;;
            "dns_provider_selection") echo "Выбор DNS-провайдера" ;;
            "select_dns_provider") echo "Выберите DNS-провайдера:" ;;
            "gcore") echo "Gcore DNS" ;;
            "cloudflare") echo "Cloudflare DNS" ;;
        esac
    fi
}

select_language() {
    clear
    print_header
    menu "$(get_string "language_selection")"
    echo -e "${BLUE}1. $(get_string "english")${RESET}"
    echo -e "${BLUE}2. $(get_string "russian")${RESET}"
    echo
    while true; do
        read -p "$(echo -e "${BOLD_CYAN}$(get_string "select_language")${RESET}") " lang_choice
        case $lang_choice in
            1) LANGUAGE="en"; break ;;
            2) LANGUAGE="ru"; break ;;
            *) warn "$(get_string "invalid_choice")" ;;
        esac
    done
}

select_dns_provider() {
    clear
    print_header
    menu "$(get_string "dns_provider_selection")"
    echo -e "${BLUE}1. $(get_string "gcore")${RESET}"
    echo -e "${BLUE}2. $(get_string "cloudflare")${RESET}"
    echo
    while true; do
        read -p "$(echo -e "${BOLD_CYAN}$(get_string "select_dns_provider")${RESET}") " dns_choice
        case $dns_choice in
            1) DNS_PROVIDER="gcore"; break ;;
            2) DNS_PROVIDER="cloudflare"; break ;;
            *) warn "$(get_string "invalid_choice")" ;;
        esac
    done
}

print_header() {
    clear
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo -e "\033[1;32m"
    echo -e "┌───────────────────────────────────────────────────────────────────┐"
    echo -e "│  ██████╗ █████╗ ██████╗ ██╗   ██╗██████╗  █████╗ ██████╗  █████╗  │"
    echo -e "│ ██╔════╝██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔══██╗██╔══██╗ │"
    echo -e "│ ██║     ███████║██████╔╝ ╚████╔╝ ██████╔╝███████║██████╔╝███████║ │"
    echo -e "│ ██║     ██╔══██║██╔═══╝   ╚██╔╝  ██╔══██╗██╔══██║██╔══██╗██╔══██║ │"
    echo -e "│ ╚██████╗██║  ██║██║        ██║   ██████╔╝██║  ██║██║  ██║██║  ██║ │"
    echo -e "│  ╚═════╝╚═╝  ╚═╝╚═╝        ╚═╝   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ │"
    echo -e "└───────────────────────────────────────────────────────────────────┘"
    echo -e "\033[0m"
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    if [ "$LANGUAGE" = "en" ]; then
        echo -e "${GREEN}Caddy DNS Setup (Gcore/Cloudflare)${RESET}"
        echo -e "${CYAN}Version: 1.2${RESET}"
        echo -e "${YELLOW}Author: @KaTTuBaRa${RESET}"
    else
        echo -e "${GREEN}Установка Caddy с DNS (Gcore/Cloudflare)${RESET}"
        echo -e "${CYAN}Версия: 1.2${RESET}"
        echo -e "${YELLOW}Автор: @KaTTuBaRa${RESET}"
    fi
    echo -e "${MAGENTA}────────────────────────────────────────────────────────────${RESET}"
    echo
}

check_and_install_docker() {
    info "$(get_string "checking_docker")"
    
    if ! command -v docker &> /dev/null; then
        warn "$(get_string "docker_not_found")"
        info "$(get_string "docker_installing")"

        curl -fsSL https://get.docker.com | sh
        
        success "$(get_string "docker_installed")"
    else
        if [ "$LANGUAGE" = "en" ]; then
            success "Docker already installed"
        else
            success "Docker уже установлен"
        fi
    fi
}

create_directories_and_files() {
    info "$(get_string "creating_directories")"

    sudo mkdir -p /var/www/site/assets
    sudo chmod -R 777 /var/www/site

    sudo mkdir -p /opt/caddy
    sudo chown -R $USER:$USER /opt/caddy
    sudo chmod -R 777 /opt/caddy
    
    if [ "$LANGUAGE" = "en" ]; then
        success "Directories created successfully"
    else
        success "Директории успешно созданы"
    fi
}

download_site_files() {
    info "$(get_string "downloading_files")"

    sudo curl -o /var/www/site/index.html "https://raw.githubusercontent.com/Capybara-z/CaddyDNS/refs/heads/main/example/index.html"
    sudo curl -o /var/www/site/assets/main.js "https://raw.githubusercontent.com/Capybara-z/CaddyDNS/refs/heads/main/example/assets/main.js"
    sudo curl -o /var/www/site/assets/style.css "https://raw.githubusercontent.com/Capybara-z/CaddyDNS/refs/heads/main/example/assets/style.css"
      
    if [ "$LANGUAGE" = "en" ]; then
        success "Site files downloaded successfully"
    else
        success "Файлы сайта успешно загружены"
    fi
}

create_docker_files() {
    info "$(get_string "creating_docker_files")"

    local caddy_module_build=""
    local caddyfile_acme_dns_line=""
    local caddyfile_tls_dns_line=""
    local docker_compose_env_vars=""

    if [ "$DNS_PROVIDER" = "gcore" ]; then
        caddy_module_build="github.com/caddy-dns/gcore"
        caddyfile_acme_dns_line="acme_dns gcore {env.GCORE_API_TOKEN}"
        caddyfile_tls_dns_line="dns gcore {env.GCORE_API_TOKEN}"
        docker_compose_env_vars="      GCORE_API_TOKEN: \"\$GCORE_TOKEN\""
    elif [ "$DNS_PROVIDER" = "cloudflare" ]; then
        caddy_module_build="github.com/caddy-dns/cloudflare"
        caddyfile_acme_dns_line="acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN} {env.CLOUDFLARE_EMAIL}"
        caddyfile_tls_dns_line="dns cloudflare {env.CLOUDFLARE_API_TOKEN} {env.CLOUDFLARE_EMAIL}"
        docker_compose_env_vars="      CLOUDFLARE_API_TOKEN: \"\$CLOUDFLARE_TOKEN\"\n      CLOUDFLARE_EMAIL: \"\$CLOUDFLARE_EMAIL\""
    fi

    sudo cat > /opt/caddy/Dockerfile << EOF
FROM golang:1.24-alpine AS builder

RUN apk add --no-cache git

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

WORKDIR /app
RUN xcaddy build \\
    --with $caddy_module_build \\
    --output /app/caddy-custom

FROM caddy:latest

COPY --from=builder /app/caddy-custom /usr/bin/caddy
EOF

    sudo cat > /opt/caddy/docker-compose.yml << EOF
services:
  caddy:
    build:
      context: .
    container_name: caddy-gcore
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - /var/www/site:/var/www/site:ro
    environment:
$docker_compose_env_vars

volumes:
  caddy_data:
EOF

    sudo cat > /opt/caddy/Caddyfile << EOF
{
    $caddyfile_acme_dns_line
}

https://$DOMAIN {
    tls {
        $caddyfile_tls_dns_line
    }
    root * /var/www/site
    file_server
    header {
        X-Real-IP {remote_host}
    }
}
EOF

    if [ "$LANGUAGE" = "en" ]; then
        success "Docker files created successfully"
    else
        success "Docker файлы успешно созданы"
    fi
}

start_container() {
    info "$(get_string "starting_container")"
    
    cd /opt/caddy

    sudo docker compose up -d --build
    
    if [ $? -eq 0 ]; then
        success "$(get_string "installation_complete")"
        if [ "$LANGUAGE" = "en" ]; then
            echo -e "${GREEN}$(get_string "caddy_available_at")$DOMAIN${RESET}"
        else
            echo -e "${GREEN}$(get_string "caddy_available_at")$DOMAIN${RESET}"
        fi
    else
        error "$(get_string "error_occurred")"
        exit 1
    fi
}

get_user_input() {
    print_header

    while true; do
        read -p "$(echo -e "${BOLD_CYAN}$(get_string "domain_prompt")${RESET}") " DOMAIN
        if [ -n "$DOMAIN" ]; then
            break
        else
            error "$(get_string "domain_required")"
        fi
    done

    if [ "$DNS_PROVIDER" = "gcore" ]; then
        while true; do
            read -p "$(echo -e "${BOLD_CYAN}$(get_string "token_prompt_gcore")${RESET}") " GCORE_TOKEN
            if [ -n "$GCORE_TOKEN" ]; then
                break
            else
                error "$(get_string "token_required")"
            fi
        done
    elif [ "$DNS_PROVIDER" = "cloudflare" ]; then
        while true; do
            read -p "$(echo -e "${BOLD_CYAN}$(get_string "token_prompt_cf")${RESET}") " CLOUDFLARE_TOKEN
            if [ -n "$CLOUDFLARE_TOKEN" ]; then
                break
            else
                error "$(get_string "token_required")"
            fi
        done
        while true; do
            read -p "$(echo -e "${BOLD_CYAN}$(get_string "email_prompt_cf")${RESET}") " CLOUDFLARE_EMAIL
            if [ -n "$CLOUDFLARE_EMAIL" ]; then
                break
            else
                error "$(get_string "email_required")"
            fi
        done
    fi
}

main() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${BOLD_RED}[ERROR]${RESET} This script must be run as root (use sudo)"
        echo -e "${BOLD_RED}[ERROR]${RESET} Этот скрипт должен быть запущен от root (используйте sudo)"
        exit 1
    fi

    select_language
    select_dns_provider

    get_user_input

    check_and_install_docker
    create_directories_and_files
    download_site_files
    create_docker_files
    start_container
    
    echo
    read -n 1 -s -r -p "$(get_string "press_any_key")"
}

main
