exports.handler = async function (event, context) {
  console.log("Remaining time: " + context.getRemainingTimeInMillis());
  console.log("Function name: " + context.functionName);
  console.log(
    "Memory limit in MB for this function: ",
    context.memoryLimitInMB
  );
  return context.logStreamName;
};
