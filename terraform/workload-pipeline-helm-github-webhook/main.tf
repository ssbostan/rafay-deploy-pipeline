resource "rafay_namespace" "my_london_tube_lines_namespace" {
  metadata {
    name    = var.application_name
    project = var.project_name
  }
  spec {
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}

resource "rafay_repositories" "my_london_tube_lines_git_repo" {
  metadata {
    name    = var.application_name
    project = var.project_name
  }
  spec {
    type     = "Git"
    endpoint = var.application_git_repo
  }
}

resource "rafay_workload" "my_london_tube_lines_workload" {
  metadata {
    name    = var.application_name
    project = var.project_name
  }
  spec {
    version   = "v1.0.0"
    namespace = rafay_namespace.my_london_tube_lines_namespace.metadata[0].name
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
    artifact {
      type = "Helm"
      artifact {
        revision   = "master"
        repository = rafay_repositories.my_london_tube_lines_git_repo.metadata[0].name
        chart_path {
          name = "/helm"
        }
      }
    }
  }
  depends_on = [
    rafay_namespace.my_london_tube_lines_namespace,
    rafay_repositories.my_london_tube_lines_git_repo
  ]
}

resource "rafay_pipeline" "my_london_tube_lines_pipeline" {
  metadata {
    name    = var.application_name
    project = var.project_name
  }
  spec {
    active = true
    stages {
      name = "deploy"
      type = "DeployWorkload"
      config {
        workload = rafay_workload.my_london_tube_lines_workload.metadata[0].name
      }
    }
    triggers {
      name = var.application_name
      type = "Webhook"
      config {
        repo {
          provider   = "Github"
          repository = rafay_repositories.my_london_tube_lines_git_repo.metadata[0].name
          revision   = "master"
        }
      }
    }
  }
  depends_on = [
    rafay_workload.my_london_tube_lines_workload
  ]
}
