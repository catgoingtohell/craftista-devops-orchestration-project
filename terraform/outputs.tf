
output "namespace_name" {
  description = "Name of the created namespace"
  value       = kubernetes_namespace.craftista.metadata[0].name
}

output "deployment_name" {
  description = "Name of the deployment"
  value       = kubernetes_deployment.craftista_app.metadata[0].name
}

output "service_name" {
  description = "Name of the service"
  value       = kubernetes_service.craftista_service.metadata[0].name
}

output "ingress_name" {
  description = "Name of the ingress"
  value       = kubernetes_ingress_v1.craftista_ingress.metadata[0].name
}
