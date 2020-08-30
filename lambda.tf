resource "aws_lambda_function" "codedeploy_cleanup" {
  function_name    = var.lambda_function_name
  description      = var.lambda_function_description
  role             = aws_iam_role.lambda.arn
  handler          = "codedeploy_cleanup.lambda_handler"
  runtime          = "python3.8"
  timeout          = 30
  source_code_hash = data.archive_file.codedeploy_cleanup.output_base64sha256
  filename         = data.archive_file.codedeploy_cleanup.output_path
  layers = [
    "arn:aws:lambda:${data.aws_region.current.name}:770693421928:layer:Klayers-python38-pytz:2"
  ]
  reserved_concurrent_executions = var.reserved_concurrent_executions
  environment {
    variables = {
      KEEP_ALIVE = var.keep_alive
    }
  }
  tags       = merge(var.tags, var.lambda_function_tags)
  depends_on = [aws_cloudwatch_log_group.lambda]
}
