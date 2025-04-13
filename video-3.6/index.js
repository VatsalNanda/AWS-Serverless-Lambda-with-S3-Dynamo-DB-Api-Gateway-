exports.handler = (event, context, callback) => {
  const response = {
    statusCode: 200,
    body: JSON.stringify({ message: "Hello from Lambda with callback!" }),
  };

  callback(null, response); // success
  // callback(error);       // for error
};
