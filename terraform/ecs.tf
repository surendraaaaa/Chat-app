# ECS Cluster
resource "aws_ecs_cluster" "my_ecs" {
  name = var.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# RDS MySQL Database
resource "aws_db_instance" "chatapp_db" {
  identifier           = "chatapp-db"
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = "root"
  password             = "rootroot123"
  db_name              = "chatapp"
  publicly_accessible  = true
  skip_final_snapshot  = true
}

# Backend Task Definition
resource "aws_ecs_task_definition" "backend_td" {
  family                   = "chatapp-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "backend",
      image        = "surendraprajapati/chatapp-backend:latest",
      essential    = true,
      portMappings = [{ containerPort = 5000 }],
      environment = [
        {
          name  = "SPRING_DATASOURCE_URL",
          value = "jdbc:mysql://chatapp-db.c54qqwkqyrpq.us-east-2.rds.amazonaws.com:3306/chatapp"
        },
        { name = "SPRING_DATASOURCE_USERNAME", value = "root" },
        { name = "SPRING_DATASOURCE_PASSWORD", value = "root" }
      ]
    }
  ])
}

# Backend ECS Service
resource "aws_ecs_service" "backend_svc" {
  name            = "chatapp-backend-service"
  cluster         = aws_ecs_cluster.my_ecs.id
  task_definition = aws_ecs_task_definition.backend_td.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    container_name   = "backend"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.app_listener]

}

# Frontend Task Definition
resource "aws_ecs_task_definition" "frontend_td" {
  family                   = "chatapp-frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "frontend",
      image        = "surendraprajapati/chatapp-frontend:latest",
      essential    = true,
      portMappings = [{ containerPort = 80 }],
      environment = [
        { name = "REACT_APP_BACKEND_URL", value = "http://chatapp-backend-service:5000" }
      ]
    }
  ])
}

# Frontend ECS Service
resource "aws_ecs_service" "frontend_svc" {
  name            = "chatapp-frontend-service"
  cluster         = aws_ecs_cluster.my_ecs.id
  task_definition = aws_ecs_task_definition.frontend_td.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "frontend"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.app_listener]
}

