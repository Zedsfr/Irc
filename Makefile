# ================================
# Makefile Inception 42 - Adapté au docker-compose actuel
# ================================

# Variables
DATA_DIR := /home/mdiomand/data
MARIADB_DIR := $(DATA_DIR)/maria_data
WP_DIR := $(DATA_DIR)/wordpress_data
COMPOSE_DIR := srcs

# ================================
# Commandes principales
# ================================

all: up

up:
	@echo "📦 Création des dossiers nécessaires..."
	@mkdir -p $(MARIADB_DIR) $(WP_DIR)
	@sudo chown -R $(USER):$(USER) $(DATA_DIR)
	@chmod -R 755 $(DATA_DIR)
	@echo "🚀 Lancement des conteneurs..."
	@cd $(COMPOSE_DIR) && docker compose up -d --build

down:
	@echo "🛑 Arrêt des conteneurs..."
	@cd $(COMPOSE_DIR) && docker compose down

build:
	@cd $(COMPOSE_DIR) && docker compose build

nbuild:
	@cd $(COMPOSE_DIR) && docker compose build --no-cache

logs:
	@cd $(COMPOSE_DIR) && docker compose logs -f

restart:
	@cd $(COMPOSE_DIR) && docker compose restart

ps:
	@cd $(COMPOSE_DIR) && docker compose ps

exec: build up

re: clean all

reset: nbuild up

dexec: down exec

# ================================
# Nettoyage complet Docker
# ================================
clean:
	@echo "🧹 Nettoyage complet Docker..."
	@cd $(COMPOSE_DIR) && docker compose down --volumes
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls | grep -vE "bridge|host|none" | awk '{print $$1}') 2>/dev/null || true

delete-data:
	@echo "❌ Suppression des données persistantes..."
	@rm -rf $(MARIADB_DIR) $(WP_DIR)
	@mkdir -p $(MARIADB_DIR) $(WP_DIR)
	@sudo chown -R $(USER):$(USER) $(DATA_DIR)
	@chmod -R 755 $(DATA_DIR)