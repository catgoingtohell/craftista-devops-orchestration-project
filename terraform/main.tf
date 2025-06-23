
terraform {
  required_version = ">= 1.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Create namespace
resource "kubernetes_namespace" "craftista" {
  metadata {
    name = "craftista"
    labels = {
      name = "craftista"
    }
  }
}

# Deploy ConfigMap
resource "kubernetes_config_map" "craftista_config" {
  metadata {
    name      = "craftista-config"
    namespace = kubernetes_namespace.craftista.metadata[0].name
  }

  data = {
    API_URL                   = var.api_url
    APP_ENV                   = var.app_env
    LOG_LEVEL                 = var.log_level
    NGINX_WORKER_PROCESSES    = "auto"
    NGINX_WORKER_CONNECTIONS  = "1024"
  }
}

# Deploy Secret
resource "kubernetes_secret" "craftista_secrets" {
  metadata {
    name      = "craftista-secrets"
    namespace = kubernetes_namespace.craftista.metadata[0].name
  }

  data = {
    db-password = base64encode(var.db_password)
    api-key     = base64encode(var.api_key)
    jwt-secret  = base64encode(var.jwt_secret)
  }

  type = "Opaque"
}

# Deploy application
resource "kubernetes_deployment" "craftista_app" {
  metadata {
    name      = "craftista-app"
    namespace = kubernetes_namespace.craftista.metadata[0].name
    labels = {
      app = "craftista"
    }
  }

  spec {
    replicas = var.replica_count

    selector {
      match_labels = {
        app = "craftista"
      }
    }

    template {
      metadata {
        labels = {
          app = "craftista"
        }
      }

      spec {
        container {
          image = "${var.image_name}:${var.image_tag}"
          name  = "craftista"
          port {
            container_port = 80
          }

          env {
            name = "API_URL"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.craftista_config.metadata[0].name
                key  = "API_URL"
              }
            }
          }

          env {
            name = "APP_ENV"
            value_from {
              config_map_key_ref {
                name = kubernetes_config_map.craftista_config.metadata[0].name
                key  = "APP_ENV"
              }
            }
          }

          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.craftista_secrets.metadata[0].name
                key  = "db-password"
              }
            }
          }

          resources {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# Create service
resource "kubernetes_service" "craftista_service" {
  metadata {
    name      = "craftista-service"
    namespace = kubernetes_namespace.craftista.metadata[0].name
  }

  spec {
    selector = {
      app = "craftista"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

# Create ingress
resource "kubernetes_ingress_v1" "craftista_ingress" {
  metadata {
    name      = "craftista-ingress"
    namespace = kubernetes_namespace.craftista.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer"             = "letsencrypt-prod"
    }
  }

  spec {
    tls {
      hosts       = [var.domain_name]
      secret_name = "craftista-tls"
    }

    rule {
      host = var.domain_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.craftista_service.metadata[0].name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
