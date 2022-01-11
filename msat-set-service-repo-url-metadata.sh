#! /bin/bash -e

application=${1?}
service=${2?}
organization=$3

curl -X POST "$MSAT_API_ENDPOINT" \
-u $MSAT_USER_LOGIN:$MSAT_USER_PASSWORD \
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

github_repo=`git remote -v | grep -o "origin\s.*\s(fetch)" | awk '{ print $2 }'`

curl -X POST "$MSAT_API_ENDPOINT" \
-u $MSAT_USER_LOGIN:$MSAT_USER_PASSWORD \
-d '
  {
    "query": "mutation updateServiceMetadata ($organization: String, $applicationName: String!, $serviceName: String!, $metadata: [MetadataInput!]!) {\n    updateServiceMetadata (organization: $organization, applicationName: $applicationName, serviceName: $serviceName, metadata: $metadata)\n}",
    "variables": {
      "organization": "'"$organization"'",
      "applicationName": "'"$application"'",
      "serviceName":"'"$service"'",
      "metadata": {
        "name": "github-repo",
        "value": "'"$github_repo"'"
      }
    }
  }
'
