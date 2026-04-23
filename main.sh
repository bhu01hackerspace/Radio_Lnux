#!/bin/bash

# radio.sh - Player de rádio com painel elegante
# Cores e estilos
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'
REVERSE='\033[7m'

# Verifica dependências
if ! command -v mpv &> /dev/null; then
    echo -e "${RED}Erro: mpv não está instalado!${NC}"
    exit 1
fi

# Declaração das estações (22 estações)
declare -A estacoes
estacoes["1"]="Antena 1|https://antenaone.crossradio.com.br/stream/1"
estacoes["2"]="89 FM Rádio Rock|https://www.radios.com.br/play/playlist/31289/listen-radio.m3u"
estacoes["3"]="Fita Cassete|https://server01.ouvir.radio.br:8018/stream"
estacoes["4"]="Blues Jazz|https://stream-152.zeno.fm/d6dg4e0dytzuv"
estacoes["5"]="Apenas Acústico|http://server02.ouvir.radio.br:8100/stream"
estacoes["6"]="Energia 97.7|https://streaming.inweb.com.br/energia"
estacoes["7"]="Hits 106.9|https://wz7.servidoresbrasil.com:9984/stream"
estacoes["8"]="Jovem Pan 89.5|https://top80.com.br:9000/stream"
estacoes["9"]="Hot 107|https://9772.brasilstream.com.br/stream"
estacoes["10"]="Kiss|https://www.radios.com.br/play/playlist/13561/listen-radio.m3u"
estacoes["11"]="Metropolitana|https://www.radios.com.br/play/playlist/13900/listen-radio.m3u"
estacoes["12"]="SomFlash|https://www.radios.com.br/play/playlist/258337/listen-radio.m3u"
estacoes["13"]="Mix 106.3|https://www.radios.com.br/play/playlist/13955/listen-radio.m3u"
estacoes["14"]="Alpha 101.7|https://www.radios.com.br/play/playlist/9015/listen-radio.m3u"
estacoes["15"]="Bandeirantes|https://www.radios.com.br/play/playlist/10410/listen-radio.m3u"
estacoes["16"]="VIP|https://www.radios.com.br/play/playlist/189281/listen-radio.m3u"
estacoes["17"]="Trance Place|https://www.radios.com.br/play/playlist/33449/listen-radio.m3u"
estacoes["18"]="Absolute Trance|https://www.radios.com.br/play/playlist/133374/listen-radio.m3u"
estacoes["19"]="Trance Athens|https://www.radios.com.br/play/playlist/180273/listen-radio.m3u"
estacoes["20"]="DFM Psy Trance|https://www.radios.com.br/play/playlist/237580/listen-radio.m3u"
estacoes["21"]="ON Gothic|https://www.radios.com.br/play/playlist/128089/listen-radio.m3u"
estacoes["22"]="Ghotic|https://www.radios.com.br/play/playlist/269241/listen-radio.m3u"

# Função para mostrar painel elegante
mostrar_painel() {
    local nome="$1"
    local status="$2"
    clear
    
    # Arte ASCII do rádio
    echo -e "${CYAN}┌────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${REVERSE}                    📻 RÁDIO PLAYER - MODO LIVE 📻                    ${NC}${CYAN}│${NC}"
    echo -e "${CYAN}├────────────────────────────────────────────────────────────────┤${NC}"
    
    # Informações da estação
    echo -e "${CYAN}│${WHITE} 🏢 Estação:   ${GREEN}$nome${NC}"
    echo -e "${CYAN}│${WHITE} 🔗 Status:    ${YELLOW}$status${NC}"
    echo -e "${CYAN}│${WHITE} 🎵 Tocando:   ${MAGENTA}Streaming ao vivo...${NC}"
    echo -e "${CYAN}│${WHITE} 🔊 Volume:    ${BLUE}[▓▓▓▓▓▓▓▓▓▓] 100%${NC}"
    echo -e "${CYAN}├────────────────────────────────────────────────────────────────┤${NC}"
    
    # Barra de visualização animada (simulada)
    echo -e "${CYAN}│${WHITE} 📊 Visualização de áudio:${NC}"
    echo -e "${CYAN}│   ${GREEN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${NC}"
    echo -e "${CYAN}├────────────────────────────────────────────────────────────────┤${NC}"
    
    # Comandos disponíveis
    echo -e "${CYAN}│${YELLOW} ⌨️  Comandos:${NC}"
    echo -e "${CYAN}│   ${WHITE}[CTRL+C]${NC} - Parar transmissão e voltar ao menu"
    echo -e "${CYAN}│   ${WHITE}[+/-]${NC}    - Ajustar volume (se suportado)"
    echo -e "${CYAN}└────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# Função para mostrar menu principal (estilizado)
mostrar_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${REVERSE}                    🎵 MENU DE RÁDIOS - 22 ESTAÇÕES 🎵                    ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
    
    # Exibir estações em colunas
    for i in {1..22}; do
        nome=$(echo "${estacoes[$i]}" | cut -d'|' -f1)
        if [ $i -le 11 ]; then
            printf "${CYAN}║${NC} ${YELLOW}%2d${NC}) ${GREEN}%-20s${NC}" "$i" "$nome"
            j=$((i+11))
            nome2=$(echo "${estacoes[$j]}" | cut -d'|' -f1)
            printf "  ${YELLOW}%2d${NC}) ${GREEN}%-20s${NC} ${CYAN}║${NC}\n" "$j" "$nome2"
        fi
    done
    
    echo -e "${CYAN}╠════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║                        ${RED}0) SAIR DO PLAYER${NC}                        ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Função para tocar com painel dinâmico
tocar_radio() {
    local escolha=$1
    local dados="${estacoes[$escolha]}"
    local nome=$(echo "$dados" | cut -d'|' -f1)
    local url=$(echo "$dados" | cut -d'|' -f2)
    
    # Mostra painel antes de iniciar
    mostrar_painel "$nome" "Conectando..."
    sleep 1
    
    # Inicia o mpv em segundo plano para capturar metadados
    mkfifo /tmp/mpv_pipe 2>/dev/null
    
    # Mostra painel com status "Tocando"
    mostrar_painel "$nome" "${GREEN}● AO VIVO${NC}"
    
    # Comando mpv com opções elegantes
    mpv --no-video \
         --cache=yes \
         --cache-secs=5 \
         --demuxer-max-bytes=10M \
         --stream-buffer-size=512K \
         --title="Rádio: $nome" \
         --terminal=no \
         --no-osc \
         --no-input-default-bindings \
         --input-conf=/dev/null \
         "$url" 2>/dev/null
    
    # Limpa o pipe
    rm -f /tmp/mpv_pipe
    
    echo ""
    echo -e "${GREEN}🔇 Transmissão encerrada: $nome${NC}"
    echo -e "${CYAN}Pressione ENTER para continuar...${NC}"
    read
}

# Loop principal
while true; do
    mostrar_menu
    read -p "$(echo -e ${YELLOW}Digite o número da estação [0-22]: ${NC})" opcao
    
    if [ "$opcao" == "0" ]; then
        echo -e "\n${GREEN}📻 Obrigado por usar o Rádio Player! Até logo! 🎵${NC}"
        exit 0
    fi
    
    if [[ "$opcao" =~ ^[0-9]+$ ]] && [ "$opcao" -ge 1 ] && [ "$opcao" -le 22 ]; then
        tocar_radio "$opcao"
    else
        echo -e "${RED}❌ Opção inválida! Digite um número entre 1 e 22 ou 0 para sair.${NC}"
        sleep 1
    fi
done
