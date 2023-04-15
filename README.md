# chatGPT-API

This program provides a way to ask siri a question and have ChatGPT answer it. 

## How to use

Invoke the Siri shortcut through the shortcut app then ask Siri the question you would like to ask chatGPT.

The shortcut app will send the question to an AWS Api Gateway endpoint. The endpoint will trigger a lambda function.

The lambda function will send the question to the chatGPT model. The model will return an answer. The lambda function will send chatGPT's response  back to the shortcut app.

The response will then be read out by Siri.

## How to set up

### AWS

Create a lambda function. Copy all the text from `app.py` into the lambda function.

Create a new lambda layer that has openai installed. Add the layer to the lambda function.



