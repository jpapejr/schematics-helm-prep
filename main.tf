data "ibm_resource_group" "resource_group" {
  name = "${var.resource_group}"
}

data "ibm_container_cluster" "cluster" {
    cluster_name_id     = "${var.cluster_name}"
    region              = "${var.region}"
    resource_group_id   = "${data.ibm_resource_group.resource_group.id}"
}


data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = "${data.ibm_container_cluster.cluster.id}"
  resource_group_id = "${data.ibm_resource_group.resource_group.id}"
  region            = "${var.region}"
  config_dir        = "/tmp"
}

resource "kubernetes_service_account" "tiller_service_account" {
  metadata {
    name       = "tiller"
    namespace  = "kube-system"
  }  
}

resource "kubernetes_cluster_role_binding" "tiller-cluster-admin" {
  metadata {
    name = "tiller-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = "kube-system"

  }
}