#! /bin/bash -e

while [ -n "$1" ]
do
	case $1 in
	--api-endpoint)
		api_endpoint=${2?}
		shift
		;;
	*)
		break
		;;
	esac
	shift
done

if [ -z $api_endpoint ]
then
	api_endpoint="https://platform.microservices.io/graphql"
fi

application=${1?}
service=${2?}
organization=$3

curl -X POST "$api_endpoint" \
-u ${MSAT_ACCESS_KEY_ID?}:${MSAT_SECRET_ACCESS_KEY?} \
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

github_repo=`git remote get-url origin`

curl -X POST "$api_endpoint" \
-u ${MSAT_ACCESS_KEY_ID?}:${MSAT_SECRET_ACCESS_KEY?} \
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
