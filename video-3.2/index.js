exports.handler = async function (event, context) {
  console.log("Environments Variable: " + JSON.stringify(process.env, null, 2));
  return context.logStreamName;
};
