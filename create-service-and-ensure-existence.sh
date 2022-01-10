organization=$1
application=$2
service=$3

curl -X POST "$API_ENDPOINT" \
-u $USER_LOGIN:$USER_PASSWORD \
-d '
  {
    "query": "mutation findOrCreateServiceByName ($serviceName: ServiceName!) { findOrCreateServiceByName (serviceName: $serviceName) { organizationId applicationId serviceId } }",
    "variables": {
        "serviceName": {
          "organization": "'"$organization"'",
          "application": "'"$application"'",
          "service": "'"$service"'"
      }
    }
  }
'
