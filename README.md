# chatGPT-API Introduction

This program provides integration between Siri chatGPT. It allows you to ask Siri a question and have chatGPT answer it.

This is done through a Siri shortcut. The shortcut app will send the question to an AWS Api Gateway endpoint. The endpoint will trigger a lambda function. The lambda function will send the question to the chatGPT API. The API will return an answer. The lambda function will send chatGPT's response back to the shortcut app. The response will then be read out by Siri.

## How the operation works from the users perspective

Invoke the Siri shortcut through the shortcut app, then when prompted by Siri, ask Siri the question you would like to ask chatGPT.

The response from chatGPG will then be read out by Siri.

# Set up

There are 2 parts to the set up. The first part is to set up the AWS resources. The second part is to set up the Siri shortcut.
The AWS resources are created through Terraform. The Siri shortcut is created through the iOS shortcut app.

### AWS resources

All  the AWS resources are created through Terraform.
If Terraform is not installed, install it from [here](https://www.terraform.io/downloads.html).

To verify that Terraform is installed, run the following command:
```
> terraform -v
```


To deploy the AWS resources, run the following command:
```
> terraform apply
```



