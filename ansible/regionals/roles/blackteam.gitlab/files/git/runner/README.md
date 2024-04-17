https://artifacthub.io/packages/helm/gitlab/gitlab-runner

0.62.0

helm pull --version 0.62.0 --repo https://charts.gitlab.io gitlab-runner

helm template . --namespace gitlab-runners --set gitlabUrl https://git.99.rust.energy --set rbac: { create: true } --set 