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

![Siri shortcut app](./Readme-Images/Siri-Shortcut.PNG)

1. Open the iOS shortcut app.
2. Tap the "+" button in the top right corner.
3. Tap "Add Action".
4. Search for "Ask for" and under `Scripting` tap `Ask for Input`.
5. Under `Prompt` enter whatever you would like Siri to say when the shortcut is triggered. eg "What would you like to ask chatGPT"
6. Add a new action. In the search bar at the bottom of the screen search for "Url". Select `Url` under the `Web` section.
7. Under `Url` enter the API Gateway endpoint that was outputted when the AWS resources were created. For example `https://5jsydgfs.execute-api.ap-southeast-2.amazonaws.com/dev`
8. Add a new action. Under the `Web` section select `Get Contents of Url`.
9. Ensure that the variable after "Get contents of" is `Provided Input`.
10. Expand the `Get Contents of Url` action with the `>` icon.
11. Expand the `Headers` section. Add a new header.
- The header key is `gpt-phrase` 
- The value is the variable `Provided Input`. The variable is selected at the to of the keyboard.
12. Add a new action. Under the `Documents` section select `Get Text From Input`.
13. Add a new action. Under the `Documents` section select `Show Result`.

The shortcut app is now complete. To test it, trigger the shortcut app through Siri. eg "Hey Siri, start chatGPT". Siri will ask for a phrase to send to chatGPT. Say a phrase and Siri will read out chatGPT's response.

# __Limitations__

Siri will time out after 30 seconds. This means that if the response from chatGPT takes longer than 30 seconds, the shortcut will stop and the response will not be read out.