export TAG=$(git rev-parse --abbrev-ref HEAD) ; docker-compose -f docker-compose.yml ps
