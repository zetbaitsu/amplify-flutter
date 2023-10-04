const loggingconfig = '''{
      "plugins": {
        "cloudWatchLoggerPluginConfiguration": {
            "enable": true,
            "logGroupName": "<log-group>",
            "region": "<region>",
            "localStoreMaxSizeInMB": 5,
            "flushIntervalInSeconds": 60,
            "defaultRemoteConfiguration": {
                "endpoint": "https://<api.restApiId>.execute-api.<region>.amazonaws.com/prod/loggingconstraints",
                "refreshIntervalInSeconds": 1200
            },
            "loggingConstraints": {
                "defaultLogLevel": "ERROR",
                "categoryLogLevel": {
                        "AUTH": "WARN",
                        "API": "WARN"
                },
                "userLogLevel": {
                    "cognitoSub1": {
                        "defaultLogLevel": "WARN",
                        "categoryLogLevel": {
                            "AUTH": "INFO",
                            "API": "ERROR"
                        }
                    }
                }
            }
        }
      }
}''';