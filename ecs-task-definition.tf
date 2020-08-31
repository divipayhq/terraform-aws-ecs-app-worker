resource "aws_ecs_task_definition" "default" {
  family = "${var.cluster_name}-${var.name}"

  execution_role_arn = var.task_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = <<EOT
[
  {
    "name": "${var.name}",
    "image": "${var.image}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
    "log_configuration": {
      "log_driver": "awslogs",
      "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.default.name}",
          "awslogs-region": "${data.aws_region.current.name}",
          "awslogs-stream-prefix": "app"
      }
    }
  }
]
EOT

  tags = merge(
    var.tags,
    {
      "EcsService" = var.name
      "EcsCluster" = var.cluster_name
    },
  )
}