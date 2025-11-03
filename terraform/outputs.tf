output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.my_ecs.name
}


output "frontend_service_name" {
  value = aws_ecs_service.frontend_svc.name
}

output "backend_service_name" {
  value = aws_ecs_service.backend_svc.name
}

output "frontend_task_definition_arn" {
  value = aws_ecs_task_definition.frontend_td.arn
}

output "backend_task_definition_arn" {
  value = aws_ecs_task_definition.backend_td.arn
}

output "rds_endpoint" {
  value = aws_db_instance.chatapp_db.endpoint
}


output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_alb.dns_name
}

output "alb_security_group_id" {
  description = "Security group ID for the ALB"
  value       = aws_security_group.alb_sg.id
}

output "ecs_tasks_security_group_id" {
  description = "Security group ID for ECS tasks"
  value       = aws_security_group.ecs_tasks.id
}

