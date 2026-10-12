# Curso Udemy Helm

Este repositório tem cinco exemplos principais:

- [01-wordpress-chart](01-wordpress-chart): exemplo de uso de chart pronto do Helm (WordPress via Bitnami).
- [02-own-helm-chart](02-own-helm-chart): exemplo de chart "manual" criado para Nginx.
- [02-sandbox](02-sandbox): sandbox de templates Helm com funcoes e condicionais.
- [04-subcharts](04-subcharts): estrutura com chart pai, app web em Nginx e subchart PostgreSQL.
- [05-plugins](05-plugins): resumo prático de plugins do Helm.
- [06-hooks](06-hooks): exemplo mínimo de hook com Job de migração antes do install/upgrade.

## Pre-requisito

- Kind (Kubernetes in Docker): https://kind.sigs.k8s.io/
