errorNotification Plugin will register to Media_Error event and call to stats.reportError action with the following parameters:
1. resourceUrl - url from the PlayManifest, its value comes from "resourceUrl" variable.
2. error code
3. error message
4. stack trace of the Media_Error

example:
<Plugin id="errorNotification" width="0%" height="0%" includeInLayout="false" resourceUrl="{mediaProxy.resource.url}"/>