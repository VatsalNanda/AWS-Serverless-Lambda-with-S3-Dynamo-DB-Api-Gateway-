exports.handler = async function (event, context) {
  console.log("Event: " + JSON.stringify(event, null, 2));
  console.log(
    "Lambda_event recieved status set to " + event["LAMBDA_EVENT_RECEIVED"]
  );
  return context.logStreamName;
};
