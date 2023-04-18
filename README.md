# __ChatGPT-Siri Introduction__

This program provides integration between Siri and ChatGPT. It allows you to ask Siri a question and have chatGPT answer it - which Siri will  read out.

## _Operation Steps_  
  
- You trigger the siri shortcut app through a phrase. eg "Hey Siri, start chatGPT"
- Siri will ask for a phrase to send to chatGPT.
- The shortcut app will send the question to an AWS API Gateway endpoint.  
- The API gateway will trigger a lambda function. The lambda function will send the question to the OpenAI API with chatGPT as the model used.  
- The API will return an answer. The lambda function will send chatGPT's response back to the shortcut app.  
- The response will then be read out by Siri.  

# __Set up__

There are 2 parts to the set up.
1. The first part is to set up the AWS resources. The AWS resources are created automatically through Terraform.
2. The second part is to set up the Siri shortcut app. The Siri shortcut is created through the iOS shortcut app.


## __AWS resources__

All  the AWS resources are created through Terraform.
Ensure Terraform is installed and CLI access to your desired AWS account is configured with your credentials.

To deploy the AWS resources, run:
```
> terraform apply
```

This will create the following resources:
- A lambda function
- An IAM role for the lambda function
- An IAM policy for the lambda function
- An API Gateway 

This will output the API Gateway endpoint. This is the endpoint that the Siri shortcut app in the next section will send the question to.

## __Siri shortcut app__

The Siri shortcut app is created through the iOS shortcut app.

The end result will look like this:

![Siri shortcut app](./Readme-Images/Siri-Shortcut.PNG width=250)

Open the iOS shortcut app.
Tap the "+" button in the top right corner.
Tap "Add Action".
Search for "Ask for" and under "Scripting" tap "Ask for Input".

Add the following confiuration to the shortcut




