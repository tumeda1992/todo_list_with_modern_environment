// このディレクトリで `go test -v -timeout 30m`
package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"testing"
	"time"
)

func TestEcsExample(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "./",
	}

	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)

	ecs_task_public_ip := terraform.OutputRequired(t, opts, "ecs_task_public_ip")
	url := fmt.Sprintf("http://%s:30418/healthcheck", ecs_task_public_ip)

	expectedStatusCode := 200
	expectedBody := "{\"status\":\"success\"}"
	maxRetries := 5
	timeBetweenRetries := 30 * time.Second

	http_helper.HttpGetWithRetry(
		t,
		url,
		nil,
		expectedStatusCode,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)
}
