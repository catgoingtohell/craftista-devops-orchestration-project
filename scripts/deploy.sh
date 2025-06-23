
#!/bin/bash

set -e

ENVIRONMENT=${1:-staging}
IMAGE_TAG=${2:-latest}

echo "🚀 Deploying Craftista to $ENVIRONMENT environment"
echo "📦 Using image tag: $IMAGE_TAG"

case $ENVIRONMENT in
    "staging")
        echo "🔧 Deploying to staging with Ansible..."
        ansible-playbook ansible/deploy-app.yml \
            -e "namespace=craftista-staging" \
            -e "image_tag=$IMAGE_TAG" \
            -e "app_env=staging"
        ;;
    "production")
        echo "🏗️  Deploying to production with Terraform..."
        cd terraform
        terraform plan -var="image_tag=$IMAGE_TAG" -var="app_env=production"
        echo "⏳ Applying Terraform configuration..."
        terraform apply -auto-approve -var="image_tag=$IMAGE_TAG" -var="app_env=production"
        cd ..
        ;;
    *)
        echo "❌ Unknown environment: $ENVIRONMENT"
        echo "Usage: $0 [staging|production] [image_tag]"
        exit 1
        ;;
esac

echo "✅ Deployment to $ENVIRONMENT completed successfully!"

# Health check
echo "🏥 Performing health check..."
kubectl wait --for=condition=available --timeout=300s deployment/craftista-app -n craftista-$ENVIRONMENT || kubectl wait --for=condition=available --timeout=300s deployment/craftista-app -n craftista

echo "🎉 Deployment successful!"
